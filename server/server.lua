if Config.OldESX then
	ESX = nil
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterNetEvent('esx:playerLoaded') -- When a player loads in, we can store some basic information about them locally
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
	ESX.Players[playerId] = xPlayer.job.name
    local zPlayer = ESX.GetPlayerFromId(playerId)
    if isNew then
        for k, v in pairs(Config.StarterItems) do
            zPlayer.addInventoryItem(v.databasename, v.count)
            sendToDiscord('Starteritems','Player ' ..GetPlayerName(playerId).. ', '..zPlayer.identifier..' picked up' ,3999999)
			if Config.NotificationSystem == 'ESX' then
				xPlayer.showNotification('You received some starter items')
			elseif Config.NotificationSystem == 'mythic_notify' then
				TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'You received some starter items!', length = 2500, style = { ['background-color'] = '##', ['color'] = '#FFFFFF' } })
			end
        end
    end
end)

function sendToDiscord (name,message,color)
	local DiscordWebHook = Config.Webhook
    local embeds = {
	  {
		  ["title"]=message,
		  ["type"]="rich",
		  ["color"] =color,
		  ["footer"]=  {
			  ["text"]= "starterpack by polacy",
		 },
	  }
  }
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end