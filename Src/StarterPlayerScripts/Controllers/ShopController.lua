-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberUtil = require(ReplicatedStorage.Util.NumberUtil)
local ShopModule = require(ReplicatedStorage.Modules.ShopModule)
local SwordModule = require(ReplicatedStorage.Modules.SwordModule)
local PotionModule = require(ReplicatedStorage.Modules.PotionModule)
local PetModule = require(ReplicatedStorage.Modules.PetModule)
-- { Misc } --
local Player = Players.LocalPlayer
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local MainFolder = PlayerGui:WaitForChild("Main")
local ShopScreen = MainFolder:WaitForChild("Shop")
local ShopFrame = ShopScreen:WaitForChild("ShopFrame")
local Container = ShopFrame:WaitForChild("Container")
local Template = Container:WaitForChild("Template")
-- { Knit } --
local ShopController = Knit.CreateController({
    Name = "ShopController",
    Client = {}
})
-- { Functions } --
function ShopController:Purchase(shopname: string, itemnumber: number)
    local ShopService = Knit.GetService("ShopService")
    ShopService:Purchase(shopname,itemnumber)
    ShopController:Update(shopname)
end
function ShopController:Update(name: string)
    local DataService = Knit.GetService("DataService")
    local ShopData = DataService:GetData("Shops")
    if not Container:FindFirstChild("8") then
        for number, itemdata in ipairs(ShopData[name]["Items"]) do
            local TemplateClone = Template:Clone()
            TemplateClone.Parent = Container
            TemplateClone.Name = number
            TemplateClone.Visible = true
            TemplateClone["Buy"].MouseButton1Click:Connect(function()
                self:Purchase(name, number)
            end)
        end
    end
    for number, itemdata in ipairs(ShopData[name]["Items"]) do
        local TemplateClone = Container[number]
        TemplateClone["Buy"]["Price"].Text = NumberUtil:AbbreviateNumber(ShopModule.GetItemPrice(name, itemdata["Name"]), 3)
        TemplateClone["Item"]["Stock"].Text = ShopData[name]["Items"][number]["Stock"] .. "/" .. ShopModule.GetItemStock(name, itemdata["Name"])
        TemplateClone["Item"]["ItemName"].Text = itemdata["Name"]
        if ShopModule.GetItemType(name, itemdata["Name"]) == "Swords" then
            TemplateClone["Item"].Image = SwordModule.GetSwordImage(itemdata["Name"])
        elseif ShopModule.GetItemType(name, itemdata["Name"]) == "Potions" then
            TemplateClone["Item"].Image = PotionModule.GetPotionImage(itemdata["Name"])
        elseif ShopModule.GetItemType(name, itemdata["Name"]) == "Pets"  then
            TemplateClone["Item"].Image = PetModule.GetPetImage(itemdata["Name"])
        end
    end
end
function ShopController:Trigger(status: boolean, name: string)
    if status == true then
        self:Update(name)
        ShopScreen.Enabled = true
    elseif status == false then
        ShopScreen.Enabled = false
    end
end
-- { Initiation } --
return ShopController