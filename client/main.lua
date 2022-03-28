--[[
    Made by SzybkiRito#4211
]]

-- ESX
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--END ESX
local menuOpen = false
local wasOpen = false
local lastEntity = nil
local currentAction = nil
local currentData = nil
local xsound = exports.xsound

local musicPlayed = {}

RegisterNetEvent('rg:placeBoomBox')
AddEventHandler('rg:placeBoomBox', function() 
	startAnimation("anim@heists@money_grab@briefcase","put_down_case")
	Wait(1000)
	ClearPedTasks(PlayerPedId())
	-- TriggerEvent('esx:spawnObject', 'prop_boombox_01')
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    ESX.Game.SpawnObject('prop_boombox_01', vector3(x, y, z-0.95))
    -- CreateObject('prop_boombox_01', GetEntityCoords(PlayerPedId()), true, false, false)
end)

RegisterNetEvent('rg:playMusicInArea')
AddEventHandler('rg:playMusicInArea', function(url, coords, identifier) 
    table.insert(musicPlayed, {
        musicId = identifier,
        url = url,
        coords = coords,
    })
    playMusic(musicPlayed)
end)

RegisterNetEvent('rg:resumeMusicInArea')
AddEventHandler('rg:resumeMusicInArea', function(id) 
    xsound:Resume(id)
end)

RegisterNetEvent('rg:pauseMusicInArea')
AddEventHandler('rg:pauseMusicInArea', function(id) 
    xsound:Pause(id)
end)

RegisterNetEvent('rg:offMusicInArea')
AddEventHandler('rg:offMusicInArea', function(id) 
    table.remove(musicPlayed, tablefind(musicPlayed, id))
    xsound:Destroy(id)
end)

RegisterNetEvent('rg:pickUpSoundStatus')
AddEventHandler('rg:pickUpSoundStatus', function(msuciId, coords, url, id) 
    table.insert(musicPlayed, {
        musicId = id,
        url = url,
        coords = coords,
    })
    playMusic(musicPlayed)
end)


RegisterNetEvent('rg:volumeMusicInArea')
AddEventHandler('rg:volumeMusicInArea', function(volume, id) 
    local vol = nil
    if volume == 1 then
        vol = 0.1
    elseif volume == 2 then
        vol = 0.2
    elseif volume == 3 then
        vol = 0.3
    elseif volume == 4 then
        vol = 0.4
    elseif volume == 5 then
        vol = 0.5
    elseif volume == 6 then
        vol = 0.6
    elseif volume == 7 then
        vol = 0.7
    elseif volume == 8 then
        vol = 0.8
    elseif volume == 9 then
        vol = 0.9
    elseif volume == 10 then
        vol = 1.0
    end
    xsound:setVolume(id, vol)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)   

        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        local closestDistance = -1
        local closestEntity   = nil

        local object = GetClosestObjectOfType(coords, 3.0, GetHashKey('prop_boombox_01'), false, false, false)

        if DoesEntityExist(object) then
            objCoords = GetEntityCoords(object)
            local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

            if closestDistance == -1 or closestDistance > distance then
                closestDistance = distance
                closestEntity   = object
            end
        end

        if closestDistance ~= -1 and closestDistance <= Config.Distance then
            if lastEntity ~= closestEntity and not menuOpen then
                showNotificationToBuy('aby otworzyć menu')
               -- ESX.Game.Utils.DrawText3D(objCoords+0.5, "Kliknij [E] aby skorzystać z boomboxa", 1.0, 4)    
                lastEntity = closestEntity
                currentAction = "music"
                currentData = closestEntity
            end
        else
            if lastEntity then
                lastEntity = nil
                currentAction = nil
                currentData = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 38) and currentAction == 'music' then
			OpenBoomboxMenu()
		end 
	end
end)

-- Citizen.CreateThread(function() 
--     while true do
--         Citizen.Wait(0)
--         for k, v in ipairs(musicPlayed) do
--             print(ESX.DumpTable(musicPlayed))
--             xsound:PlayUrlPos(v.musicId, v.url, 1, v.coords)
--             xsound:Distance(v.musicId, Config.DistanceMusic)
--         end
--     end
-- end)

AddEventHandler('onResourceStop', function() 
    for k, v in ipairs(musicPlayed) do
        xsound:Destory(v.musicId)
    end
    for k in pairs (musicPlayed) do
        k[musicPlayed] = nil
    end
end)

function playMusic() 
    for k, v in ipairs(musicPlayed) do
        xsound:PlayUrlPos(v.musicId, v.url, 0.5, v.coords)
        xsound:Distance(v.musicId, Config.DistanceMusic)
        -- xsound:Position(v.musicId, v.coords)
    end
end

-- Citizen.CreateThread(function() 
--     while true do
--         Citizen.Wait(2000)
--         print(ESX.DumpTable(musicPlayed))
--     end
-- end)