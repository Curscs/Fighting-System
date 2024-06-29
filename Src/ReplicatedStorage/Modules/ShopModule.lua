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
    ["Beginners Market"] = Shop.new("Beginner Market", 70, {
        ["Wooden Sword"] = {
            ["Chance"] = 50,
            ["Type"] = "Swords",
            ["Currency"] = "Coins",
            ["MinStock"] = 3,
            ["MaxStock"] = 10,
            ["Price"] = 100,
        },
        ["???"] = {
            ["Chance"] = 50,
            ["Type"] = "Pets",
            ["Currency"] = "Coins",
            ["MinStock"] = 3,
            ["MaxStock"] = 10,
            ["Price"] = 100,
        },
    })
}

function Shop.GetItemCurrency(shopname: string, itemname: string)
    if Shop.Shops[shopname]["Items"][itemname] then
        return Shop.Shops[shopname]["Items"][itemname]["Currency"]
    end
end
function Shop.GetItemType(shopname: string, itemname:string)
    if Shop.Shops[shopname]["Items"][itemname] then
        return Shop.Shops[shopname]["Items"][itemname]["Type"]
    end
end
function Shop.GetItemPrice(shopname: string, itemname: string)
    if Shop.Shops[shopname]["Items"][itemname] then
        return Shop.Shops[shopname]["Items"][itemname]["Price"]
    end
end

function Shop.GetItemStock(shopname: string, itemname: string)
    if Shop.Shops[shopname]["Items"][itemname] then
        return Shop.Shops[shopname]["Items"][itemname]["MaxStock"]
    end
end

function Shop.GetAllShops()
    local Value = {}
    for shopname, shopdata in pairs(Shop.Shops) do
        table.insert(Value, shopname)
    end
    return TableUtil.Copy(Value, true)
end

function Shop.GetResetTime(name: string)
    if Shop.Shops[name] then
        local Value = Shop.Shops[name]["ResetTime"]
        return Value
    end
end

function Shop.GetAllItems(name: string)
    if Shop.Shops[name] then
        local Value = Shop.Shops[name]["Items"]
        return TableUtil.Copy(Value, true)
    end
end

return Shop
