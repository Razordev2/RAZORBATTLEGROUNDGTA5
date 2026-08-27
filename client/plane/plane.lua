ClientPlane = ClientPlane or {}

ClientPlane.InPlane = false
ClientPlane.PlaneEntity = nil
ClientPlane.FlightPath = nil
ClientPlane.StartTime = 0

function ClientPlane.Setup(flightPath)
    ClientPlane.FlightPath = flightPath or {
        startCoords = vec3(-2000.0, -3000.0, Config.PlaneAltitude or 500.0),
        endCoords = vec3(2000.0, 3000.0, Config.PlaneAltitude or 500.0),
        heading = 45.0
    }
    ClientPlane.InPlane = true
    ClientPlane.StartTime = GetGameTimer()

    local ped = PlayerPedId()

    -- Spawn physical Cargo Aircraft model for visual & sound
    local modelHash = `titan`
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 100 do
        Wait(50)
        timeout = timeout + 1
    end

    if HasModelLoaded(modelHash) then
        local start = ClientPlane.FlightPath.startCoords
        ClientPlane.PlaneEntity = CreateVehicle(modelHash, start.x, start.y, start.z, ClientPlane.FlightPath.heading, false, false)
        SetEntityHeading(ClientPlane.PlaneEntity, ClientPlane.FlightPath.heading)
        SetVehicleEngineOn(ClientPlane.PlaneEntity, true, true, false)
        SetVehicleForwardSpeed(ClientPlane.PlaneEntity, Config.PlaneSpeed or 60.0)
        FreezeEntityPosition(ClientPlane.PlaneEntity, true)
    end

    SetEntityCoords(ped, ClientPlane.FlightPath.startCoords.x, ClientPlane.FlightPath.startCoords.y, ClientPlane.FlightPath.startCoords.z, false, false, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)

    -- Attach spectator camera & plane motion thread
    ClientFlight.StartCameraThread()
end

function ClientPlane.Cleanup()
    if ClientPlane.PlaneEntity and DoesEntityExist(ClientPlane.PlaneEntity) then
        DeleteEntity(ClientPlane.PlaneEntity)
        ClientPlane.PlaneEntity = nil
    end
end

RegisterNetEvent("battleground:cl:setupPlane", function(flightPath)
    ClientPlane.Setup(flightPath)
end)
