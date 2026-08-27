ServerDeath = ServerDeath or {}

function ServerDeath.CreateDeathCrate(coords, victimPlayer)
    if not victimPlayer then return end
    -- Spawn ground loot box with victim's inventory items
    ServerLoot.SpawnGroundItem(coords, Constants.ItemType.MEDICAL, "medkit", 1, `prop_ld_health_pack`)
    ServerLoot.SpawnGroundItem(coords, Constants.ItemType.ARMOR, "armor_lvl2", 1, `prop_armour_pickup`)
end
