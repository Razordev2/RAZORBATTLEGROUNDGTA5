ServerLootTable = ServerLootTable or {}

function ServerLootTable.GetRandomLoot(tableName)
    local tableData = Config.LootTables[tableName] or Config.LootTables["BASIC"]
    local totalWeight = 0
    for _, item in ipairs(tableData) do
        totalWeight = totalWeight + (item.weight or 10)
    end

    local randomWeight = math.random(1, totalWeight)
    local currentWeight = 0
    for _, item in ipairs(tableData) do
        currentWeight = currentWeight + (item.weight or 10)
        if randomWeight <= currentWeight then
            return Utils.DeepCopy(item)
        end
    end

    return Utils.DeepCopy(tableData[1])
end
