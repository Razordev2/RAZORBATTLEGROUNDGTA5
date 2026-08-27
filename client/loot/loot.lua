ClientLoot = ClientLoot or {}

ClientLoot.Items = {}
ClientLoot.Props = {}

RegisterNetEvent("battleground:cl:spawnGroundLootItem", function(item)
    ClientLoot.Items[item.id] = item
end)

RegisterNetEvent("battleground:cl:removeGroundLootItem", function(lootId)
    if ClientLoot.Props[lootId] and DoesEntityExist(ClientLoot.Props[lootId]) then
        DeleteEntity(ClientLoot.Props[lootId])
        ClientLoot.Props[lootId] = nil
    end
    ClientLoot.Items[lootId] = nil
end)

RegisterNetEvent("battleground:cl:syncInventory", function(inventory)
    ClientState.Inventory = inventory
end)

-- Render thread for ground loot 3D markers and pickup prompt
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local nearestLoot = nil
        local nearestDist = 999.0

        for id, item in pairs(ClientLoot.Items) do
            local dist = Utils.GetDistance3D(pCoords, item.coords)
            if dist < 15.0 then
                DrawMarker(2, item.coords.x, item.coords.y, item.coords.z + 0.2, 0,0,0, 0,0,0, 0.3, 0.3, 0.3, 56, 189, 248, 200, false, true, 2, false, nil, nil, false)
                if dist < nearestDist then
                    nearestDist = dist
                    nearestLoot = item
                end
            end
        end

        if nearestLoot and nearestDist <= (Config.LootPickupDistance or 2.5) then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(string.format("Press ~INPUT_PICKUP~ [E] to pick up ~b~%s~s~", nearestLoot.name))
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsControlJustPressed(0, 38) then -- E key
                TriggerServerEvent("battleground:sv:pickupLoot", nearestLoot.id)
                Wait(300)
            end
        end
    end
end)
