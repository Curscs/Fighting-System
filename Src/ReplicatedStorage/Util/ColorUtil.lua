local ColorUtil = {}

function ColorUtil.from_hex(hex: string): Color3
    local r, g, b = string.match(hex, "^#?(%w%w)(%w%w)(%w%w)$")
    return Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
end

function ColorUtil.to_hex(color: Color3): string
    return string.format("#%02X%02X%02X", color.R * 0xFF,color.G * 0xFF, color.B * 0xFF)
end

return ColorUtil