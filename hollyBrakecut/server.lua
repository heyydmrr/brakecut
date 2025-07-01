local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('yankeski_fren:syncFrenKes', function(vehNetId, state)
    TriggerClientEvent('yankeski_fren:clientSync', -1, vehNetId, state)
end)

QBCore.Functions.CreateUseableItem('frenkablosu', function(source)
    TriggerClientEvent('yankeski_fren:useFrenKablosu', source)
end)