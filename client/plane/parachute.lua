ClientParachute = ClientParachute or {}

function ClientParachute.StartParachuteThread()
    CreateThread(function()
        local ped = PlayerPedId()
        while true do
            Wait(250)
            local coords = GetEntityCoords(ped)
            local state = GetPedParachuteState(ped)

            -- Check if player reached ground
            if IsPedLanded(ped) or HasEntityCollidedWithAnything(ped) or GetEntityHeightAboveGround(ped) < 1.5 then
                ClientState.SetMatchState(Constants.MatchState.ACTIVE, ClientState.MatchId)
                break
            end
        end
    end)
end
