ClientCountdown = ClientCountdown or {}

RegisterNetEvent("battleground:cl:syncCountdown", function(seconds)
    if seconds < 0 then
        SendNUIMessage({ action = "hideCountdown" })
        return
    end

    -- Play sound effect locally
    if seconds > 0 and seconds <= 5 then
        PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", true)
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.05)
    elseif seconds == 0 then
        PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", true)
        ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 0.15)
    end

    SendNUIMessage({
        action = "updateCountdown",
        seconds = seconds
    })
end)
