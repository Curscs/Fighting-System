-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local DebounceUtil  = require(ReplicatedStorage.Util.DebounceUtil)
-- { Misc } --
local Player = Players.LocalPlayer
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local MiscFolder = PlayerGui:WaitForChild("Misc")
local SideButtonsScreen = MiscFolder:WaitForChild("SideButtons")
local LeftFrame = SideButtonsScreen:WaitForChild("Left")
local LeftButtonsFrame = LeftFrame:WaitForChild("LeftButtons")

local Buttons = {}

for _ , Button in pairs(LeftButtonsFrame:GetChildren()) do
    if Button:IsA("ImageButton") then
        table.insert(Buttons, Button)
    end
end
-- { Knit } --
local ButtonsController = Knit.CreateController({
    Name = "ButtonsController",
})
-- { Functions } --
function ButtonsController:Click(buttonname: string)
    local InventoryController = Knit.GetController("InventoryController")
    if DebounceUtil:getDebounceStatus(Player, "SideButtons", 0.1) then
        if buttonname == "InventoryButton" then
            InventoryController:Trigger()
        end
    end
end
-- { Initiation } --
function ButtonsController:KnitInit()
    for _, button in pairs(Buttons) do
        button.MouseButton1Click:Connect(function()
            self:Click(button.Name)
        end)
    end
end

return ButtonsController