local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Timer = require(ReplicatedStorage.Packages.Timer)
local ZonePlus = require(ReplicatedStorage.Packages.Zone)

local NPCSpawnService = Knit.GetService("NPCSpawnService")

local NPCSpawn = Component.new({
    Tag = "NPCSpawn",
})

function NPCSpawn:Construct()
    self.Zone = ZonePlus.new(self.Instance)
    self.Name = self.Instance:GetAttribute("Name")
    self.Amount = self.Instance:GetAttribute("Amount")
    self.Respawn = self.Instance:GetAttribute("Respawn")
    self.Trove = Trove.new()
end

function NPCSpawn:Init()
    for i = 1, self.Amount do
        NPCSpawnService:SpawnNPC(self.Name)
    end
end

NPCSpawn.Started:Connect(function(self)
    self:Init()
end)

NPCSpawn.Stopped:Connect(function(self)
end)

return NPCSpawn