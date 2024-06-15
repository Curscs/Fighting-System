-- { Services } --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Zone = require(ReplicatedStorage.Packages.Zone)
-- { Misc } --
local Player = Players.LocalPlayer
-- { Knit } --
local ShopController = Knit.GetController("ShopController")
local Shop = Component.new({
    Tag = "Shop",
})
-- { Functions } --
function Shop:Construct()
    self.Zone = Zone.new(self.Instance)
    self.Name = self.Instance:GetAttribute("Name")
end
-- { Initiation } --
Shop.Started:Connect(function(self)
    self.Zone.localPlayerEntered:Connect(function()
        ShopController:Trigger(true, self.Name)
    end)
    self.Zone.localPlayerExited:Connect(function()
        ShopController:Trigger(false, self.Name)
    end)
end)

return Shop