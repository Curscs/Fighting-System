-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
-- { Misc } --
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
    if Button:IsA("ImageButton") then
        table.insert(Buttons, Button)
    end
end
-- { Functions } --
function OptionsController:Click(name: string)
    local MonsterService = Knit.GetService("MonsterService")
    if name == "Escape" then
        MonsterService:Escape()
    end
end
-- { Initiation } --
function OptionsController:KnitInit()
    for _, button in pairs(Buttons) do
        button.MouseButton1Click:Connect(function()
            self:Click(button.Name)
        end)
    end
end
return OptionsController