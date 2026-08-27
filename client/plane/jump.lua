ClientJump = ClientJump or {}

function ClientJump.Eject()
    if not ClientPlane.InPlane then return end
    ClientPlane.InPlane = false

    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)

    -- Clean up cargo aircraft entity
    ClientPlane.Cleanup()

    -- Give parachute gadget & force freefall skydive state
    GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, true)

    -- Forward velocity push
    SetEntityVelocity(ped, 0.0, 30.0, -10.0)

    -- Play skydive audio & start altitude tracking
    PlaySoundFrontend(-1, "FLIGHT_SCHOOL_LESSON_PASSED", "HUD_AWARDS", true)
    ClientParachute.StartParachuteThread()
end

CreateThread(function()
    while true do
        Wait(0)
        if ClientPlane.InPlane then
            if IsControlJustPressed(0, 22) or IsControlJustPressed(0, 47) then -- SPACE or G key
                ClientJump.Eject()
            end
        end
    end
end)
