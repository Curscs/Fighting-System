-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local SwordModule = require(ReplicatedStorage.Modules.SwordModule)
local PetModule = require(ReplicatedStorage.Modules.PetModule)
local ColorUtil = require(ReplicatedStorage.Util.ColorUtil)
-- { Misc } --
local Player = Players.LocalPlayer
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local MainFolder = PlayerGui:WaitForChild("Main")
local InventoryScreen = MainFolder:WaitForChild("Inventory")
local InventoryFrame = InventoryScreen:WaitForChild("InventoryFrame")
local UIScale = InventoryFrame:WaitForChild("UIScale")

local ItemsTemplatesFolder = InventoryFrame:WaitForChild("ItemsTemplates")
local ItemsTemplates = {
    NormalTemplate = ItemsTemplatesFolder:WaitForChild("NormalTemplate"),
    LegendaryTemplate = ItemsTemplatesFolder:WaitForChild("LegendaryTemplate"),
    SecretTemplate = ItemsTemplatesFolder:WaitForChild("SecretTemplate"),
    ChromaticTemplate = ItemsTemplatesFolder:WaitForChild("ChromaticTemplate"),
}

local RightFrame = InventoryFrame:WaitForChild("Right")
local PetsButton = RightFrame:WaitForChild("PetsButton")
local SwordsButton = RightFrame:WaitForChild("SwordsButton")

local PetsContent = InventoryFrame:WaitForChild("Pets")
local SwordsContent = InventoryFrame:WaitForChild("Swords")

local StatsTemplates = InventoryFrame:WaitForChild("StatsTemplates")
local CardsTemplates = {
    NormalPetCard = StatsTemplates:WaitForChild("NormalPetCard")
}
-- { Knit } --
local InventoryController = Knit.CreateController({
    Name = "InventoryController",
})
-- { Functions } --
function InventoryController:ItemTriggered(type: string, name: string, rarity: string, image: string, iteminstance: Instance)
    local TemplateClone = CardsTemplates.NormalPetCard
    if rarity == "Legendary" then
        CardsTemplates.NormalPetCard.BackgroundColor3 = ColorUtil.from_hex("#ffffff")
        local Gradient = CardsTemplates.NormalPetCard.UIGradient
        local colorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ColorUtil.from_hex("#e17324")),
            ColorSequenceKeypoint.new(0.256, ColorUtil.from_hex("#f4ac39")),
            ColorSequenceKeypoint.new(0.483, ColorUtil.from_hex("#ecff8c")),
            ColorSequenceKeypoint.new(0.735, ColorUtil.from_hex("#f8ce51")),
            ColorSequenceKeypoint.new(1, ColorUtil.from_hex("#ffb22c"))
        })
        Gradient.Rotation = -62
        Gradient.Color = colorSequence
        Gradient.Enabled = true
        CardsTemplates.NormalPetCard.BackgroundImage.Image = "rbxassetid://18139269250"
        CardsTemplates.NormalPetCard.BackgroundImage.ImageTransparency = 0
        CardsTemplates.NormalPetCard.BackgroundImage.ImageColor3 = ColorUtil.from_hex("#ffffff")
        CardsTemplates.NormalPetCard.BackgroundImage.ScaleType = "Tile"
        CardsTemplates.NormalPetCard.BackgroundImage.TileSize = UDim2.new(1,0,0.4,0)

        CardsTemplates.NormalPetCard.LevelBar.BackgroundColor3 = ColorUtil.from_hex("#b48823")
        CardsTemplates.NormalPetCard.Stats.Template.StatAmount.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.ItemName.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.Date.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.Rarity.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.LevelBar.UIStroke.Color = ColorUtil.from_hex("#7e6118")
        CardsTemplates.NormalPetCard.LevelBar.Level.UIStroke.Color = ColorUtil.from_hex("#7e6118")
    elseif rarity == "Secret" then
        CardsTemplates.NormalPetCard.BackgroundColor3 = ColorUtil.from_hex("#ffffff")
        local Gradient = CardsTemplates.NormalPetCard.UIGradient
        local colorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ColorUtil.from_hex("#8c1717")),
            ColorSequenceKeypoint.new(0.299, ColorUtil.from_hex("#d83436")),
            ColorSequenceKeypoint.new(0.498, ColorUtil.from_hex("#f89193")),
            ColorSequenceKeypoint.new(0.692, ColorUtil.from_hex("#e34e51")),
            ColorSequenceKeypoint.new(1, ColorUtil.from_hex("#d12f2f"))
        })
        Gradient.Rotation = -62
        Gradient.Color = colorSequence
        Gradient.Enabled = true
        CardsTemplates.NormalPetCard.BackgroundImage.Image = "rbxassetid://18139269250"
        CardsTemplates.NormalPetCard.BackgroundImage.ImageTransparency = 0
        CardsTemplates.NormalPetCard.BackgroundImage.ImageColor3 = ColorUtil.from_hex("#ffffff")
        CardsTemplates.NormalPetCard.BackgroundImage.ScaleType = "Tile"
        CardsTemplates.NormalPetCard.BackgroundImage.TileSize = UDim2.new(1,0,0.4,0)

        CardsTemplates.NormalPetCard.LevelBar.BackgroundColor3 = ColorUtil.from_hex("#9d1a20")
        CardsTemplates.NormalPetCard.Stats.Template.StatAmount.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.ItemName.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.Date.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.Rarity.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.LevelBar.UIStroke.Color = ColorUtil.from_hex("#681113")
        CardsTemplates.NormalPetCard.LevelBar.Level.UIStroke.Color = ColorUtil.from_hex("#681113")
    elseif rarity == "Chromatic" then
        CardsTemplates.NormalPetCard.BackgroundColor3 = ColorUtil.from_hex("#ffffff")
        local Gradient = CardsTemplates.NormalPetCard.UIGradient
        local colorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ColorUtil.from_hex("#b9481c")),
            ColorSequenceKeypoint.new(0.358, ColorUtil.from_hex("#6ce136")),
            ColorSequenceKeypoint.new(0.559, ColorUtil.from_hex("#49ceff")),
            ColorSequenceKeypoint.new(0.822, ColorUtil.from_hex("#9c2ee1")),
            ColorSequenceKeypoint.new(1, ColorUtil.from_hex("#5e0fa3"))
        })
        Gradient.Rotation = -62
        Gradient.Color = colorSequence
        Gradient.Enabled = true
        CardsTemplates.NormalPetCard.BackgroundImage.Image = "rbxassetid://18139269250"
        CardsTemplates.NormalPetCard.BackgroundImage.ImageTransparency = 0
        CardsTemplates.NormalPetCard.BackgroundImage.ImageColor3 = ColorUtil.from_hex("#ffffff")
        CardsTemplates.NormalPetCard.BackgroundImage.ScaleType = "Tile"
        CardsTemplates.NormalPetCard.BackgroundImage.TileSize = UDim2.new(1,0,0.4,0)

        CardsTemplates.NormalPetCard.LevelBar.BackgroundColor3 = ColorUtil.from_hex("#722aac")
        CardsTemplates.NormalPetCard.Stats.Template.StatAmount.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.ItemName.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.Date.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.Rarity.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.LevelBar.UIStroke.Color = ColorUtil.from_hex("#562081")
        CardsTemplates.NormalPetCard.LevelBar.Level.UIStroke.Color = ColorUtil.from_hex("#562081")
    else
        CardsTemplates.NormalPetCard.BackgroundColor3 = ColorUtil.from_hex("#50b9ff")
        local Gradient = CardsTemplates.NormalPetCard.UIGradient
        Gradient.Enabled = false
        CardsTemplates.NormalPetCard.BackgroundImage.Image = "rbxassetid://18140200045"
        CardsTemplates.NormalPetCard.BackgroundImage.ImageTransparency = 0.86
        CardsTemplates.NormalPetCard.BackgroundImage.ImageColor3 = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.BackgroundImage.ScaleType = "Tile"
        CardsTemplates.NormalPetCard.BackgroundImage.TileSize = UDim2.new(1.5, 0,1, 0)
        
        CardsTemplates.NormalPetCard.LevelBar.BackgroundColor3 = ColorUtil.from_hex("#287598")
        CardsTemplates.NormalPetCard.Stats.Template.StatAmount.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.ItemName.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.Date.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.Rarity.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.LevelBar.UIStroke.Color = ColorUtil.from_hex("#21607e")
        CardsTemplates.NormalPetCard.LevelBar.Level.UIStroke.Color = ColorUtil.from_hex("#21607e")
    end
    TemplateClone.Parent = InventoryFrame
    TemplateClone.Visible = true
    TemplateClone["Rarity"].Text = rarity
    TemplateClone["ItemName"].Text = name
    TemplateClone["Image"].Image = image
    local OffsetX = (iteminstance.AbsolutePosition.X - InventoryFrame.AbsolutePosition.X) / UIScale.Scale
    local OffsetY = (iteminstance.AbsolutePosition.Y - InventoryFrame.AbsolutePosition.Y) / UIScale.Scale
    local CardNewPos = UDim2.new(0.31, OffsetX, 0.32, OffsetY)
    local CardTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local CardTweenMove = TweenService:Create(TemplateClone, CardTweenInfo, {Position = CardNewPos})
    CardTweenMove:Play()
    CardTweenMove.Completed:Connect(function()
        CardTweenMove:Destroy()
    end)
end
function InventoryController:AddItem(type: string, name: string, id: string)
    local Rarity = nil
    if type == "Swords" then
        Rarity = SwordModule.GetSwordStat(name, "Rarity")
    elseif type == "Pets" then
        Rarity = PetModule.GetPetStat(name, "Rarity")
    end
    local TemplateClone = nil
    if Rarity == "Legendary" then
        TemplateClone = ItemsTemplates.LegendaryTemplate:Clone()
    elseif Rarity == "Secret" then
        TemplateClone = ItemsTemplates.SecretTemplate:Clone()
    elseif Rarity == "Chromatic" then
        TemplateClone = ItemsTemplates.ChromaticTemplate:Clone()
    else
        TemplateClone = ItemsTemplates.NormalTemplate:Clone()
    end
    TemplateClone["ItemName"].Text = name
    TemplateClone.Name = id
    TemplateClone.Visible = true
    local Image = nil
    if type == "Swords" then
        TemplateClone.Parent = SwordsContent
        Image = SwordModule.GetSwordImage(name)
    elseif type == "Pets" then
        TemplateClone.Parent = PetsContent
        Image = PetModule.GetPetImage(name)
    end
    TemplateClone["Image"]["ImageLabel"].Image = Image
    TemplateClone.MouseButton1Click:Connect(function()
        self:ItemTriggered(type, name, Rarity, Image, TemplateClone)
    end)
end
function InventoryController:SideButtonsTrigger(buttonname: string)
    if buttonname == "PetsButton" then
        PetsContent.Visible = true
        SwordsContent.Visible = false
    elseif buttonname == "SwordsButton" then
        SwordsContent.Visible = true
        PetsContent.Visible = false
    end
    for _, card in pairs(CardsTemplates) do
        card.Visible = false
    end
end
function InventoryController:Trigger()
    if InventoryScreen.Enabled == true then
        InventoryScreen.Enabled = false
    elseif InventoryScreen.Enabled == false then
        InventoryScreen.Enabled = true
        for _, screengui in pairs(MainFolder:GetChildren()) do
            if screengui.Name ~= "Inventory" then
                screengui.Enabled = false
            end
        end
    end
end
-- { Initiation } --
function InventoryController:KnitInit()
    local InventoryService = Knit.GetService("InventoryService")
    InventoryService.CreateInventoryItem:Connect(function(type: string, name: string, id: string)
        self:AddItem(type, name, id)
    end)
    PetsButton.MouseButton1Click:Connect(function()
        InventoryController:SideButtonsTrigger("PetsButton")
    end)
    SwordsButton.MouseButton1Click:Connect(function()
        InventoryController:SideButtonsTrigger("SwordsButton")
    end)
end
return InventoryController