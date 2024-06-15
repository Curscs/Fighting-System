local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local DatastoreModule = require(ServerStorage.Datastore)

local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {},
    DataKey = "v2.6";
    DataTemplate = {
        Coins = 0;
        Gems = 0;
        Eggs = 0;
        Inventory = {
            Swords = {};
            Pets = {};
            Items = {};
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
function DataService.Client:GetData(player, currency: string)
    return DataService.Server:GetData(player, currency)
end
-- { Local Functions } --
function DataService:DiscoverIsland(player, zone: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        if not Datastore.Value["Zones"][zone] then
            Datastore.Value["Zones"][zone] = {
                DiscoverTime = os.time()
            }
        end
    end
end

function DataService:RemoveCurrency(player, currency: string, amount: number)
    local Datastore = DatastoreModule.new(self.DataKey, player.UserId)
    if Datastore then
        if Datastore.Value[currency] >= amount then
            Datastore.Value[currency] -= amount
            if Datastore.Leaderstats then
                Datastore.Leaderstats[currency] -= amount
            end
            return "Success"
        end
    end
end

function DataService:AddCurrency(player, currency: string, amount: number)
    local Datastore = DatastoreModule.new(self.DataKey, player.UserId)
    if Datastore then
        Datastore.Value[currency] += amount
        if Datastore.Leaderstats then
            Datastore.Leaderstats[currency].Value += amount
        end
        return "Success"
    end
end

function DataService:GetData(player, currency: string)
    local Datastore = DatastoreModule.find(self.DataKey, player.UserId)
    if Datastore then
        return Datastore.Value[currency]
    end
end

function DataService:DataCheck(player)
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