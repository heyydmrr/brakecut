local QBCore = exports['qb-core']:GetCoreObject()
local frenKesilenAraclar = {}

exports['qb-target']:AddGlobalVehicle({
    options = {
        {
            label = "Freni Kes",
            icon = "fas fa-tools",
            item = Config.FrenKesmeItem,
            action = function(entity)
                FreniKes(entity)
            end,
            canInteract = function(entity, distance, data)
                return distance < 2.5 and not frenKesilenAraclar[VehToNet(entity)]
            end
        }
    },
    distance = 2.5
})

function SetFrenKesmeHandling(veh, state)
    if not DoesEntityExist(veh) then return end

    if state then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', 0.0)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fHandBrakeForce', 0.0)
        SetVehicleBrakeLights(veh, false)
    else
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', 0.0)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fHandBrakeForce', 0.0)
    end
end

function FreniKes(vehicle)
    local ped = PlayerPedId()
    local vehNetId = VehToNet(vehicle)

    if not QBCore.Functions.HasItem(Config.FrenKesmeItem) then
        QBCore.Functions.Notify("Yankeski lazım!", "error")
        return
    end

    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)

    exports['ps-ui']:Circle(function(success)
        if success then
            QBCore.Functions.Progressbar('fren_kesme', 'Fren Kesiliyor...', Config.FrenKesmeSure, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                ClearPedTasks(ped)
                QBCore.Functions.Notify("Frenler kesildi!", "success")
                frenKesilenAraclar[vehNetId] = true
                SetFrenKesmeHandling(vehicle, true)
                TriggerServerEvent('yankeski_fren:syncFrenKes', vehNetId, true)
            end, function()
                ClearPedTasks(ped)
                QBCore.Functions.Notify("İşlem iptal edildi", "error")
            end)
        else
            ClearPedTasks(ped)
            QBCore.Functions.Notify("Minigame Başarısız!", "error")
        end
    end, 3, 10)
end

RegisterNetEvent('yankeski_fren:clientSync')
AddEventHandler('yankeski_fren:clientSync', function(vehNetId, state)
    frenKesilenAraclar[vehNetId] = state
    local veh = NetToVeh(vehNetId)
    if DoesEntityExist(veh) then
        SetFrenKesmeHandling(veh, state)
    end
end)

RegisterNetEvent('yankeski_fren:useFrenKablosu', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        QBCore.Functions.Notify("Araçta değilsin!", "error")
        return
    end

    local vehNetId = VehToNet(veh)
    if frenKesilenAraclar[vehNetId] then
        QBCore.Functions.Notify("Frenler tamir edildi!", "success")
        frenKesilenAraclar[vehNetId] = nil
        SetFrenKesmeHandling(veh, false)
        TriggerServerEvent('yankeski_fren:syncFrenKes', vehNetId, false)
    else
        QBCore.Functions.Notify("Bu aracın frenleri sağlam!", "error")
    end
end)
