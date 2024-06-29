local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Sword = {}

function Sword.new(name: string, rarity: string, damage: number)
    local self = {}
    self.Name = name
    self.Rarity = rarity
    self.Damage = damage
    self.Equipped = false
    self.Locked = false
    return self
end

Sword.Swords = {
    ["Wooden Sword"] = Sword.new("Wooden Sword", "Legendary", 10),
}

Sword.Images = {
    ["Wooden Sword"] = "rbxassetid://17898900492"
}
function Sword.GetSwordStat(swordname: string, statname: string)
    if Sword.Swords[swordname] then
        return Sword.Swords[swordname][statname]
    end
end
function Sword.GetAllStats(name: string)
    if Sword.Swords[name] then
        local Value = Sword.Swords[name]
        return TableUtil.Copy(Value, true)
    end
end
function Sword.GetSwordImage(name: string)
    if Sword.Swords[name] then
        return Sword.Images[name]
    end
end

return Sword