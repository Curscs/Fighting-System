local Move = {}

function Move.new(name: string, basedmg: number)
    local self = {}
    self.Name = name
    self.BaseDmg = basedmg
    return self
end

Move.Moves = {
    ["Punch"] = Move.new("Punch", 10),
    ["Bite"] = Move.new("Bite", 12)
}

function Move.GetDmg(name: string)
    if Move.Moves[name] then
        return Move.Moves[name]["BaseDmg"]
    end
end

return Move