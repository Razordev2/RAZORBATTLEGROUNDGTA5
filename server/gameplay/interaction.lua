ServerInteraction = ServerInteraction or {}

RegisterNetEvent("battleground:sv:pickupLoot", function(lootId)
    local src = source
    local player = PlayerManager.GetPlayer(src)
    if not player then return end

    local loot = ServerState.GroundLoot[lootId]
    if not loot then return end

    -- Distance validation on server side
    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local dist = Utils.GetDistance3D(pCoords, loot.coords)

    if dist > (Config.LootPickupDistance or 3.0) + 1.5 then
        print(string.format("[Anti-Exploit] Player %s tried picking up loot out of range (Dist: %f)", player.name, dist))
        return
    end

    -- Add item to inventory and remove ground loot
    ServerInventory.AddItem(src, loot.itemType, loot.name, loot.count)
    ServerLoot.RemoveGroundItem(lootId)
end)
