Constants = Constants or {}

-- Match Lifecycle Enums
Constants.MatchState = {
    LOBBY = "LOBBY",
    STARTING = "STARTING",
    DROPPING = "DROPPING",
    ACTIVE = "ACTIVE",
    ENDING = "ENDING",
    RESULTS = "RESULTS"
}

-- Player Combat States
Constants.PlayerState = {
    ALIVE = "ALIVE",
    DOWNED = "DOWNED",
    DEAD = "DEAD"
}

-- Item Types
Constants.ItemType = {
    WEAPON = "WEAPON",
    AMMO = "AMMO",
    MEDICAL = "MEDICAL",
    ARMOR = "ARMOR"
}

-- Loot Table Categories
Constants.LootTableType = {
    BASIC = "BASIC",
    WAR = "WAR",
    MEDICAL = "MEDICAL",
    RANDOM = "RANDOM"
}

-- Default Asset Placeholders
Constants.DefaultTeamLogo = "assets/images/default_team.png"
