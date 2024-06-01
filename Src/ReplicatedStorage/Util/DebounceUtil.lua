local Debounce = {}

function Debounce:getDebounceStatus(player, key, amount)
    local theTime = player:GetAttribute(key)
    if theTime == nil then
        player:SetAttribute(key, os.clock())
        return true
    end

    if os.clock() - theTime >= amount then
        player:SetAttribute(key, os.clock())
        return true
    end

    return false
end
function Debounce:format(ostime)
    return string.format("%02i:%02i:%02i", ostime / 3600, ostime / 60 % 60, ostime % 60)
end

return Debounce