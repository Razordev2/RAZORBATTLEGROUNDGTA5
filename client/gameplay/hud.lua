ClientHUD = ClientHUD or {}

ClientHUD.IsInventoryOpen = false

function ClientHUD.ToggleInventory(show)
    ClientHUD.IsInventoryOpen = show
    SetNuiFocus(show, show)
    SendNUIMessage({
        action = "toggleInventoryUI",
        show = show,
        inventory = ClientState.Inventory
    })
end

RegisterCommand("inventory", function()
    ClientHUD.ToggleInventory(not ClientHUD.IsInventoryOpen)
end, false)

RegisterKeyMapping("inventory", "Toggle Battleground Inventory", "keyboard", "F2")

-- Real-time Team HUD Net Event Sync
RegisterNetEvent("battleground:cl:syncTeamHUD", function(teamData)
    SendNUIMessage({
        action = "updateTeamHUD",
        team = teamData
    })
end)

-- Real-time Player HUD Update Loop
CreateThread(function()
    while true do
        Wait(150)
        local ped = PlayerPedId()

        if DoesEntityExist(ped) then
            local health = math.max(0, GetEntityHealth(ped) - 100)
            local armor = GetPedArmour(ped)
            local weaponHash = GetSelectedPedWeapon(ped)
            local _, clipAmmo = GetAmmoInClip(ped, weaponHash)
            local totalAmmo = GetAmmoInPedWeapon(ped, weaponHash)
            local reserveAmmo = math.max(0, totalAmmo - clipAmmo)
            local isSprinting = IsPedSprinting(ped) or IsPedRunning(ped)

            local weaponName = "UNARMED"
            if Config.Weapons[weaponHash] then
                weaponName = Config.Weapons[weaponHash].label
            end

            SendNUIMessage({
                action = "updatePlayerHUD",
                health = health,
                armor = armor,
                clipAmmo = clipAmmo,
                reserveAmmo = reserveAmmo,
                weaponName = weaponName,
                isSprinting = isSprinting,
                hasArmor = (armor > 0),
                hasHelmet = (GetPedPropIndex(ped, 0) ~= -1)
            })
        end
    end
end)

-- NUI Callbacks for Inventory & Give System
RegisterNUICallback("closeInventoryUI", function(data, cb)
    ClientHUD.ToggleInventory(false)
    cb("ok")
end)

RegisterNUICallback("giveItem", function(data, cb)
    TriggerServerEvent("battleground:sv:giveItem", data.targetSrc, data.itemType, data.itemName, data.count)
    cb("ok")
end)

RegisterNUICallback("useItem", function(data, cb)
    TriggerServerEvent("battleground:sv:useItem", data.itemName)
    cb("ok")
end)
