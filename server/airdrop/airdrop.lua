ServerAirdrop = ServerAirdrop or {}

RegisterNetEvent("battleground:sv:lootAirdrop", function(airdropId)
    local src = source
    local airdrop = ServerState.Airdrops[airdropId]
    if not airdrop then return end

    local ped = GetPlayerPed(src)
    local dist = Utils.GetDistance3D(GetEntityCoords(ped), airdrop.coords)
    if dist > 4.0 then return end

    -- Give Airdrop Loot
    ServerInventory.AddItem(src, Constants.ItemType.WEAPON, "WEAPON_COMBATMG", 1)
    ServerInventory.AddItem(src, Constants.ItemType.ARMOR, "armor_lvl3", 1)
    ServerInventory.AddItem(src, Constants.ItemType.MEDICAL, "medkit", 2)

    ServerState.Airdrops[airdropId] = nil
    TriggerClientEvent("battleground:cl:removeAirdrop", -1, airdropId)
    TriggerClientEvent("battleground:cl:notification", src, "Looted Supply Airdrop Crate!", "success")
end)
