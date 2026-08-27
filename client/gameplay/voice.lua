VoiceModeManager = VoiceModeManager or {}
VoiceModeManager.CurrentMode = "SQUAD"
VoiceModeManager.TeamChannel = 0

RegisterNetEvent("battleground:cl:syncVoiceChannel", function(channelId)
    VoiceModeManager.TeamChannel = channelId or 0
    VoiceModeManager.ApplyVoiceMode()
end)

function VoiceModeManager.ApplyVoiceMode()
    if GetResourceState('pma-voice') ~= 'started' then return end

    if VoiceModeManager.CurrentMode == "SQUAD" then
        if VoiceModeManager.TeamChannel and VoiceModeManager.TeamChannel > 0 then
            exports['pma-voice']:setRadioChannel(VoiceModeManager.TeamChannel)
            exports['pma-voice']:setVoiceProperty('radioEnabled', true)
        end
    else
        -- PUBLIC Mode: Disable Radio Channel, Use Proximity Voice (Nearby Enemies & All Players)
        exports['pma-voice']:setRadioChannel(0)
        exports['pma-voice']:setVoiceProperty('radioEnabled', false)
    end
end

function VoiceModeManager.ToggleMode()
    if VoiceModeManager.CurrentMode == "SQUAD" then
        VoiceModeManager.CurrentMode = "PUBLIC"
        VoiceModeManager.ApplyVoiceMode()
        TriggerEvent("battleground:cl:notification", "VOICE CHAT: [📢 PUBLIC PROXIMITY] (Semua orang di sekitar bisa dengar)", "info")
    else
        VoiceModeManager.CurrentMode = "SQUAD"
        VoiceModeManager.ApplyVoiceMode()
        TriggerEvent("battleground:cl:notification", "VOICE CHAT: [🎙️ SQUAD RADIO] (Hanya rekan tim yang bisa dengar)", "success")
    end
end

-- Keybind: Press B key (Control 29 / INPUT_SPECIAL_ABILITY_SECONDARY or B key) to toggle Voice Mode
CreateThread(function()
    while true do
        Wait(0)
        -- Key B (Control 29)
        if IsControlJustPressed(0, 29) then
            VoiceModeManager.ToggleMode()
        end
    end
end)

RegisterCommand("voicemode", function()
    VoiceModeManager.ToggleMode()
end, false)
