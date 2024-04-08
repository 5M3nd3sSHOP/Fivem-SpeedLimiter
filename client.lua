local QBCore = exports['qb-core']:GetCoreObject()
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local vehicleSpeedLimits = {}

RegisterNetEvent("updateVehicleSpeedLimit")
AddEventHandler(
    "updateVehicleSpeedLimit",
    function(vehicle, speedLimit)
        vehicleSpeedLimits[vehicle] = speedLimit
    end
)

RegisterNetEvent("resetVehicleSpeedLimit")
AddEventHandler(
    "resetVehicleSpeedLimit",
    function(vehicle)
        vehicleSpeedLimits[vehicle] = nil
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)

            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                local currentSpeed = GetEntitySpeed(vehicle) * 3.6
                local speedLimit = vehicleSpeedLimits[vehicle]

                if speedLimit and currentSpeed > speedLimit then
                    SetEntityMaxSpeed(vehicle, speedLimit / 3.6)
                end
            end
        end
    end
)

local isModo300Ativado = false

RegisterCommand(Config.Command, function(source, args, rawCommand)
    local _source = source
    local xPlayer = nil
    local jobName = nil

    TriggerEvent('esx:getPlayerFromId', _source, function(player)
        xPlayer = player
        if xPlayer then
            jobName = xPlayer.job.name
        end
    end)

    if xPlayer == nil or jobName == nil then
        local playerData = QBCore.Functions.GetPlayerData(_source)
        if playerData ~= nil then
            jobName = playerData.job.name
        end
    end

    if jobName == 'police' then
        isModo300Ativado = not isModo300Ativado

        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            if isModo300Ativado then
                local currentSpeed = GetEntitySpeed(vehicle) * 3.6
                if Config.framework == "esx" then
                    ESX.ShowNotification("Speed Limited 300Km/h")                               
                    TriggerServerEvent("setVehicleSpeedLimit", vehicle, currentSpeed + 300.0)   
                elseif Config.framework == "qbcore" then    
                    QBCore.Functions.Notify("Speed Limited 300Km/h", "error")    
                    TriggerServerEvent("setVehicleSpeedLimit", vehicle, currentSpeed + 300.0)
                end
            else
                if Config.framework == "esx" then
                    ESX.ShowNotification("Speed Unlimited")                                     
                    TriggerServerEvent("resetVehicleSpeedLimit", vehicle)
                elseif Config.framework == "qbcore" then
                    QBCore.Functions.Notify("Speed Unlimited", "error")                     
                    TriggerServerEvent("resetVehicleSpeedLimit", vehicle)
                end 
            end
        end
    else
        if jobName ~= nil then
            if Config.framework == "esx" then
                TriggerClientEvent('esx:showNotification', _source, 'You do not have permission to use this command.', 'error')                           
            elseif Config.framework == "qbcore" then
                QBCore.Functions.Notify("You do not have permission to use this command.", "error")      
            end
        end
    end
end, false)


