local QBCore = exports['qb-core']:GetCoreObject()

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
            description = 'Spawns attackers with baseball bats to attack the player senselessly',
            icon = 'user-ninja',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:attackPlayer')
            end
        },
        {
            title = 'Spin Player',
            description = 'Makes the target player spin like an idiot',
            icon = 'arrows-spin',
            onSelect = function()
                getTargetPlayerId('tropic-trollmenu:spinPlayer')
            end
        }
     }
})

RegisterCommand("opentrollmenu", function()
    TriggerServerEvent('tropic-trollmenu:openMenu')
end, false)

RegisterNetEvent('tropic-trollmenu:showMenu')
AddEventHandler('tropic-trollmenu:showMenu', function()
    lib.showContext('admin_troll_menu')
end)

function getTargetPlayerId(event)
    local input = lib.inputDialog("Enter Target Player ID", {
        {
            type = "number",
            label = "Player ID",
            required = true
        }
    })

    if input then
        local targetId = tonumber(input[1])
        if targetId then
            TriggerServerEvent(event, targetId)
        else
            lib.notify({
                description = 'Invalid player ID!',
                type = 'error'
            })
        end
    end
end

RegisterNetEvent('tropic-trollmenu:clientExplodePlayer')
AddEventHandler('tropic-trollmenu:clientExplodePlayer', function()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    AddExplosion(pos.x, pos.y, pos.z, 2, 5.0, true, false, 1.0)
end)

RegisterNetEvent('tropic-trollmenu:clientFlipVehicle')
AddEventHandler('tropic-trollmenu:clientFlipVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle and vehicle ~= 0 then
        SetEntityRotation(vehicle, 180.0, 0.0, GetEntityHeading(vehicle), 1, true)
        lib.notify({
            description = 'Did i just hit a rock?',
            type = 'inform'
        })
    else
        lib.notify({
            description = 'That player is not in a vehicle!',
            type = 'error'
        })
    end
end)

RegisterNetEvent('tropic-trollmenu:clientSpawnClownArmy')
AddEventHandler('tropic-trollmenu:clientSpawnClownArmy', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for i = 1, 5 do
        local model = GetHashKey("s_m_y_clown_01")
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end

        local offset = vector3(math.random(-5, 5), math.random(-5, 5), 0)
        local clown = CreatePed(4, model, playerCoords + offset, 0.0, true, false)
        TaskStartScenarioInPlace(clown, "WORLD_HUMAN_MUSICIAN", 0, true)
        
        SetTimeout(5000, function()
            if DoesEntityExist(clown) then
                DeleteEntity(clown)
            end
        end)
    end

    lib.notify({
        description = 'What the hell am I geeked?',
        type = 'inform'
    })
end)

RegisterNetEvent('tropic-trollmenu:clientAttackPlayer')
AddEventHandler('tropic-trollmenu:clientAttackPlayer', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local attackers = {}

    local model = GetHashKey("g_m_y_ballaeast_01") 
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    for i = 1, 4 do
        local offset = vector3(math.random(-5, 5), math.random(-5, 5), 0)
        local attacker = CreatePed(4, model, playerCoords + offset, 0.0, true, false)
        GiveWeaponToPed(attacker, GetHashKey("weapon_bat"), 1, false, true)
        TaskCombatPed(attacker, playerPed, 0, 16)
        SetPedRelationshipGroupHash(attacker, GetHashKey("HATES_PLAYER"))
        attackers[#attackers + 1] = attacker
    end

    lib.notify({
        description = 'What did i do to you guys?',
        type = 'warning'
    })

    SetTimeout(30000, function()
        for _, ped in ipairs(attackers) do
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
    end)
end)

RegisterNetEvent('tropic-trollmenu:clientSpinPlayer')
AddEventHandler('tropic-trollmenu:clientSpinPlayer', function()
    local playerPed = PlayerPedId()

      lib.notify({
            description = "Am i in a fucking whirlpool?",
            type = 'inform'
        })  

    CreateThread(function()
        local startTime = GetGameTimer()
        local isGravityDisabled = true

        while isGravityDisabled and GetGameTimer() - startTime < 5000 do

            ApplyForceToEntity(playerPed, 1, 0.0, 0.0, 5.0, 0.0, 0.0, 0.0, true, true, true, false, true, true)
            
            local rot = GetEntityRotation(playerPed)
            SetEntityRotation(playerPed, rot.x + 5.0, rot.y + 5.0, rot.z + 10.0, 2, true)

            Wait(50)
        end


        ApplyForceToEntity(playerPed, 1, 0.0, 0.0, -50.0, 0.0, 0.0, 0.0, true, true, true, false, true, true)


        isGravityDisabled = false
    end)
end)
