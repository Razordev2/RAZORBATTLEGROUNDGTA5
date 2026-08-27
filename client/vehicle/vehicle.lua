ClientVehicle = ClientVehicle or {}

-- Auto-start engine and unlock keys when entering match vehicles
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            SetVehicleEngineOn(veh, true, true, false)
            SetVehicleDoorsLocked(veh, 1)
        end
    end
end)
