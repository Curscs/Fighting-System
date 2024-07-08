-- { Services } --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.Knit)
local RarityUtil = require(ReplicatedStorage.Util.RarityUtil)
-- { Misc } --
-- { GUI } --
-- { Knit } --
local MonsterService = Knit.CreateService({
    Name = "MonsterService",
    Client = {}
})
-- { Client Functions } --
function MonsterService.Client:Escape()
    return self.Server:Escape()
end
-- { Server Functions } --
function MonsterService:Escape()
    local Chances = {
        ["Success"] = 50,
        ["Fail"] = 50
    }
    local Escape = RarityUtil:SelectRandom(Chances)
    return Escape
end

function MonsterService:Start(player: Player)
    
end
-- { Initiation } --
return MonsterService
