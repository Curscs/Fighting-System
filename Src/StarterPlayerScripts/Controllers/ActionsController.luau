-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local DebounceUtil  = require(ReplicatedStorage.Util.DebounceUtil)
-- { Misc } --
local Player = Players.LocalPlayer
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local FightFolder = PlayerGui:WaitForChild("Fight")
local ActionsScreen = FightFolder:WaitForChild("Actions")
local ActionsFrame = ActionsScreen:WaitForChild("ActionsFrame")
local ActionsLabel = ActionsFrame:WaitForChild("ActionsLabel")
-- { Knit } --
local ActionsController = Knit.CreateController({
    Name = "ActionsController",
})
-- { Functions } --

-- { Initiation } --
function ActionsController:KnitInit()
    local CombatFolder = Player["CombatFolder"]
    CombatFolder:GetAttributeChangedSignal("State"):Connect(function()
        if CombatFolder:GetAttribute("State") == "Fighting" then
            ActionsScreen.Enabled = true
        elseif CombatFolder:GetAttribute("Turn") == "Idle" then
            ActionsScreen.Enabled = false
        end
    end)
    CombatFolder:GetAttributeChangedSignal("Turn"):Connect(function()
        if CombatFolder:GetAttribute("Turn") == "Player" then
            ActionsLabel.Text = "Choose your next move"
        elseif CombatFolder:GetAttribute("Turn") == "Target" then
            ActionsLabel.Text = "Your oponent is choosing a move"
        end
    end)
    CombatFolder:GetAttributeChangedSignal("PlayerMadeMove"):Connect(function()
        if CombatFolder:GetAttribute("PlayerMadeMove") ~= nil then
            ActionsLabel.Text = Player.Name .. " Used " .. CombatFolder:GetAttribute("PlayerMadeMove")
        end
    end)
    CombatFolder:GetAttributeChangedSignal("TargetMadeMove"):Connect(function()
        local Target = Workspace.Game.NPCs[CombatFolder:GetAttribute("Target")]
        if CombatFolder:GetAttribute("TargetMadeMove") ~= nil then
            ActionsLabel.Text = Target:GetAttribute("Name") .. " Used " .. CombatFolder:GetAttribute("TargetMadeMove")
        end
    end)
end

return ActionsController