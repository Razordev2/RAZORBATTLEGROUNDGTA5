ClientZone = ClientZone or {}

ClientZone.CurrentBlip = nil
ClientZone.NextBlip = nil

RegisterNetEvent("battleground:cl:syncZone", function(zoneData)
    if not zoneData then return end

    -- Render Current Zone Blip (White)
    if not ClientZone.CurrentBlip or not DoesBlipExist(ClientZone.CurrentBlip) then
        ClientZone.CurrentBlip = AddBlipForRadius(zoneData.currentCenter.x, zoneData.currentCenter.y, zoneData.currentCenter.z, zoneData.currentRadius)
        SetBlipColour(ClientZone.CurrentBlip, 0) -- White
        SetBlipAlpha(ClientZone.CurrentBlip, 64)
    else
        SetBlipCoords(ClientZone.CurrentBlip, zoneData.currentCenter.x, zoneData.currentCenter.y, zoneData.currentCenter.z)
        SetBlipScale(ClientZone.CurrentBlip, zoneData.currentRadius)
    end

    -- Render Next Zone Blip (Blue)
    if not ClientZone.NextBlip or not DoesBlipExist(ClientZone.NextBlip) then
        ClientZone.NextBlip = AddBlipForRadius(zoneData.nextCenter.x, zoneData.nextCenter.y, zoneData.nextCenter.z, zoneData.nextRadius)
        SetBlipColour(ClientZone.NextBlip, 3) -- Blue
        SetBlipAlpha(ClientZone.NextBlip, 128)
    else
        SetBlipCoords(ClientZone.NextBlip, zoneData.nextCenter.x, zoneData.nextCenter.y, zoneData.nextCenter.z)
        SetBlipScale(ClientZone.NextBlip, zoneData.nextRadius)
    end
end)
