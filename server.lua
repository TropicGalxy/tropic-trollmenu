local QBCore = exports['qb-core']:GetCoreObject()

local function isAdmin(src)
    return IsPlayerAceAllowed(src, "admin")
end

RegisterNetEvent('tropic-trollmenu:openMenu', function()
    local src = source
    if isAdmin(src) then
        TriggerClientEvent('tropic-trollmenu:showMenu', src)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'You do not have permission to access this menu.',
            type = 'error'
        })
    end
end)

local function handleAction(eventName, targetId, action)
    local src = source
    if not isAdmin(src) then
        print(string.format("Unauthorized attempt: Player [%s] tried to %s", GetPlayerName(src), action))
        return
    end

    TriggerClientEvent(eventName, targetId)
end

RegisterNetEvent('tropic-trollmenu:explodePlayer', function(targetId)
    handleAction('tropic-trollmenu:clientExplodePlayer', targetId, "explode a player")
end)

RegisterNetEvent('tropic-trollmenu:flipVehicle', function(targetId)
    handleAction('tropic-trollmenu:clientFlipVehicle', targetId, "flip a vehicle")
end)

RegisterNetEvent('tropic-trollmenu:spawnClownArmy', function(targetId)
    handleAction('tropic-trollmenu:clientSpawnClownArmy', targetId, "spawn a clown army")
end)

RegisterNetEvent('tropic-trollmenu:attackPlayer', function(targetId)
    handleAction('tropic-trollmenu:clientAttackPlayer', targetId, "attack a player")
end)

RegisterNetEvent('tropic-trollmenu:spinPlayer', function(targetId)
    handleAction('tropic-trollmenu:clientSpinPlayer', targetId, "spin a player")
end)
