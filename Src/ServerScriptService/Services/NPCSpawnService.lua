local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local ZoneModule = require(ReplicatedStorage.Modules.ZoneModule)
local RarityUtil = require(ReplicatedStorage.Util.RarityUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local RNG = Random.new()

local NPCSpawnService = Knit.CreateService({
    Name = "NPCSpawnService",
    Client = {}
})

function NPCSpawnService:DespawnNPCs(zonename: string)
    local NPCFolder = Workspace.Game.NPCs[zonename]
    for _, npc in pairs(NPCFolder:GetChildren()) do
        npc:Destroy()
    end
end

function NPCSpawnService:SpawnNPC(zonename: string)
    local SelectedNPC = RarityUtil:SelectRandom(ZoneModule.GetAllNPCs(zonename))
    local NPCRepFolder = ReplicatedStorage.Items.NPCs
    local NPCClone = NPCRepFolder[SelectedNPC]:Clone()
    local ID = HttpService:GenerateGUID(false)

    local function CheckID()
        local GameFolder = Workspace.Game.NPCs
        local existingIDs = {}
        for _, obj in pairs(GameFolder:GetChildren()) do
            existingIDs[obj.Name] = true
        end
        while existingIDs[ID] do
            ID = HttpService:GenerateGUID(false)
        end
    end

    local AreaInstance = Workspace.Game.Boxes.NPCSpawns[zonename]
    local AreaSize = AreaInstance.Size / 2
    local XPos = RNG:NextNumber(-AreaSize.X, AreaSize.X)
    local YPos = 0
    local ZPos = RNG:NextNumber(-AreaSize.Z, AreaSize.Z)
    local MainPos = Vector3.new(AreaInstance.Position.X, 0, AreaInstance.Position.Z)
    local OffsetPos = Vector3.new(XPos, YPos, ZPos)
    local SpawnPos = MainPos + OffsetPos
    local NPCScale = NPCClone:GetScale()

    local FilterInstances = {}
    -- blacklist Zones
    for _, child in ipairs(Workspace.Game.Boxes.Zones:GetChildren()) do
        table.insert(FilterInstances, child)
    end
    -- blacklist NPCSpawns
    for _, child in ipairs(Workspace.Game.Boxes.NPCSpawns:GetChildren()) do
        table.insert(FilterInstances, child)
    end
    -- blacklist Player Characters
    for _, child in ipairs(Players:GetPlayers()) do
        table.insert(FilterInstances, child.Character)
    end

    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = FilterInstances
    Params.FilterType = Enum.RaycastFilterType.Blacklist
    local RaycastResult = Workspace:Raycast(Vector3.new(SpawnPos.X, 30, SpawnPos.Z), -Vector3.yAxis * 30, Params)
    if RaycastResult then
        YPos = RaycastResult.Position.Y
    end

    OffsetPos = Vector3.new(XPos, YPos + 3 * NPCScale, ZPos)
    SpawnPos = MainPos + OffsetPos

    if not Workspace.Game.NPCs:FindFirstChild(zonename) then
        local Folder = Instance.new("Folder")
        Folder.Name = zonename
        Folder.Parent = Workspace.Game.NPCs
    end

    CheckID()
    NPCClone.Parent = Workspace.Game.NPCs[zonename]
    NPCClone.Name = ID
    NPCClone:SetAttribute("Name", SelectedNPC)
    NPCClone:PivotTo(CFrame.new(SpawnPos))
    NPCClone:AddTag("Monster")
end

return NPCSpawnService