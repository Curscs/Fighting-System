local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UIUtil = {}

function UIUtil.FolderVisiblity(name: string, visibility: boolean)
    if PlayerGui:FindFirstChild(name) then
        for _, screengui in pairs(PlayerGui:FindFirstChild(name):GetChildren()) do
            screengui.Enabled = visibility
        end
    end
end

return UIUtil