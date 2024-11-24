local QBCore = exports['qb-core']:GetCoreObject()
local ped = cache.ped 


lib.registerContext({
    id = 'admin_troll_menu',
    title = 'Admin Troll Menu',
    options = {
        {
            title = 'Explode Player',
            description = 'Causes an explosion near the target player',
            icon = 'bomb',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:explodePlayer')
            end
        },
        {
            title = 'Flip Player Vehicle',
            description = 'Flips the target player\'s vehicle upside down',
            icon = 'car-crash',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:flipVehicle')
            end
        },
        {
            title = 'Spawn Clown Army',
            description = 'Spawns clowns around the target player',
            icon = 'user-secret',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:spawnClownArmy')
            end
        },
        {
            title = 'Attack Player',
            description = 'Spawns attackers to attack the player',
            icon = 'user-ninja',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:attackPlayer')
            end
        },
        {
            title = 'Spin Player',
            description = 'Makes the target player spin',
            icon = 'arrows-spin',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:spinPlayer')
            end
        }
    }
})

function getTargetPlayerId(event)
    local input = lib.inputDialog("Enter Target Player ID", {
        { type = "number", label = "Player ID", required = true }
    })

    if input then
        local targetId = tonumber(input[1])
        if targetId then
            TriggerServerEvent(event, targetId)
        else
            lib.notify({ description = 'Invalid player ID!', type = 'error' })
        end
    end
end

RegisterCommand("opentrollmenu", function()
    TriggerServerEvent('tropic-trollmenu:openMenu')
end, false)

RegisterNetEvent('tropic-trollmenu:showMenu', function()
    lib.showContext('admin_troll_menu')
end)

local function notifyPlayer(message, type)
    lib.notify({
        description = message,
        type = type
    })
end

RegisterNetEvent('tropic-trollmenu:clientExplodePlayer', function()
    local pos = GetEntityCoords(ped)
    AddExplosion(pos.x, pos.y, pos.z, 2, 5.0, true, false, 1.0)
end)

RegisterNetEvent('tropic-trollmenu:clientFlipVehicle', function()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle and vehicle ~= 0 then
        SetEntityRotation(vehicle, 180.0, 0.0, GetEntityHeading(vehicle), 1, true)
        notifyPlayer('Did I just hit a rock?', 'inform')
    else
        notifyPlayer('Player is not in a vehicle!', 'error')
    end
end)

RegisterNetEvent('tropic-trollmenu:clientSpawnClownArmy', function()
    local coords = GetEntityCoords(ped)
    lib.requestModel(`s_m_y_clown_01`) 

    for i = 1, 5 do
        local clown = CreatePed(4, `s_m_y_clown_01`, coords + vector3(math.random(-5, 5), math.random(-5, 5), 0), 0.0, true, false)
        TaskStartScenarioInPlace(clown, "WORLD_HUMAN_MUSICIAN", 0, true)

        SetTimeout(5000, function()
            if DoesEntityExist(clown) then DeleteEntity(clown) end
        end)
    end
    notifyPlayer('What the hell am I geeked?', 'inform')
end)

RegisterNetEvent('tropic-trollmenu:clientAttackPlayer', function()
    local coords = GetEntityCoords(ped)
    local attackers = {}

    lib.requestModel(`g_m_y_ballaeast_01`)

    for i = 1, 4 do
        local offset = vector3(math.random(-5, 5), math.random(-5, 5), 0)
        local attacker = CreatePed(4, `g_m_y_ballaeast_01`, coords + offset, 0.0, true, false)
        GiveWeaponToPed(attacker, GetHashKey("weapon_bat"), 1, false, true)
        TaskCombatPed(attacker, ped, 0, 16)
        attackers[#attackers + 1] = attacker
    end

    notifyPlayer('What the hell did I do?', 'inform')

    SetTimeout(30000, function()
        for _, entity in ipairs(attackers) do
            if DoesEntityExist(entity) then DeleteEntity(entity) end
        end
    end)
end)

RegisterNetEvent('tropic-trollmenu:clientSpinPlayer', function()
    notifyPlayer('Did I just enter a whirlpool?', 'inform')
    local startTime = GetGameTimer()

    CreateThread(function()
        while GetGameTimer() - startTime < 5000 do
            ApplyForceToEntity(ped, 1, 0.0, 0.0, 5.0, 0.0, 0.0, 0.0, true, true, true, false, true, true)
            local rot = GetEntityRotation(ped)
            SetEntityRotation(ped, rot.x + 5.0, rot.y + 5.0, rot.z + 10.0, 2, true)
            Wait(50)
        end
        ApplyForceToEntity(ped, 1, 0.0, 0.0, -50.0, 0.0, 0.0, 0.0, true, true, true, false, true, true)
    end)
end)
