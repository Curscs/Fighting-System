local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RNG = Random.new()

local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ZonePlus = require(ReplicatedStorage.Packages.Zone)

local ZoneModule = require(ReplicatedStorage.Modules.ZoneModule)

local DebounceUtil = require(ReplicatedStorage.Util.DebounceUtil)

local DataService = Knit.GetService("DataService")
local Workspace = game:GetService("Workspace")

local Zone= Component.new({
    Tag = "Zone",
})

function Zone:Construct()
    -- { Zone } --
    self.Zone = ZonePlus.new(self.Instance)
    self.Name = self.Instance:GetAttribute("Name")
    self.Trove = Trove.new()
    -- { Npc } --
    self.RespawnTime = 30
    self.Amount = self.Instance:GetAttribute("Amount")
end

function Zone:SpawnNPC()
    print("SpawnNPC")
    local NPCsFolder = ReplicatedStorage.Items.NPCs
    local WorkFolder = Workspace.Game.Zones
    local ZonesFolder = WorkFolder[self.Name]
    local SelectedNPC = self:SelectNPC()
    if SelectedNPC == nil then
        return
    end
    local NPCClone = NPCsFolder[SelectedNPC]:Clone()
    local AreaSize = self.Instance.Size / 2
    local XPos = RNG:NextNumber(-AreaSize.X, AreaSize.X)
    local ZPos = RNG:NextNumber(-AreaSize.Z, AreaSize.Z)
    local YPos = 3
    local OffsetPos = Vector3.new(XPos, YPos, ZPos)
    local x = Vector3.new(self.Instance.Position.X,0,self.Instance.Position.Z)
    local SpawnPos = x + OffsetPos
    NPCClone:PivotTo(CFrame.new(SpawnPos))
    NPCClone.Parent = ZonesFolder
    NPCClone:AddTag("NPC")
end

function Zone:Setup()
    print("Setup")
    local WorkFolder = Workspace.Game.Zones

    local ZonesFolder = Instance.new("Folder")
    ZonesFolder.Parent = WorkFolder
    ZonesFolder.Name = self.Name

    for i = 1 , self.Amount do
        self:SpawnNPC()
    end
end

function Zone:SelectNPC()
    -- Retrieve all NPCs and their weights
    local NPCs = ZoneModule.GetAllNPCs(self.Name)
    if not NPCs or next(NPCs) == nil then
        return nil
    end
    local smallestWeight = nil
    for _, Chance in pairs(NPCs) do
        if Chance > 0 then
            if not smallestWeight or Chance < smallestWeight then
                smallestWeight = Chance
            end
        end
    end

    if not smallestWeight then
        print("Invalid NPC weights.")
        return nil
    end

    local scaleFactor = 1 / smallestWeight
    scaleFactor = math.ceil(scaleFactor)

    local TotalChance = 0
    for _, Chance in pairs(NPCs) do
        TotalChance += Chance * scaleFactor
    end

    local RandomNumber = math.random(1, TotalChance)

    local TempChance = 0
    for Name, Chance in pairs(NPCs) do
        TempChance += Chance * scaleFactor
        if RandomNumber <= TempChance then
            return Name
        end
    end
end

function Zone:DisplayName(player)
    local PlayerGui = player:WaitForChild("PlayerGui")
    local ZoneText = PlayerGui:WaitForChild("ZoneText")
    local Top = ZoneText:WaitForChild("Top")
    local TextLabel = Top:WaitForChild("TextLabel")
    local Underline = Top:WaitForChild("Underline")

    local guiElementX = TextLabel
    local guiStrokeX = guiElementX["UIStroke"]
    local guiElementY = Underline
    local guiStrokeY = guiElementY["UIStroke"]

    TextLabel.Text = self.Name
    ZoneText.Enabled = true
    guiElementX.TextTransparency = 1
    guiStrokeX.Transparency = 1
    guiElementY.Transparency = 1
    guiStrokeY.Transparency = 1

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tweens = {
        game:GetService("TweenService"):Create(guiElementX, tweenInfo, {TextTransparency = 0}),
        game:GetService("TweenService"):Create(guiStrokeX, tweenInfo, {Transparency = 0}),
        game:GetService("TweenService"):Create(guiElementY, tweenInfo, {Transparency = 0}),
        game:GetService("TweenService"):Create(guiStrokeY, tweenInfo, {Transparency = 0})
    }
    local tweens2 = {
        game:GetService("TweenService"):Create(guiElementX, tweenInfo, {TextTransparency = 1}),
        game:GetService("TweenService"):Create(guiStrokeX, tweenInfo, {Transparency = 1}),
        game:GetService("TweenService"):Create(guiElementY, tweenInfo, {Transparency = 1}),
        game:GetService("TweenService"):Create(guiStrokeY, tweenInfo, {Transparency = 1})
    }

    for _, tween in ipairs(tweens) do
        tween:Play()
    end

    task.wait(3)

    for _, tween in ipairs(tweens2) do
        tween:Play()
    end

    -- Disable ZoneText after fade out
    tweens[1].Completed:Connect(function()
        ZoneText.Enabled = false
    end)
end


function Zone:Init()
    self:Setup()
    self.Zone.playerEntered:Connect(function(Player)
        if Player == nil then
            return
        end
        local ZoneData = DataService:GetData(Player, "Zones")
        if not ZoneData[self.Name] then
            if DebounceUtil:getDebounceStatus(Player, "ZoneEnter", 3) then
                self:DisplayName(Player)
            end
        elseif ZoneData[self.Name] then
            if DebounceUtil:getDebounceStatus(Player, "ZoneEnter", 3) then
                self:DisplayName(Player)
            end
        end
    end)
    self.Zone.playerExited:Connect(function(Player)
        print("Exited discovered zone")
    end)
    RunService.Heartbeat:Connect(function()
        local x = CollectionService:GetTagged("NPC")
        if #x < self.Amount then
            local y = self.Amount - #x
            for i = 1, y do
                self:SpawnNPC()
            end
        end
    end)
end

Zone.Started:Connect(function(self)
    self:Init()
end)

Zone.Stopped:Connect(function(self)
    self.Zone:destroy()
end)

return Zone