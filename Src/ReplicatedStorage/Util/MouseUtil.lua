local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local MouseUtil = {}
local Mouse = Player:GetMouse()

function MouseUtil:TargetClicked(input: InputObject, requiredinput:string, target: string)
    if self:TargetHovered(target) == "Success" then
        if input.UserInputType == Enum.UserInputType[requiredinput] then
            return "Success"
        else
            return "Fail"
        end
    end
end

function MouseUtil:TargetHovered(target: string)
    if Mouse.Target then
        if Mouse.Target:FindFirstAncestorWhichIsA("Model").Name == target then
            return "Success"
        else
            return "Fail"
        end
    end
end

return MouseUtil