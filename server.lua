local vehicleSpeedLimits = {}

RegisterServerEvent("setVehicleSpeedLimit")
AddEventHandler("setVehicleSpeedLimit", function(vehicle, speedLimit)
    if not vehicleSpeedLimits[vehicle] then
        vehicleSpeedLimits[vehicle] = speedLimit
        TriggerClientEvent("updateVehicleSpeedLimit", -1, vehicle, speedLimit)
    end
end)

RegisterServerEvent("resetVehicleSpeedLimit")
AddEventHandler("resetVehicleSpeedLimit", function(vehicle)
    if vehicleSpeedLimits[vehicle] then
        vehicleSpeedLimits[vehicle] = nil
        TriggerClientEvent("resetVehicleSpeedLimit", -1, vehicle)
    end
end)
