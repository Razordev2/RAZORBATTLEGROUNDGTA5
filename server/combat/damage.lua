ServerDamage = ServerDamage or {}

RegisterNetEvent("battleground:sv:reportDamage", function(victimSrc, weaponHash, isHeadshot)
    local killerSrc = source
    if ServerState.GetMatchState() ~= Constants.MatchState.ACTIVE then return end

    local killer = PlayerManager.GetPlayer(killerSrc)
    local victim = PlayerManager.GetPlayer(victimSrc)
    if not killer or not victim or victim.state == Constants.PlayerState.DEAD then return end

    -- Friendly Fire Check
    if killer.teamId and killer.teamId == victim.teamId and killerSrc ~= victimSrc then
        return -- Block friendly fire
    end

    local weaponSpec = Config.Weapons[weaponHash] or { baseDamage = 25, headshotMultiplier = 1.5 }
    local damage = weaponSpec.baseDamage * (isHeadshot and weaponSpec.headshotMultiplier or 1.0)

    if victim.state == Constants.PlayerState.ALIVE then
        victim.health = victim.health - damage
        if victim.health <= 0 then
            -- Knock player
            ServerKnock.KnockPlayer(victimSrc, killerSrc, weaponHash)
        end
    elseif victim.state == Constants.PlayerState.DOWNED then
        victim.health = victim.health - damage
        if victim.health <= 0 then
            -- Finish downed player
            ServerKill.RegisterKill(killerSrc, victimSrc, weaponHash, isHeadshot)
        end
    end
end)
