-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local UIUtil = require(ReplicatedStorage.Util.UIUtil)
local CameraUtil = require(ReplicatedStorage.Util.CameraUtil)
local PlrModule = Player.PlayerScripts:FindFirstChild("PlayerModule") or Player.PlayerScripts:WaitForChild("PlayerModule", 0.1)
local PlayerModule = require(PlrModule)
-- { Camera Util } --
local cameraInstance = workspace.CurrentCamera
local Camera = CameraUtil.Init(cameraInstance)
local functions = CameraUtil.Functions
local shakePresets = CameraUtil.ShakePresets
-- { Misc } --
local Controls = PlayerModule:GetControls()
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local FightFolder = PlayerGui:WaitForChild("Fight")
local OptionsScreen = FightFolder:WaitForChild("Options")
local OptionsFrame = OptionsScreen:WaitForChild("OptionsFrame")
-- { Knit } --
local OptionsController = Knit.CreateController({
    Name = "OptionsController",
})

local Buttons = {}

for _ , Button in pairs(OptionsFrame:GetChildren()) do
    if Button:IsA("TextButton") or Button:IsA("ImageButton") then
        table.insert(Buttons, Button)
    end
end
-- { Functions } --
function OptionsController:Click(button: Instance)
    local MonsterService = Knit.GetService("MonsterService")
    if button.Name == "Escape" then
        if MonsterService:Escape() == "Success" then
            print("Success")
            Controls:Enable()
            Camera:MoveTo(Player.Character.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(90),0) * CFrame.new(0, 5, 10) * CFrame.Angles(math.rad(-20),0,0), 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            task.wait(1)
            Camera:Reset()
            UIUtil.FolderVisiblity("Fight", false)
            UIUtil.FolderVisiblity("Misc", true)
        end
    elseif button.Name == "Punch" then
        MonsterService:Attack(button.Name)
    end
end
-- { Initiation } --
function OptionsController:KnitInit()
    local MonsterService = Knit.GetService("MonsterService")
    for _, button in pairs(Buttons) do
        button.MouseButton1Click:Connect(function()
            self:Click(button)
        end)
    end
    MonsterService.TurnChange:Connect(function(turn: string)
        if turn == "Target" then
            OptionsScreen.Enabled = false
        elseif turn == "Player" then
            OptionsScreen.Enabled = true
        end
    end)
end
return OptionsController