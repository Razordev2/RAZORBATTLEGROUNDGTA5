ClientEffects = ClientEffects or {}

RegisterNetEvent("battleground:cl:pushKillFeed", function(killerName, weapon, victimName, style)
    local killStyle = Config.KillMessages[style] or Config.KillMessages["DEFAULT"]
    
    SendNUIMessage({
        action = "pushKillFeed",
        killer = killerName,
        weapon = weapon,
        victim = victimName,
        style = killStyle
    })
end)
