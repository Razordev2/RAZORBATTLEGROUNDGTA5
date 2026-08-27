RegisterNetEvent("battleground:cl:toggleRedeemUI", function(show)
    SetNuiFocus(show, show)
    SendNUIMessage({
        action = "toggleRedeemUI",
        show = show
    })
end)

-- Commands for Redeem UI
RegisterCommand("redeem", function()
    TriggerEvent("battleground:cl:toggleRedeemUI", true)
end, false)

RegisterCommand("redeemcode", function()
    TriggerEvent("battleground:cl:toggleRedeemUI", true)
end, false)

-- Tactical Map Controls & NUI Callback
local isMapOpen = false

RegisterCommand("map", function()
    isMapOpen = not isMapOpen
    SetNuiFocus(isMapOpen, isMapOpen)
    SendNUIMessage({
        action = "toggleMapUI",
        show = isMapOpen
    })
end, false)

RegisterKeyMapping("map", "Toggle Battleground Tactical Map", "keyboard", "M")

RegisterNUICallback("closeMapUI", function(data, cb)
    isMapOpen = false
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Spectate Test Commands
RegisterCommand("spectate", function()
    TriggerEvent("battleground:cl:startSpectate", {
        { source = GetPlayerServerId(PlayerId()), name = "Rexy", kills = 4, health = 100 },
        { source = GetPlayerServerId(PlayerId()), name = "Kaiser", kills = 2, health = 75 }
    })
end, false)

RegisterCommand("stopspectate", function()
    TriggerEvent("battleground:cl:stopSpectate")
end, false)

-- Enemy Ping Test Command
RegisterCommand("ping", function()
    TriggerEvent("battleground:cl:showEnemyPing", { distance = 145, author = "Rexy" })
end, false)

-- Kill FX & Kill Feed Test Command
RegisterCommand("testkill", function()
    SendNUIMessage({
        action = "pushKillFeed",
        killer = "Rexy",
        victim = "Shadow",
        isHeadshot = true,
        weaponName = "AK-47",
        isLocalKiller = true,
        streakText = "2X DOUBLE KILL"
    })
end, false)

-- Airdrop Notification Client Event & Commands
RegisterNetEvent("battleground:cl:showAirdrop", function(customMsg)
    SendNUIMessage({
        action = "showAirdrop",
        message = customMsg or "PERIKSA PETA / COMPASS UNTUK LOKASI DROP"
    })
end)

RegisterCommand("airdrop", function()
    TriggerEvent("battleground:cl:showAirdrop", "AIRDROP SUPPLY BERADA DI SEKITAR MAP!")
end, false)

-- Zone Warning Client Event & Commands
RegisterNetEvent("battleground:cl:showZoneWarn", function(data)
    PlaySoundFrontend(-1, "Checkpoints_Learned", "HUD_MINI_GAME_SOUNDSET", true)
    SendNUIMessage({
        action = "showZoneWarn",
        title = data and data.title or "ZONA MULAI BERGERAK!",
        message = data and data.message or "SEGERA MASUK KE DALAM LINGKARAN AMAN ZONA!"
    })
end)

RegisterCommand("zonawarn", function()
    TriggerEvent("battleground:cl:showZoneWarn", {
        title = "ZONA MULAI BERGERAK!",
        message = "SEGERA MASUK KE DALAM LINGKARAN AMAN ZONA!"
    })
end, false)

-- Custom Chat Client Events & NUI Callbacks
RegisterNetEvent("battleground:cl:addChatMessage", function(msgData)
    SendNUIMessage({
        action = "addChatMessage",
        tag = msgData.tag or "PLAYER",
        author = msgData.author or "Player",
        message = msgData.message or "",
        isAdmin = msgData.isAdmin or false
    })
end)

RegisterNUICallback("closeChatUI", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("submitChatMessage", function(data, cb)
    SetNuiFocus(false, false)
    if data and data.message then
        TriggerServerEvent("battleground:sv:sendChatMessage", data.message)
    end
    cb("ok")
end)

-- NUI Callbacks
RegisterNUICallback("closeRedeemUI", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggleRedeemUI", show = false })
    cb("ok")
end)

RegisterNUICallback("submitRedeemCode", function(data, cb)
    TriggerServerEvent("battleground:sv:redeemCode", data.code)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggleRedeemUI", show = false })
    cb("ok")
end)

RegisterNUICallback("closeResultsUI", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideAllOverlays" })
    cb("ok")
end)

CreateThread(function()
    while true do
        Wait(1000)
        if NetworkIsSessionStarted() then
            TriggerServerEvent("battleground:sv:requestState")
            break
        end
    end
end)
