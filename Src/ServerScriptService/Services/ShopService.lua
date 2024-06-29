-- { Services } --
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local Timer = require(ReplicatedStorage.Packages.Timer)
local ShopModule = require(ReplicatedStorage.Modules.ShopModule)
local RarityUtil = require(ReplicatedStorage.Util.RarityUtil)
local DebounceUtil = require(ReplicatedStorage.Util.DebounceUtil)
-- { Knit } --
local ShopService = Knit.CreateService({
    Name = "ShopService",
})
-- { Client Functions } --
function ShopService.Client:Purchase(player: Player, shopname: string, itemnumber: number)
    self.Server:Purchase(player, shopname, itemnumber)
end
-- { Server Functions } --
function ShopService:Purchase(player: Player, shopname: string, itemnumber: number)
    local DataService = Knit.GetService("DataService")
    local InventoryService = Knit.GetService("InventoryService")
    local PlayerData = DataService:GetData(player, "All")
    local ShopData = PlayerData["Shops"]
    local Itemname = ShopData[shopname]["Items"][itemnumber]["Name"]
    local Price = ShopModule.GetItemPrice(shopname,Itemname)
    local ItemType = ShopModule.GetItemType(shopname, Itemname)
    local Currency = ShopModule.GetItemCurrency(shopname, Itemname)
    DebounceUtil:getDebounceStatus(player, "ShopItemPurchase", 0.5)
    if PlayerData[Currency] >= Price then
        if ShopData[shopname]["Items"][itemnumber]["Stock"] > 0 then
            if DataService:RemoveData(player, Currency, Price) == "Success" then
                DataService:UpdateShop(player, shopname, itemnumber, nil, 1, "UpdateItemStock")
                local ID = HttpService:GenerateGUID(false)
                while PlayerData["Inventory"][ItemType][ID] do
                    ID = HttpService:GenerateGUID(false)
                end
                if ItemType == "Swords" then
                    DataService:AddItem(player, "Inventory", ItemType, ID, Itemname)
                    InventoryService.Client.CreateInventoryItem:Fire(player, ItemType, Itemname, ID)
                end
                if ItemType == "Pets" then
                    DataService:AddItem(player, "Inventory", ItemType, ID, Itemname)
                    InventoryService.Client.CreateInventoryItem:Fire(player, ItemType, Itemname, ID)
                end
            end
        end
    end
end
function ShopService:Update(player: Player, name: string)
    local DataService = Knit.GetService("DataService")
    local ShopData = DataService:GetData(player, "Shops")
    local Items = {}
    if not ShopData[name] or ShopData[name]["ResetTime"] < os.time() then
        DataService:UpdateShop(player, name, nil, nil, os.time() + ShopModule.GetResetTime(name), "UpdateShopResetTime")
        for itemname, itemdata in pairs(ShopModule.GetAllItems(name)) do
            Items[itemname] = itemdata["Chance"]
        end
        for i = 1, 8 do
            local RandomItem = RarityUtil:SelectRandom(Items)
            if RandomItem ~= nil then
                local StockData = ShopModule.GetItemStock(name,RandomItem)
                DataService:UpdateShop(player, name, RandomItem, i, StockData, "UpdateShopItem")
            end
        end
        return "Success"
    end
    return "Fail"
end
-- { Initiation } --
function ShopService:KnitInit()
    game.Players.PlayerAdded:Connect(function(player) task.wait(2)
        local AllShops = ShopModule.GetAllShops()
        for _, shopname in ipairs(AllShops) do
            self:Update(player, shopname)
        end
        Timer.Simple(60, function()
            for _, shopname in pairs(AllShops) do
                self:Update(player, shopname)
            end
        end)
    end)
end
return ShopService

