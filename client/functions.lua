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
local xsound = exports.xsound

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end


function showNotificationToBuy(text) 
	SetTextComponentFormat('STRING')
	AddTextComponentString('Kliknij ~INPUT_PICKUP~ ' .. text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local pickUp = false
function OpenBoomboxMenu() 
    ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Boombox',
		{
			title    = 'Boombox',
			align    = 'right',
			elements = {
				{label = 'Włącz muzyke', value = 'turn_on_music'},
				{label = 'Wyłącz muzyke', value = 'turn_off_music'},
				{label = 'Pauza', value = 'pause_music'},
				{label = 'Wznów', value = 'resume_music'},
				{label = 'Głośność', value = 'volume_music'},
			--	{label = 'Podnieś boomboxa', value = 'pickup_boombox'},
				{label = 'Schowaj boomboxa', value = 'take_boombox'},
			--	{label = 'Włącz muzyke', value = 'turn_on_music'},
			--	{label = 'Włącz muzyke', value = 'turn_on_music'},
			},
		}, function(data, menu)
			if data.current.value == 'turn_on_music' then
                placeUrlDialogMenu()
			elseif data.current.value == 'turn_off_music' then
				TriggerServerEvent('rg:turnOnMusicForAllInArea', nil, nil, 'off')
			elseif data.current.value == 'pause_music' then
				TriggerServerEvent('rg:turnOnMusicForAllInArea', nil, GetEntityCoords(PlayerPedId()), 'pause')
			elseif data.current.value == 'resume_music' then
				TriggerServerEvent('rg:turnOnMusicForAllInArea', nil, GetEntityCoords(PlayerPedId()), 'resume')
			elseif data.current.value == 'volume_music' then
				placeVolumeMenu()
			elseif data.current.value == 'take_boombox' then
				local prop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1), false), 4.0, GetHashKey('prop_boombox_01'))
				if DoesEntityExist(prop) then
					SetEntityAsMissionEntity(prop, true, true)
					DeleteEntity(prop)
					Citizen.Wait(5)
					ClearPedTasksImmediately(GetPlayerPed(-1))
				end
				pickUp = false
				TriggerServerEvent('rg:takeBoomBox')
			elseif data.current.value == 'pickup_boombox' then
				local prop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1), false), 4.0, GetHashKey('prop_boombox_01'))
				if DoesEntityExist(prop) then
					AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.3, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
					pickUp = true
				end
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function placeUrlDialogMenu() 
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'URL',
    {
        title = 'Wpisz tekst',
    }, function(data, menu)
        if data.value ~= nil then
			TriggerServerEvent('rg:turnOnMusicForAllInArea', data.value, GetEntityCoords(PlayerPedId()), 'play')
			menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function placeVolumeMenu() 
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'volume',
    {
        title = 'Wpisz głośność (1-10)',
    }, function(data, menu)
        if data.value ~= nil and tonumber(data.value) >= 1 and tonumber(data.value) <= 10 then
			TriggerServerEvent('rg:turnOnMusicForAllInArea', tonumber(data.value), GetEntityCoords(PlayerPedId()), 'volume')
			menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function tablefind(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end