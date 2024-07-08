local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local Pet = {}

function Pet.new(name: string, rarity: string, state: string, power: number, moveset: table)
    local self = {}
    self.Name = name
    self.Rarity = rarity
    self.Power = power
    self.Moveset = moveset
    self.State = state
    self.Shiny = false
    self.Equipped = false
    self.Locked = false
    self.Level = 0
    self.Date = 0
    return self
end

Pet.Pets = {
    ["Doggy"] = Pet.new("Doggy", "Common", "Flying", 1, {"Bite"}),
    ["Kitty"] = Pet.new("Kitty", "Common", "Walking", 1, {"Bite"}),
    ["???"] = Pet.new("???", "Chromatic", "Flying", 1, {"Bite"}),
}

Pet.Images = {
    ["Doggy"] = "rbxassetid://15001919673",
    ["Kitty"] = "rbxassetid://15001944854",
    ["???"] = "rbxassetid://15432067950",
}

-- { Functions } --
function Pet.GetPetStat(name: string, stat: string)
    if Pet.Pets[name] then
        return Pet.Pets[name][stat]
    end
end
function Pet.GetAllStats(name: string)
    if Pet.Pets[name] then
        local Value = Pet.Pets[name]
        return TableUtil.Copy(Value, true)
    end
end
function Pet.GetPetImage(name: string)
    if Pet.Images[name] then
        return Pet.Images[name]
    end
end

return Pet