NumberUtil = {}

NumberUtil.Abbreviations = {"k", "M", "B", "T", "Qa", "Qn", "Sx", "Sp", "Oc", "N"}

local f = math.floor
local l10 = math.log10

function NumberUtil:AbbreviateNumber(number: number, decimals: number)
    return f(((number < 1 and number) or f(number) / 10 ^ (l10(number) - l10(number) % 3)) * 10 ^ (decimals or 3)) / 10 ^ (decimals or 3)..(self.Abbreviations[f(l10(number) / 3)] or "")
end

return NumberUtil