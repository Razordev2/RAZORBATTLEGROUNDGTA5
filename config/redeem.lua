Config = Config or {}

Config.RedeemCooldown = 3 -- Seconds player must wait between redeem requests

Config.DefaultRedeemCodes = {
    ["BG2026"] = {
        rewardType = "KILLMESSAGE",
        rewardId = "NEON",
        maxUses = 100,
        currentUses = 0,
        enabled = true
    },
    ["BLOODPACK"] = {
        rewardType = "KILLMESSAGE",
        rewardId = "BLOOD",
        maxUses = 50,
        currentUses = 0,
        enabled = true
    },
    ["VIPGOLD"] = {
        rewardType = "KILLMESSAGE",
        rewardId = "GOLD",
        maxUses = 10,
        currentUses = 0,
        enabled = true
    }
}
