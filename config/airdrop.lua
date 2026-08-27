Config = Config or {}

Config.AirdropInterval = 30 -- Seconds between airdrop spawns during ACTIVE match state
Config.AirdropPlaneModel = `cuban800`
Config.AirdropCrateModel = `prop_box_wood02a`
Config.AirdropParachuteModel = `p_parachute_s`
Config.AirdropDropSpeed = 5.0 -- Speed of descending crate

Config.AirdropLoot = {
    weapons = { "WEAPON_COMBATMG", "WEAPON_SNIPERRIFLE" },
    items = {
        medkit = 3,
        armor_lvl3 = 2,
        ammo_heavy = 150
    }
}
