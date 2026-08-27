ServerKnock = ServerKnock or {}

function ServerKnock.KnockPlayer(victimSrc, killerSrc, weaponHash)
    local victim = PlayerManager.GetPlayer(victimSrc)
    if not victim then return end

    victim.state = Constants.PlayerState.DOWNED
    victim.health = Config.KnockHealth or 100

    TriggerClientEvent("battleground:cl:syncPlayerState", victimSrc, Constants.PlayerState.DOWNED)
    print(string.format("[Battleground] Player %s is DOWNED!", victim.name))

    -- Bleedout timer thread
    CreateThread(function()
        local bleedout = Config.KnockBleedoutTime or 45
        while victim.state == Constants.PlayerState.DOWNED and bleedout > 0 do
            Wait(1000)
            bleedout = bleedout - 1
            victim.health = math.floor((bleedout / Config.KnockBleedoutTime) * 100)
        end

        if victim.state == Constants.PlayerState.DOWNED and bleedout <= 0 then
            -- Player bled out to death
            ServerKill.RegisterKill(killerSrc or victimSrc, victimSrc, weaponHash)
        end
    end)
end
