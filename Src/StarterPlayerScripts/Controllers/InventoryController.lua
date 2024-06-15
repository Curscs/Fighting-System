-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
-- { Misc } --
local Player = Players.LocalPlayer
-- { GUI } --
local PlayerGui = Player:WaitForChild("PlayerGui")
local MainFolder = PlayerGui:WaitForChild("Main")
local InventoryScreen = MainFolder:WaitForChild("Inventory")
local InventoryFrame = InventoryScreen:WaitForChild("InventoryFrame")
local ContentFrame = InventoryFrame:WaitForChild("Content")
local Template = ContentFrame:WaitForChild("Template")
-- { Knit } --
local InventoryController = Knit.CreateController({
    Name = "InventoryController",
})
-- { Functions } --
function InventoryController:AddItem(type: string, name: string)
    
end
function InventoryController:Trigger()
    if InventoryScreen.Enabled == true then
        InventoryScreen.Enabled = false
    elseif InventoryScreen.Enabled == false then
        InventoryScreen.Enabled = true
    end
end
-- { Initiation } --
return InventoryController