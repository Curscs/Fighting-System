local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RNG = Random.new()
local RarityUtil = {}

function RarityUtil:SelectRandom(items: table)
    if not items then
        return nil
    end
    local SmallestWeight = nil
    for _, chance in pairs(items) do
        if  chance > 0 then
            if not SmallestWeight or chance < SmallestWeight then
                SmallestWeight = chance
            end
        end
    end

    if not SmallestWeight then
        return nil
    end
    local ScaleFactor = 1 / SmallestWeight
    ScaleFactor = math.ceil(ScaleFactor)

    local TotalChance = 0
    for _, chance in pairs(items) do
        TotalChance += chance * ScaleFactor
    end

    local RandomNumber = RNG:NextNumber(1,TotalChance)

    local TempChance = 0
    for name, chance in pairs(items) do
        TempChance += chance
        if RandomNumber <= TempChance then
            return name
        end
    end
end

return RarityUtil