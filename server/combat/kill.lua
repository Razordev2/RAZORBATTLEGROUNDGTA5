ServerKill = ServerKill or {}

function ServerKill.RegisterKill(killerSrc, victimSrc, weaponHash, isHeadshot)
    local killer = PlayerManager.GetPlayer(killerSrc)
    local victim = PlayerManager.GetPlayer(victimSrc)
    if not victim or victim.state == Constants.PlayerState.DEAD then return end

    victim.state = Constants.PlayerState.DEAD
    victim.health = 0

    if killer then
        killer.kills = killer.kills + 1
    end

    local killerName = (killer and killer.name) or "SAFEZONE"
    local victimName = victim.name
    local weaponName = (Config.Weapons[weaponHash] and Config.Weapons[weaponHash].label) or "WEAPON"

    print(string.format("[Battleground] %s killed %s with [%s]", killerName, victimName, weaponName))

    -- Broadcast top-right kill feed to all client peds
    TriggerClientEvent("battleground:cl:pushKillFeed", -1, killerName, weaponName, victimName, isHeadshot or false)
    TriggerClientEvent("battleground:cl:syncPlayerState", victimSrc, Constants.PlayerState.DEAD)

    -- Drop death crate
    local victimPed = GetPlayerPed(victimSrc)
    if DoesEntityExist(victimPed) then
        ServerDeath.CreateDeathCrate(GetEntityCoords(victimPed), victim)
    end

    -- Check team elimination
    if victim.teamId and ServerElimination and ServerElimination.CheckTeamElimination then
        ServerElimination.CheckTeamElimination(victim.roomId, victim.teamId)
    end
end
