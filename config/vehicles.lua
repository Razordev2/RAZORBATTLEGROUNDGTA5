Config = Config or {}

Config.MilitaryVehicleChance = 50 -- Chance (in %) for military spawn points to pick military models
Config.TotalMatchVehicles = 40   -- Total vehicles spawned across map per match

Config.VehiclePools = {
    CIVILIAN = {
        `bravado`,
        `sultan`,
        `kuruma`,
        `baller`,
        `bison`,
        `sanchez`,
        `wrangler24`
    },
    MILITARY = {
        `crusader`,
        `squaddie`,
        `barracks`,
        `kamacho`,
        `insurgent`,
        `wrangler24`
    }
}

-- Comprehensive random vehicle spawn points across ENTIRE MAP
Config.VehicleSpawnPoints = {
    -- Legion Square & LS City Center
    { coords = vec3(228.3, -993.4, 29.3), heading = 220.0, category = "CIVILIAN" },
    { coords = vec3(146.2, -1035.1, 29.2), heading = 340.0, category = "CIVILIAN" },
    { coords = vec3(-204.4, -1310.2, 31.3), heading = 90.0, category = "CIVILIAN" },
    { coords = vec3(-53.1, -1753.4, 29.4), heading = 140.0, category = "CIVILIAN" },
    { coords = vec3(412.5, -1625.3, 29.3), heading = 230.0, category = "CIVILIAN" },
    
    -- LS Airport & Docks
    { coords = vec3(-1037.4, -2737.5, 20.1), heading = 150.0, category = "MILITARY" },
    { coords = vec3(-1320.1, -2250.4, 13.9), heading = 330.0, category = "CIVILIAN" },
    { coords = vec3(890.3, -3190.2, 5.9), heading = 180.0, category = "MILITARY" },
    
    -- Del Perro & Vespucci Beach
    { coords = vec3(-1440.3, -670.2, 26.2), heading = 120.0, category = "CIVILIAN" },
    { coords = vec3(-1180.5, -1500.3, 4.4), heading = 350.0, category = "CIVILIAN" },
    
    -- Vinewood & Rockford Hills
    { coords = vec3(625.4, 265.1, 103.2), heading = 210.0, category = "CIVILIAN" },
    { coords = vec3(-750.3, 350.4, 87.5), heading = 80.0, category = "CIVILIAN" },
    
    -- Sandy Shores & Airfield
    { coords = vec3(1734.2, 3710.1, 34.1), heading = 300.0, category = "CIVILIAN" },
    { coords = vec3(1705.5, 3255.4, 40.9), heading = 190.0, category = "MILITARY" },
    { coords = vec3(1850.3, 3680.2, 33.7), heading = 20.0, category = "MILITARY" },
    { coords = vec3(1370.2, 3615.5, 34.8), heading = 110.0, category = "CIVILIAN" },

    -- Harmony & Grand Senora Desert
    { coords = vec3(308.2, 3568.4, 33.4), heading = 90.0, category = "MILITARY" },
    { coords = vec3(650.4, 2750.2, 41.9), heading = 270.0, category = "CIVILIAN" },
    { coords = vec3(1175.3, 2665.4, 38.0), heading = 40.0, category = "MILITARY" },
    
    -- Fort Zancudo Military Base
    { coords = vec3(-2169.5, 3267.1, 32.8), heading = 180.0, category = "MILITARY" },
    { coords = vec3(-2035.2, 3140.5, 32.8), heading = 320.0, category = "MILITARY" },
    { coords = vec3(-2250.4, 3075.2, 32.8), heading = 140.0, category = "MILITARY" },
    
    -- Chumash & West Highway
    { coords = vec3(-3155.3, 1125.4, 20.8), heading = 280.0, category = "CIVILIAN" },
    { coords = vec3(-2970.2, 480.5, 15.2), heading = 160.0, category = "CIVILIAN" },
    
    -- Paleto Bay & Mount Chiliad
    { coords = vec3(119.5, 6625.2, 31.8), heading = 45.0, category = "CIVILIAN" },
    { coords = vec3(-430.4, 6150.3, 31.4), heading = 135.0, category = "MILITARY" },
    { coords = vec3(450.2, 6500.5, 30.0), heading = 220.0, category = "CIVILIAN" },
    { coords = vec3(-110.3, 6380.1, 31.5), heading = 310.0, category = "CIVILIAN" },
    
    -- Grapeseed & Alamo Sea
    { coords = vec3(1690.4, 4790.2, 42.0), heading = 90.0, category = "CIVILIAN" },
    { coords = vec3(2450.2, 4980.5, 45.5), heading = 180.0, category = "MILITARY" },
    { coords = vec3(2100.5, 4770.3, 41.2), heading = 270.0, category = "CIVILIAN" },

    -- East Highway & Ron Alternates Wind Farm
    { coords = vec3(2570.3, 380.4, 108.6), heading = 350.0, category = "MILITARY" },
    { coords = vec3(2680.1, 1680.5, 24.5), heading = 120.0, category = "CIVILIAN" }
}
