ClientAirdrop = ClientAirdrop or {}

ClientAirdrop.Active = {}

RegisterNetEvent("battleground:cl:spawnAirdrop", function(airdrop)
    ClientAirdrop.Active[airdrop.id] = airdrop

    -- Create map blip for airdrop
    local blip = AddBlipForCoord(airdrop.coords.x, airdrop.coords.y, airdrop.coords.z)
    SetBlipSprite(blip, 94) -- Airdrop crate sprite
    SetBlipColour(blip, 1) -- Red
    SetBlipScale(blip, 1.2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("SUPPLY AIRDROP")
    EndTextCommandSetBlipName(blip)

    airdrop.blip = blip
end)

RegisterNetEvent("battleground:cl:removeAirdrop", function(airdropId)
    local drop = ClientAirdrop.Active[airdropId]
    if drop then
        if drop.blip and DoesBlipExist(drop.blip) then RemoveBlip(drop.blip) end
        ClientAirdrop.Active[airdropId] = nil
    end
end)

-- Render thread for crate interaction
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        for id, drop in pairs(ClientAirdrop.Active) do
            local dist = Utils.GetDistance3D(pCoords, drop.coords)
            if dist < 20.0 then
                DrawMarker(1, drop.coords.x, drop.coords.y, drop.coords.z - 0.5, 0,0,0, 0,0,0, 1.5, 1.5, 1.0, 244, 63, 94, 200, false, true, 2, false, nil, nil, false)
                if dist <= 3.0 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Press ~INPUT_PICKUP~ [E] to LOOT AIRDROP")
                    EndTextCommandDisplayHelp(0, false, true, -1)

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("battleground:sv:lootAirdrop", drop.id)
                        Wait(500)
                    end
                end
            end
        end
    end
end)
