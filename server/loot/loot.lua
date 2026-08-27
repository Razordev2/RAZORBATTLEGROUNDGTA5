ServerLoot = ServerLoot or {}

function ServerLoot.SpawnGroundItem(coords, itemType, name, count, prop)
    local lootId = Utils.GenerateId("LOOT")
    local item = {
        id = lootId,
        coords = coords,
        itemType = itemType,
        name = name,
        count = count or 1,
        prop = prop or `prop_ld_ammo_pack_01`
    }

    ServerState.GroundLoot[lootId] = item
    TriggerClientEvent("battleground:cl:spawnGroundLootItem", -1, item)
    return item
end

function ServerLoot.RemoveGroundItem(lootId)
    if ServerState.GroundLoot[lootId] then
        ServerState.GroundLoot[lootId] = nil
        TriggerClientEvent("battleground:cl:removeGroundLootItem", -1, lootId)
    end
end
