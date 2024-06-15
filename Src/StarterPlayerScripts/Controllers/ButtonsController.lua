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
local SideButtonsScreen = PlayerGui:WaitForChild("SideButtons")
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
function ButtonsController:ButtonPress(buttonname: string)
    local InventoryController = Knit.GetController("InventoryController")
    if DebounceUtil:getDebounceStatus(Player, "SideButtons", 0.5) then
        if buttonname == "InventoryButton" then
            InventoryController:Trigger()
        end
    end
end
-- { Initiation } --
function ButtonsController:KnitInit()
    for _, Button in pairs(Buttons) do
        Button.MouseButton1Click:Connect(function()
            self:ButtonPress(Button.Name)
        end)
    end
end

return ButtonsController