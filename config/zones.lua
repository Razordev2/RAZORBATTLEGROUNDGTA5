Config = Config or {}

Config.ZoneInterval = 30 -- Seconds before zone starts shrinking to next phase

Config.ZonePhases = {
    [1] = { radius = 1200.0, damagePerSec = 2, shrinkDuration = 30 },
    [2] = { radius = 800.0,  damagePerSec = 5, shrinkDuration = 25 },
    [3] = { radius = 400.0,  damagePerSec = 10, shrinkDuration = 20 },
    [4] = { radius = 150.0,  damagePerSec = 18, shrinkDuration = 15 },
    [5] = { radius = 30.0,   damagePerSec = 25, shrinkDuration = 10 },
    [6] = { radius = 0.0,    damagePerSec = 40, shrinkDuration = 10 }
}

-- Initial Safe Zone Center (Center of San Andreas map)
Config.InitialZoneCenter = vec3(0.0, 0.0, 0.0)
Config.InitialZoneRadius = 1500.0
