-- { Services } --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local DatastoreModule = require(ServerStorage.Datastore)
local SwordModule = require(ReplicatedStorage.Modules.SwordModule)
local PetModule = require(ReplicatedStorage.Modules.PetModule)
-- { Knit } --
local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {},
    DataKey = "v4.04";
    DataTemplate = {
        Coins = 100000;
        Gems = 0;
        Eggs = 0;
        Inventory = {
            Swords = {};
            Pets = {};
            Items = {};
            Moves = {"Punch"}
        };
        Shops = {};
        Zones = {
            ["The Town of The Beginning"] = {
                DiscoverTime = 0
            }
        };
        Misc = {
            InventorySpace = 100;
        }
    };
    DataDisplay = {"Coins", "Gems", "Eggs"};
    CurrencyImages = {
        ["Coins"] = "rbxassetid://11566087944"
    }
}
-- { Client Functions } --
function DataService.Client:GetData(player: Player, currency: string)
    return self.Server:GetData(player, currency)
end
-- { Local Functions } --
function DataService:DiscoverIsland(player: Player, zone: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        if not Datastore.Value["Zones"][zone] then
            Datastore.Value["Zones"][zone] = {
                DiscoverTime = os.time()
            }
        end
    end
end

function DataService:RemoveData(player: Player, currency: string, amount: number)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        if Datastore.Value[currency] >= amount then
            Datastore.Value[currency] -= amount
            if Datastore.Leaderstats then
                Datastore.Leaderstats[currency].Value -= amount
            end
            return "Success"
        end
    end
end

function DataService:AddItem(player: Player, data: string, data2: string, data3: string, data4: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if data2 == "Swords" then
        local SwordData = SwordModule.GetAllStats(data4)
        Datastore.Value[data][data2][data3] = {
            ["Name"] = SwordData["Name"],
            ["Damage"] = SwordData["Damage"],
            ["Equipped"] = SwordData["Equipped"],
            ["Locked"] = SwordData["Locked"]
        }
    elseif data2 == "Pets" then
        local PetData = PetModule.GetAllStats(data4)
        Datastore.Value[data][data2][data3] = {
            ["Name"] = PetData["Name"],
            ["Level"] = PetData["Level"],
            ["Equipped"] = PetData["Equipped"],
            ["Locked"] = PetData["Locked"]
        }
    end
end

function DataService:UpdateShop(player: Player, data: string | number, data2: string | number, data3: string | number, amount: number | table, type: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        if type == "UpdateShopResetTime" then
            if typeof(Datastore.Value["Shops"][data]) ~= "table" then
                Datastore.Value["Shops"][data] = {}
            end
            Datastore.Value["Shops"][data]["ResetTime"] = amount

            return "Success"
        elseif type == "UpdateShopItem" then
            if typeof(Datastore.Value["Shops"][data]["Items"]) ~= "table" then
                Datastore.Value["Shops"][data]["Items"] = {}
            end
            Datastore.Value["Shops"][data]["Items"][data3] = {
                ["Name"] = data2,
                ["Stock"] = amount
            }

            return "Success"
        elseif type == "UpdateItemStock" then
            print(Datastore.Value["Shops"][data])
            Datastore.Value["Shops"][data]["Items"][data2]["Stock"] -= 1

            return "Success"
        end
    end
end

function DataService:AddData(player: Player, data: string, amount: number | table)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        Datastore.Value[data] += amount
        if Datastore.Leaderstats then
            Datastore.Leaderstats[data].Value += amount
        end
        return "Success"
    end
    return "Fail"
end

function DataService:GetData(player: Player, currency: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore and currency ~= "All" then
        return Datastore.Value[currency]
    end
    if currency == "All" then
        return Datastore.Value
    end
end

function DataService:DataCheck(player: Player)
    local Datastore = DatastoreModule.new(self.DataKey, player.UserId)
    while Datastore.State ~= true do
        task.wait(0.1)
    end
    while not player:FindFirstChild("leaderstats") do
        task.wait(0.1)
    end
    return "Success"
end

-------------------------------

function CreateDatastore()
    local function StateChanged(state, datastore)
        while datastore.State == false do
            if datastore:Open(DataService.DataTemplate) ~= "Success" then task.wait(6) end
        end
    end
    game.Players.PlayerAdded:Connect(function(player)
        local Datastore = DatastoreModule.new(DataService.DataKey, player.UserId)
        Datastore.StateChanged:Connect(StateChanged)
        StateChanged(Datastore.State, Datastore)
    end)
    game.Players.PlayerRemoving:Connect(function(player)
        local Datastore = DatastoreModule.find(DataService.DataKey, player.UserId)
        if Datastore ~= nil then Datastore:Destroy() end
    end)
end

function CreateLeaderstats()
    local function StateChanged(datastore, state, player, leaderstats)
        while state ~= true do return end
        if DataService:DataCheck(player) == "Success" then
            for i, stat in pairs(leaderstats:GetChildren()) do
                datastore.Leaderstats[stat.Name].Value = datastore.Value[stat.Name]
            end
        end
    end
    game.Players.PlayerAdded:Connect(function(player)
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player

        for _, stat in pairs(DataService.DataDisplay) do
            if DataService.DataTemplate[stat] then
                local IntValue = Instance.new("IntValue")
                IntValue.Name = stat
                IntValue.Parent = leaderstats
            end
        end

        local Datastore = DatastoreModule.new(DataService.DataKey, player.UserId)
        Datastore.Leaderstats = leaderstats
        Datastore.StateChanged:Connect(function()
            StateChanged(Datastore, Datastore.State, player, leaderstats)
        end)
    end)
end
-- { Run Line } --
function DataService:KnitStart()
    CreateDatastore()
    CreateLeaderstats()
end

return DataService