-- { Services } --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- { Modules } --
local Knit = require(ReplicatedStorage.Packages.knit)
local ShopModule = require(ReplicatedStorage.Modules.ShopModule)
-- { Knit } --
local ShopService = Knit.CreateService({
    Name = "ShopService",
    Client = {}
})
-- { Functions } --
function ShopService:Update(name: string)
    local DataService = Knit.GetService("DataService")
    local ShopData = DataService:GetData("Shops")
    local Items = {}
    if ShopData[name]["ResetTime"] == nil or ShopData[name]["ResetTime"] > os.time() then
        ShopData[name]["ResetTime"] = os.time()
    end
end
-- { Initiation } --
return ShopService

