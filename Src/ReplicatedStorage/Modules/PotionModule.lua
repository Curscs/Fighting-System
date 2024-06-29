local Potion = {}

function Potion.new(name: string, type: string, duration: number, image: string)
    local self = {}
    self.Name = name
    self.Type = type
    self.Duration = duration
    self.Image = image
    return self
end

Potion.Potions = {
    ["Luck Potion"] = Potion.new("Luck Potion", "Luck", 300, "rbxassetid://17899315744")
}

function Potion.GetPotionImage(name: string)
    if Potion.Potions[name] then
        return Potion.Potions[name]["Image"]
    end
end

return Potion