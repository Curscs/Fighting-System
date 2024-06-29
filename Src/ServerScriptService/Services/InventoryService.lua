local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local InventoryService = Knit.CreateService({
    Name = "InventoryService",
    Client = {
        CreateInventoryItem = Knit.CreateSignal(),
    }
})

function InventoryService:KnitInit()
    game.Players.PlayerAdded:Connect(function(player) task.wait(2)
        local DataService = Knit.GetService("DataService")
        local PlayerData = DataService:GetData(player, "All")
        for id, data in pairs(PlayerData["Inventory"]["Swords"]) do
            self.Client.CreateInventoryItem:Fire(player, "Swords", data["Name"], id)
        end
        for id, data in pairs(PlayerData["Inventory"]["Pets"]) do
            self.Client.CreateInventoryItem:Fire(player, "Pets", data["Name"], id)
        end
        print(PlayerData)
    end)
end

return InventoryService