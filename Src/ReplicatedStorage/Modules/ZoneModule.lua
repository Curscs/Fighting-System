local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
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
        return TableUtil.Copy(Value, true)
    end
end

function Zone.GetAllNPCs(zonename: string)
    if Zone.Zones[zonename] then
        local Value = Zone.Zones[zonename]["NPCs"]
        return TableUtil.Copy(Value, true)
    end
end

return Zone