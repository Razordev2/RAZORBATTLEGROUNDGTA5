ServerInventory = ServerInventory or {}

function ServerInventory.AddItem(src, itemType, itemName, count)
    local player = PlayerManager.GetPlayer(src)
    if not player then return end

    count = count or 1

    if itemType == Constants.ItemType.WEAPON then
        player.inventory.weapons[itemName] = { ammo = Config.Weapons[GetHashKey(itemName)] and Config.Weapons[GetHashKey(itemName)].defaultAmmo or 60 }
        -- Give weapon to ped
        local ped = GetPlayerPed(src)
        GiveWeaponToPed(ped, GetHashKey(itemName), player.inventory.weapons[itemName].ammo, false, true)
    elseif itemType == Constants.ItemType.AMMO then
        -- Add ammo to currently held weapon
        local ped = GetPlayerPed(src)
        AddAmmoToPed(ped, GetSelectedPedWeapon(ped), count)
    elseif itemType == Constants.ItemType.MEDICAL or itemType == Constants.ItemType.ARMOR then
        player.inventory.items[itemName] = (player.inventory.items[itemName] or 0) + count
        if itemName == "armor_lvl1" or itemName == "armor_lvl2" or itemName == "armor_lvl3" then
            local ped = GetPlayerPed(src)
            SetPedArmour(ped, 100)
        end
    end

    TriggerClientEvent("battleground:cl:syncInventory", src, player.inventory)
    TriggerClientEvent("battleground:cl:notification", src, _L("loot_picked", itemName), "success")
end

function ServerInventory.RemoveItem(src, itemName, count)
    local player = PlayerManager.GetPlayer(src)
    if not player then return false end

    count = count or 1
    if (player.inventory.items[itemName] or 0) >= count then
        player.inventory.items[itemName] = player.inventory.items[itemName] - count
        TriggerClientEvent("battleground:cl:syncInventory", src, player.inventory)
        return true
    end
    return false
end

function ServerInventory.GiveItem(giverSrc, targetSrc, itemType, itemName, count)
    local giver = PlayerManager.GetPlayer(giverSrc)
    local target = PlayerManager.GetPlayer(targetSrc)

    if not giver or not target then
        TriggerClientEvent("battleground:cl:notification", giverSrc, "Target player not found", "error")
        return false
    end

    count = tonumber(count) or 1
    if count <= 0 then return false end

    local giverPed = GetPlayerPed(giverSrc)
    local targetPed = GetPlayerPed(targetSrc)
    local dist = Utils.GetDistance3D(GetEntityCoords(giverPed), GetEntityCoords(targetPed))

    if dist > 3.5 then
        TriggerClientEvent("battleground:cl:notification", giverSrc, "Target player is too far away", "error")
        return false
    end

    if itemType == Constants.ItemType.WEAPON then
        if giver.inventory.weapons[itemName] then
            giver.inventory.weapons[itemName] = nil
            RemoveWeaponFromPed(giverPed, GetHashKey(itemName))
            ServerInventory.AddItem(targetSrc, Constants.ItemType.WEAPON, itemName, 1)
            TriggerClientEvent("battleground:cl:syncInventory", giverSrc, giver.inventory)
            TriggerClientEvent("battleground:cl:notification", giverSrc, string.format("Gave %s to %s", itemName, target.name), "success")
            TriggerClientEvent("battleground:cl:notification", targetSrc, string.format("Received %s from %s", itemName, giver.name), "info")
            return true
        end
    else
        if (giver.inventory.items[itemName] or 0) >= count then
            giver.inventory.items[itemName] = giver.inventory.items[itemName] - count
            ServerInventory.AddItem(targetSrc, itemType, itemName, count)
            TriggerClientEvent("battleground:cl:syncInventory", giverSrc, giver.inventory)
            TriggerClientEvent("battleground:cl:notification", giverSrc, string.format("Gave %d %s to %s", count, itemName, target.name), "success")
            TriggerClientEvent("battleground:cl:notification", targetSrc, string.format("Received %d %s from %s", count, itemName, giver.name), "info")
            return true
        end
    end

    TriggerClientEvent("battleground:cl:notification", giverSrc, "You do not have enough of this item", "error")
    return false
end

RegisterNetEvent("battleground:sv:giveItem", function(targetSrc, itemType, itemName, count)
    local giverSrc = source
    ServerInventory.GiveItem(giverSrc, targetSrc, itemType, itemName, count)
end)

RegisterNetEvent("battleground:sv:useItem", function(itemName)
    local src = source
    local player = PlayerManager.GetPlayer(src)
    if not player then return end

    if itemName == "medkit" then
        if ServerInventory.RemoveItem(src, "medkit", 1) then
            local ped = GetPlayerPed(src)
            SetEntityHealth(ped, 200)
            player.health = 100
            TriggerClientEvent("battleground:cl:notification", src, "Used Medkit! Health fully restored.", "success")
        end
    elseif itemName == "bandage" then
        if ServerInventory.RemoveItem(src, "bandage", 1) then
            local ped = GetPlayerPed(src)
            local h = GetEntityHealth(ped)
            SetEntityHealth(ped, math.min(200, h + 25))
            player.health = math.min(100, player.health + 25)
            TriggerClientEvent("battleground:cl:notification", src, "Used Bandage! Restored 25 HP.", "success")
        end
    elseif itemName == "armor_lvl1" or itemName == "armor_lvl2" or itemName == "armor_lvl3" then
        if ServerInventory.RemoveItem(src, itemName, 1) then
            local ped = GetPlayerPed(src)
            SetPedArmour(ped, 100)
            player.armor = 100
            TriggerClientEvent("battleground:cl:notification", src, "Equipped Body Armor!", "success")
        end
    end
end)
