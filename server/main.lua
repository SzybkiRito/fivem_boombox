--[[
    Made by SzybkiRito#4211
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('boombox', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('boombox', 1)
    TriggerClientEvent('rg:placeBoomBox', _source)
end)

RegisterServerEvent('rg:turnOnMusicForAllInArea')
AddEventHandler('rg:turnOnMusicForAllInArea', function(url, coords, type) 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == 'play' then
        TriggerClientEvent('rg:playMusicInArea', -1, url, coords, xPlayer.playerId)
    elseif type == 'off' then
        TriggerClientEvent('rg:offMusicInArea', -1, xPlayer.playerId)
    elseif type == 'resume' then
        TriggerClientEvent('rg:resumeMusicInArea', -1, xPlayer.playerId)
    elseif type == 'pause' then
        TriggerClientEvent('rg:pauseMusicInArea', -1, xPlayer.playerId)
    elseif type == 'volume' then
        TriggerClientEvent('rg:volumeMusicInArea', -1, url, xPlayer.playerId)
    elseif type == 'pickUpPlay' then
        TriggerClientEvent('rg:pickUpSoundStatus', -1, musicId, coords, url, xPlayer.playerId)
    end
end)

RegisterServerEvent('rg:takeBoomBox')
AddEventHandler('rg:takeBoomBox', function() 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('boombox', 1) then
		xPlayer.addInventoryItem('boombox', 1)
	end
    TriggerClientEvent('rg:pauseMusicInArea', -1, xPlayer.playerId)
end)