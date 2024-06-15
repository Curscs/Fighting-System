local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local Shop = {}

function Shop.new(name: string, resettime: number, items: table)
    local self = {}
    self.Name = name
    self.ResetTime = resettime
    self.Items = items
    return self
end

Shop.Shops = {
    ["Beginner Market"] = Shop.new("Beginner Market", 300, {
        ["Wooden Sword"] = {
            ["Chance"] = 50,
            ["Type"] = "Sword",
            ["Currency"] = "Coins",
            ["Stock"] = 10,
            ["Price"] = 300,
        },

        ["Test"] = {
            ["Chance"] = 30,
            ["Type"] = "Item",
            ["Currency"] = "Coins",
            ["Stock"] = 10,
            ["Price"] = 300,
        },
    })
}
function Shop.GetResetTime(name: string)
    if Shop.Shops[name] then
        local Value = Shop.Shops[name]["ResetTime"]
        return TableUtil.Copy(Value, true)
    end
end

function Shop.GetAllItems(name: string)
    if Shop.Shops[name] then
        local Value = Shop.Shops[name]["Items"]
        return TableUtil.Copy(Value, true)
    end
end

return Shop
