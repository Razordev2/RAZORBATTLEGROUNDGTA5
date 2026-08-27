Config = Config or {}

Config.LootTables = {
    BASIC = {
        { itemType = "WEAPON", name = "WEAPON_GLOCK17", count = 1, weight = 30, prop = `w_pi_pistol` },
        { itemType = "WEAPON", name = "WEAPON_M1911", count = 1, weight = 25, prop = `w_pi_combatpistol` },
        { itemType = "WEAPON", name = "WEAPON_MAC10", count = 1, weight = 20, prop = `w_sb_smg` },
        { itemType = "AMMO", name = "AMMO_PISTOL", count = 30, weight = 15, prop = `prop_ld_ammo_pack_01` },
        { itemType = "MEDICAL", name = "bandage", count = 3, weight = 10, prop = `prop_bandage_01` }
    },
    WAR = {
        { itemType = "WEAPON", name = "WEAPON_AK47", count = 1, weight = 25, prop = `w_ar_assaultrifle` },
        { itemType = "WEAPON", name = "WEAPON_M4", count = 1, weight = 25, prop = `w_ar_carbinerifle` },
        { itemType = "WEAPON", name = "WEAPON_GROZA", count = 1, weight = 20, prop = `w_ar_assaultrifle` },
        { itemType = "WEAPON", name = "WEAPON_SCARSC", count = 1, weight = 15, prop = `w_ar_carbinerifle` },
        { itemType = "WEAPON", name = "WEAPON_DESERTEAGLE", count = 1, weight = 15, prop = `w_pi_combatpistol` },
        { itemType = "AMMO", name = "AMMO_RIFLE", count = 90, weight = 10, prop = `prop_ld_ammo_pack_02` },
        { itemType = "ARMOR", name = "armor_lvl2", count = 1, weight = 10, prop = `prop_armour_pickup` }
    },
    MEDICAL = {
        { itemType = "MEDICAL", name = "bandage", count = 5, weight = 50, prop = `prop_bandage_01` },
        { itemType = "MEDICAL", name = "medkit", count = 1, weight = 40, prop = `prop_ld_health_pack` },
        { itemType = "ARMOR", name = "armor_lvl1", count = 1, weight = 10, prop = `prop_bodyarmour_02` }
    },
    RANDOM = {
        { itemType = "WEAPON", name = "WEAPON_AK74", count = 1, weight = 15, prop = `w_ar_assaultrifle` },
        { itemType = "WEAPON", name = "WEAPON_MK47", count = 1, weight = 15, prop = `w_ar_assaultrifle` },
        { itemType = "WEAPON", name = "WEAPON_PMX", count = 1, weight = 15, prop = `w_sb_smg` },
        { itemType = "WEAPON", name = "WEAPON_KATANA", count = 1, weight = 10, prop = `prop_kitch_juicer` },
        { itemType = "MEDICAL", name = "medkit", count = 2, weight = 25, prop = `prop_ld_health_pack` },
        { itemType = "ARMOR", name = "armor_lvl3", count = 1, weight = 10, prop = `prop_armour_pickup` }
    }
}
