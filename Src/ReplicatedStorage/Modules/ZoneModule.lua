local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeepcopyUtil = require(ReplicatedStorage.Util.DeepcopyUtil)

local Zone = {}

function Zone.new(name: string, npcs: table)
    local self = {}
    self.Name = name
    self.NPCs = npcs
    return self
end

Zone.Zones = {
    ["The Town of The Beginning"] = Zone.new("The Town of The Beginning", {
        ["Human"] = 100,
    })
}

-- { functions } --
function Zone.GetChance(zonename: string, npcname: string)
    if Zone.Zones[zonename] then
        local Value = Zone.Zones[zonename]["NPCs"][npcname]
        return DeepcopyUtil:Copy(Value)
    end
end

function Zone.GetAllNPCs(zonename: string)
    if Zone.Zones[zonename] then
        local Value = Zone.Zones[zonename]["NPCs"]
        return DeepcopyUtil:Copy(Value)
    end
end

return Zone