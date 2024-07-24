local Monster = {}

function Monster.new(name: string, type: string, health: number, moveset: table)
    local self = {}
    self.Name = name
    self.Type = type
    self.Health = health
    self.Moveset = moveset
    return self
end

Monster.Monsters = {
    ["Human"] = Monster.new("Human", "Humanoid", 150, {"Punch"})
}

return Monster

