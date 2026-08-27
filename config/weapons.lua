Config = Config or {}

Config.Weapons = {
    -- Default GTA V Weapons
    [`WEAPON_PISTOL`] = { name = "WEAPON_PISTOL", label = "Pistol", category = "PISTOL", baseDamage = 26, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "pistol" },
    [`WEAPON_COMBATPISTOL`] = { name = "WEAPON_COMBATPISTOL", label = "Combat Pistol", category = "PISTOL", baseDamage = 32, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "combatpistol" },
    [`WEAPON_SMG`] = { name = "WEAPON_SMG", label = "SMG", category = "SMG", baseDamage = 22, headshotMultiplier = 1.8, defaultAmmo = 120, icon = "smg" },
    [`WEAPON_MICROSMG`] = { name = "WEAPON_MICROSMG", label = "Micro SMG", category = "SMG", baseDamage = 21, headshotMultiplier = 1.8, defaultAmmo = 120, icon = "microsmg" },
    [`WEAPON_ASSAULTRIFLE`] = { name = "WEAPON_ASSAULTRIFLE", label = "Assault Rifle", category = "RIFLE", baseDamage = 30, headshotMultiplier = 2.2, defaultAmmo = 150, icon = "assaultrifle" },
    [`WEAPON_CARBINERIFLE`] = { name = "WEAPON_CARBINERIFLE", label = "Carbine Rifle", category = "RIFLE", baseDamage = 32, headshotMultiplier = 2.3, defaultAmmo = 150, icon = "carbine" },
    [`WEAPON_PUMPSHOTGUN`] = { name = "WEAPON_PUMPSHOTGUN", label = "Pump Shotgun", category = "SHOTGUN", baseDamage = 80, headshotMultiplier = 1.5, defaultAmmo = 32, icon = "shotgun" },
    [`WEAPON_SNIPERRIFLE`] = { name = "WEAPON_SNIPERRIFLE", label = "Sniper Rifle", category = "SNIPER", baseDamage = 95, headshotMultiplier = 2.5, defaultAmmo = 20, icon = "sniper" },
    [`WEAPON_COMBATMG`] = { name = "WEAPON_COMBATMG", label = "Combat MG", category = "HEAVY", baseDamage = 45, headshotMultiplier = 2.0, defaultAmmo = 200, icon = "mg" },

    -- Custom Streamed Addon Weapons
    [`WEAPON_AK47`] = { name = "WEAPON_AK47", label = "AK-47", category = "RIFLE", baseDamage = 36, headshotMultiplier = 2.3, defaultAmmo = 150, icon = "ak47" },
    [`WEAPON_AK74`] = { name = "WEAPON_AK74", label = "AK-74", category = "RIFLE", baseDamage = 34, headshotMultiplier = 2.2, defaultAmmo = 150, icon = "ak74" },
    [`WEAPON_AKS74`] = { name = "WEAPON_AKS74", label = "AKS-74U", category = "RIFLE", baseDamage = 33, headshotMultiplier = 2.1, defaultAmmo = 150, icon = "aks74" },
    [`WEAPON_BEANBAG`] = { name = "WEAPON_BEANBAG", label = "Beanbag Shotgun", category = "SHOTGUN", baseDamage = 40, headshotMultiplier = 1.2, defaultAmmo = 30, icon = "shotgun" },
    [`WEAPON_BROWNING`] = { name = "WEAPON_BROWNING", label = "Browning HP", category = "PISTOL", baseDamage = 30, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "pistol" },
    [`WEAPON_DESERTEAGLE`] = { name = "WEAPON_DESERTEAGLE", label = "Desert Eagle", category = "PISTOL", baseDamage = 65, headshotMultiplier = 2.5, defaultAmmo = 35, icon = "deagle" },
    [`WEAPON_FNFNX45`] = { name = "WEAPON_FNFNX45", label = "FN FNX-45", category = "PISTOL", baseDamage = 32, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "pistol" },
    [`WEAPON_GLOCK17`] = { name = "WEAPON_GLOCK17", label = "Glock 17", category = "PISTOL", baseDamage = 28, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "glock" },
    [`WEAPON_GLOCK18C`] = { name = "WEAPON_GLOCK18C", label = "Glock 18C Auto", category = "PISTOL", baseDamage = 24, headshotMultiplier = 1.9, defaultAmmo = 90, icon = "glock" },
    [`WEAPON_GLOCK19GEN4`] = { name = "WEAPON_GLOCK19GEN4", label = "Glock 19 Gen4", category = "PISTOL", baseDamage = 29, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "glock" },
    [`WEAPON_GLOCK20`] = { name = "WEAPON_GLOCK20", label = "Glock 20", category = "PISTOL", baseDamage = 31, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "glock" },
    [`WEAPON_GLOCK22`] = { name = "WEAPON_GLOCK22", label = "Glock 22", category = "PISTOL", baseDamage = 30, headshotMultiplier = 2.0, defaultAmmo = 60, icon = "glock" },
    [`WEAPON_GROZA`] = { name = "WEAPON_GROZA", label = "OTs-14 Groza", category = "RIFLE", baseDamage = 38, headshotMultiplier = 2.4, defaultAmmo = 150, icon = "groza" },
    [`WEAPON_KARAMBIT`] = { name = "WEAPON_KARAMBIT", label = "Karambit Knife", category = "MELEE", baseDamage = 60, headshotMultiplier = 1.0, defaultAmmo = 1, icon = "knife" },
    [`WEAPON_KATANA`] = { name = "WEAPON_KATANA", label = "Katana Sword", category = "MELEE", baseDamage = 85, headshotMultiplier = 1.5, defaultAmmo = 1, icon = "katana" },
    [`WEAPON_KEYBOARD`] = { name = "WEAPON_KEYBOARD", label = "Keyboard Melee", category = "MELEE", baseDamage = 35, headshotMultiplier = 1.0, defaultAmmo = 1, icon = "melee" },
    [`WEAPON_M1911`] = { name = "WEAPON_M1911", label = "Colt M1911", category = "PISTOL", baseDamage = 35, headshotMultiplier = 2.1, defaultAmmo = 50, icon = "m1911" },
    [`WEAPON_M4`] = { name = "WEAPON_M4", label = "M4A1 Carbine", category = "RIFLE", baseDamage = 35, headshotMultiplier = 2.3, defaultAmmo = 150, icon = "m4" },
    [`WEAPON_M6IC`] = { name = "WEAPON_M6IC", label = "LWRC M6IC", category = "RIFLE", baseDamage = 37, headshotMultiplier = 2.3, defaultAmmo = 150, icon = "m4" },
    [`WEAPON_MAC10`] = { name = "WEAPON_MAC10", label = "MAC-10 SMG", category = "SMG", baseDamage = 23, headshotMultiplier = 1.8, defaultAmmo = 120, icon = "mac10" },
    [`WEAPON_MK47`] = { name = "WEAPON_MK47", label = "CMMG Mk47 Mutant", category = "RIFLE", baseDamage = 40, headshotMultiplier = 2.4, defaultAmmo = 120, icon = "mk47" },
    [`WEAPON_PMX`] = { name = "WEAPON_PMX", label = "Beretta PMX SMG", category = "SMG", baseDamage = 25, headshotMultiplier = 1.9, defaultAmmo = 120, icon = "pmx" },
    [`WEAPON_SCARSC`] = { name = "WEAPON_SCARSC", label = "FN SCAR-SC", category = "RIFLE", baseDamage = 38, headshotMultiplier = 2.3, defaultAmmo = 150, icon = "scar" },
    [`WEAPON_SHIV`] = { name = "WEAPON_SHIV", label = "Improvised Shiv", category = "MELEE", baseDamage = 50, headshotMultiplier = 1.0, defaultAmmo = 1, icon = "knife" }
}
