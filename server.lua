local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tropic-trollmenu:openMenu')
AddEventHandler('tropic-trollmenu:openMenu', function()
    local src = source
    if IsPlayerAceAllowed(src, "admin") then
        TriggerClientEvent('tropic-trollmenu:showMenu', src)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'You do not have permission to access this menu.',
            type = 'error'
        })
    end
end)


RegisterNetEvent('tropic-trollmenu:explodePlayer')
AddEventHandler('tropic-trollmenu:explodePlayer', function(targetId)
    TriggerClientEvent('tropic-trollmenu:clientExplodePlayer', targetId)
end)

RegisterNetEvent('tropic-trollmenu:flipVehicle')
AddEventHandler('tropic-trollmenu:flipVehicle', function(targetId)
    TriggerClientEvent('tropic-trollmenu:clientFlipVehicle', targetId)
end)

RegisterNetEvent('tropic-trollmenu:spawnClownArmy')
AddEventHandler('tropic-trollmenu:spawnClownArmy', function(targetId)
    TriggerClientEvent('tropic-trollmenu:clientSpawnClownArmy', targetId)
end)

RegisterNetEvent('tropic-trollmenu:attackPlayer')
AddEventHandler('tropic-trollmenu:attackPlayer', function(targetId)
    TriggerClientEvent('tropic-trollmenu:clientAttackPlayer', targetId)
end)

RegisterNetEvent('tropic-trollmenu:spinPlayer')
AddEventHandler('tropic-trollmenu:spinPlayer', function(targetId)
    TriggerClientEvent('tropic-trollmenu:clientSpinPlayer', targetId)
end)
