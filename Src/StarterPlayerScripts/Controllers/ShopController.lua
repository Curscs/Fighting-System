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
local ShopScreen = MainFolder:WaitForChild("Shop")
-- { Knit } --
local ShopController = Knit.CreateController({
    Name = "ShopController",
    Client = {}
})
-- { Functions } --
function ShopController:Update(name: string)
    
end
function ShopController:Trigger(status: boolean, name: string)
    if status == true then
        self:Update()
        ShopScreen.Enabled = true
    elseif status == false then
        ShopScreen.Enabled = false
    end
end
-- { Initiation } --
return ShopController