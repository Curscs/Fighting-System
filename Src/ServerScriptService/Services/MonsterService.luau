-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local RarityUtil = require(ReplicatedStorage.Util.RarityUtil)
local MoveModule = require(ReplicatedStorage.Modules.MoveModule)
local MonsterModule = require(ReplicatedStorage.Modules.MonsterModule)
-- { Misc } --
-- { GUI } --
-- { Knit } --
local MonsterService = Knit.CreateService({
    Name = "MonsterService",
    Client = {
        TurnChange = Knit.CreateSignal()
    },
    Range = 40,
    DefaultCombat = {
        State = "Idle",
        Target = nil,
        Turn = nil,
        PlayerMadeMove = nil,
        TargetMadeMove = nil
    }
})
-- { Client Functions } --
function MonsterService.Client:Attack(player: Player, name: string)
    self.Server:Attack(player, name)
end
function MonsterService.Client:Escape(player: Player)
    return self.Server:Escape(player)
end

function MonsterService.Client:Click(player: Player, monster: Instance)
    return self.Server:Click(player, monster)
end
-- { Server Functions } --
function MonsterService:Click(player: Player, monster: Instance)
    if (player.Character.PrimaryPart.Position - monster.PrimaryPart.Position).Magnitude <= self.Range then
        if monster:GetAttribute("State") == "Idle" then
            local CombatFolder = player["CombatFolder"]
            monster:SetAttribute("State", "Fighting")
            CombatFolder:SetAttribute("State", "Fighting")
            CombatFolder:SetAttribute("Target", monster.Name)
            CombatFolder:SetAttribute("Turn", "Player")
            task.spawn(function()
                self:Start(player)
            end)
            return "Success"
        end
    end
end

function MonsterService:Attack(player: Player, name: string)
    local CombatFolder = player["CombatFolder"]
    if CombatFolder:GetAttribute("Turn") ~= "Player" then
        return
    elseif CombatFolder:GetAttribute("Turn") == "Player" then
        CombatFolder:SetAttribute("PlayerMadeMove", name)
    end
end

function MonsterService:TargetAttack(player: Player)
    local CombatFolder = player["CombatFolder"]
    if CombatFolder:GetAttribute("Turn") ~= "Target" then
        return
    elseif CombatFolder:GetAttribute("Turn") == "Target" then
        player.Character.Humanoid.Health -= MoveModule.GetDmg("Punch")
    end
end

function MonsterService:Escape(player: Player)
    local CombatFolder = player["CombatFolder"]
    local NPCsFolder = Workspace["Game"]["NPCs"]
    local Chances = {
        ["Success"] = 30,
        ["Fail"] = 70
    }
    local Escape = RarityUtil:SelectRandom(Chances)
    if Escape == "Success" then
        CombatFolder:SetAttribute("State", "Idle")
        CombatFolder:SetAttribute("Turn", nil)
        NPCsFolder[CombatFolder:GetAttribute("Target")]:SetAttribute("State", "Idle")
    elseif Escape == "Fail" then
        CombatFolder:SetAttribute("Turn", "Target")
        CombatFolder:SetAttribute("PlayerMadeMove", "Escape")
    end
    return Escape
end

function MonsterService:Start(player: Player)
    local CombatFolder = player["CombatFolder"]
    local Target = Workspace.Game.NPCs[player["CombatFolder"]:GetAttribute("Target")]
    while Target.Humanoid.Health ~= 0 do
        print(player["CombatFolder"]:GetAttribute("Turn"))
        if player["CombatFolder"]:GetAttribute("Turn") == "Player" then
            local StartTime = os.clock()
            repeat
                task.wait(1)
            until CombatFolder:GetAttribute("PlayerMadeMove") ~= nil or os.clock() - StartTime >= 30
            if CombatFolder:GetAttribute("PlayerMadeMove") ~= nil and CombatFolder:GetAttribute("PlayerMadeMove") ~= "Escape" then
                task.wait(2)
                Target.Humanoid.Health -= MoveModule.GetDmg(CombatFolder:GetAttribute("PlayerMadeMove"))
                CombatFolder:SetAttribute("PlayerMadeMove", nil)
                CombatFolder:SetAttribute("Turn", "Target")
            else
                task.wait(2)
                self:TargetAttack(player)
                CombatFolder:SetAttribute("Turn", "Player")
            end
        elseif player["CombatFolder"]:GetAttribute("Turn") == "Target" then
            task.wait(2)
            CombatFolder:SetAttribute("TargetMadeMove", "Punch")
            self:TargetAttack(player)
            task.wait(2)
            CombatFolder:SetAttribute("Turn", "Player")
        end
    end
end
-- { Initiation } --
function MonsterService:KnitInit()
    game.Players.PlayerAdded:Connect(function(player)
        if Players[player.Name] then
            local CombatFolder = Instance.new("Folder", player)
            CombatFolder.Name = "CombatFolder"

            for name, data in pairs(self.DefaultCombat) do
                CombatFolder:SetAttribute(name, data)
            end
            
            CombatFolder:GetAttributeChangedSignal("Turn"):Connect(function()
                self.Client.TurnChange:Fire(player, CombatFolder:GetAttribute("Turn"))
            end)
        end
    end)
end
return MonsterService
