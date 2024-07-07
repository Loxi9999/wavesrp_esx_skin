RegisterNetEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)
--no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka
ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

RegisterCommand('skinsave', function(source, args, user)
	if source == 0 then
		if id[1]== nil then
			return
		end
		
		TriggerClientEvent('esx_skin:requestSaveSkin', args[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'zarzad' or xPlayer.group == 'headadmin' or xPlayer.group == 'senioradmin' or xPlayer.group == 'admin' or xPlayer.group == 'junioradmin' or xPlayer.group == 'moderator' or xPlayer.group == 'juniormoderator' or xPlayer.group == 'support') then
			TriggerClientEvent('esx_skin:requestSaveSkin', source)
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)
--no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka
RegisterCommand('skin', function(source, id, user)
	if source == 0 then	
		if id[1]== nil then
			return
		end
		TriggerEvent('sendMessageDiscord', "Otwarto menu skina Graczowi o ID " .. id[1])
		TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer ~= nil then
			if (xPlayer.group == 'best' or xPlayer.group == 'zarzad' or xPlayer.group == 'headadmin' or xPlayer.group == 'senioradmin' or xPlayer.group == 'admin' or xPlayer.group == 'junioradmin' or xPlayer.group == 'moderator' or xPlayer.group == 'juniormoderator' or xPlayer.group == 'support') then
				if id[1] ~= nil then
					if GetPlayerPing(id[1]) == 0 then
						xPlayer.showNotification('Niema nikogo o takim ID')
						return
					end
					xPlayer.showNotification('Otwarto menu skin Graczowi')
					TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
				else
					TriggerClientEvent('esx_skin:openSaveableMenu', source)
				end
			else
				xPlayer.showNotification('Nie posiadasz permisji')
			end
		end
	end
end, false)
