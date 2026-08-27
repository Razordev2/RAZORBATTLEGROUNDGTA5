Config = Config or {}

-- Global Settings
Config.Debug = false
Config.Locale = 'id' -- Default language ('id' or 'en')

-- Match Settings
Config.CountdownDuration = 20 -- Seconds for starting countdown (20 to 0)
Config.EndingDuration = 5 -- Seconds for victory screen before results
Config.ResultsDuration = 30 -- Seconds for results screen before returning to lobby

-- Revive Mechanics
Config.ReviveDuration = 5000 -- Milliseconds to complete revive
Config.ReviveHealth = 50 -- Health given upon successful revive
Config.ReviveDistance = 2.5 -- Max distance to revive teammate (meters)
Config.KnockBleedoutTime = 45 -- Seconds before knocked player bleeds out and dies
Config.KnockHealth = 100 -- Health points during downed state

-- Plane & Flight System
Config.PlaneModel = `titan` -- Aircraft model for drop plane
Config.PlaneSpeed = 60.0 -- Speed of cargo plane
Config.PlaneAltitude = 500.0 -- Plane flight height
Config.AutoJumpAltitude = 50.0 -- Auto eject altitude if player hasn't jumped

-- Interaction Distances
Config.LootPickupDistance = 2.5 -- Distance to pick up loot item (meters)

-- Discord Webhook Integration
Config.DiscordWebhook = "https://discord.com/api/webhooks/1542492865391755264/FM5wVKQzxXCwIsnaoaAiIPv-n0vr4ACsEyJnWWIJIAx3RNHJtGDq6YnC2a2plJe-jIId"
Config.DiscordBotName = "BATTLEGROUND TOURNAMENT ENGINE"
Config.DiscordAvatar = "https://i.imgur.com/8N5N6N8.png"

-- Admin Groups & Flexible Identifiers (Steam Hex, Discord ID, License, ACE)
Config.AdminGroup = 'admin'
Config.AdminPermission = 'battleground.admin'

-- List of Admin Identifiers (Steam HEX, Discord ID, License)
Config.AdminIdentifiers = {
    "steam:110000100000000",      -- Ganti dengan Steam Hex Anda
    "discord:123456789012345678", -- Ganti dengan Discord ID Anda (Format: discord:ID)
    "license:abcdef1234567890"    -- Ganti dengan License FiveM Anda
}
