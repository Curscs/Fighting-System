-- { Services } --
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Component = require(ReplicatedStorage.Packages.Component)
local MouseUtil = require(ReplicatedStorage.Util.MouseUtil)
local CameraUtil = require(ReplicatedStorage.Util.CameraUtil)
local UIUtil = require(ReplicatedStorage.Util.UIUtil)
local ModelWrapper = require(ReplicatedStorage.Util.ModelwrapperUtil)
local PlrModule = Player.PlayerScripts:FindFirstChild("PlayerModule") or Player.PlayerScripts:WaitForChild("PlayerModule", 0.1)
local PlayerModule = require(PlrModule)
-- { Camera Util } --
local cameraInstance = workspace.CurrentCamera
local Camera = CameraUtil.Init(cameraInstance)
local functions = CameraUtil.Functions
local shakePresets = CameraUtil.ShakePresets
-- { Misc } --
local Controls = PlayerModule:GetControls()
-- { Knit } --
local Monster = Component.new({
    Tag = "Monster",
})
-- { Functions } --
function Monster:Construct()
    self.ID = self.Instance.Name
    self.Name = nil
    self.Range = 40
    -- { Timer } --
    self.HoverTimer = Timer.new(0.1)
    self.WhileHoveredTimer = Timer.new(0.1)
end

function Monster:Clicked()
    local PlrCharPos = self.Instance.PrimaryPart.CFrame * CFrame.new(0,0,-10)
    local WrappedModel = ModelWrapper.new(self.Instance)
    Controls:Disable()
    WrappedModel:SetCollisions(false)
    Player.Character.Humanoid:MoveTo(PlrCharPos.Position)
    Player.Character.Humanoid.MoveToFinished:Wait()
    WrappedModel:ResetCollisions()
    Player.Character.PrimaryPart.CFrame = PlrCharPos
    Player.Character.PrimaryPart.CFrame = CFrame.lookAt(Player.Character.PrimaryPart.Position, self.Instance.PrimaryPart.Position)
    Camera:MoveTo(self.Instance.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(-90),0) * CFrame.new(-5, 5, 10) * CFrame.Angles(math.rad(-20),0,0), 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    UIUtil.FolderVisiblity("Main", false)
    UIUtil.FolderVisiblity("Misc", false)
    UIUtil.FolderVisiblity("Fight", true)
end

function Monster:Hovered()
    if not self.Instance:FindFirstChild("MonsterOutline") then
        local Outline = ReplicatedStorage.Misc.Outline.MonsterOutline
        local OutlineClone = Outline:Clone()
        OutlineClone.Parent = self.Instance
    end
    if self.Instance["MonsterOutline"].Enabled == false then
        self.Instance["MonsterOutline"].Enabled = true
        self.WhileHoveredTimer:Start()
    end
end
-- { Initiation } --
Monster.Started:Connect(function(self)
    -- detect clicking
    local MonsterService = Knit.GetService("MonsterService")
    UserInputService.InputBegan:Connect(function(input)
        if MouseUtil:TargetClicked(input, "MouseButton1", self.Instance.Name) == "Success" then
            if MonsterService:Click(self.Instance) == "Success" then
                self:Clicked()
            end
        end
    end)

    -- detect hovering
    self.HoverTimer.Tick:Connect(function()
        if self.Instance.PrimaryPart == nil then
            return
        elseif (Player.Character.PrimaryPart.Position - self.Instance.PrimaryPart.Position).Magnitude <= self.Range then
            if MouseUtil:TargetHovered(self.Instance.Name) == "Success" then
                self:Hovered()
            end
        end
    end)

    -- timer for when the outline exists
    self.WhileHoveredTimer.Tick:Connect(function()
        if MouseUtil:TargetHovered(self.Instance.Name) == "Fail" then
            self.WhileHoveredTimer:Stop()
            self.Instance["MonsterOutline"].Enabled = false
        end
    end)

    self.HoverTimer:Start()
end)
Monster.Stopped:Connect(function(self)
    self.HoverTimer:Stop()
end)

return Monster