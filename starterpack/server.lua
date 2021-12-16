
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
 


ESX.RegisterServerCallback('odbierz:check', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetLicenseID(source)

    MySQL.Async.fetchScalar('SELECT odebrane FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(odebrane)

		cb(odebrane)
        print(odebrane)
	end)

end)

RegisterServerEvent('odbierz:odebrane')
AddEventHandler('odbierz:odebrane', function(odebrane)
	local identifier = GetLicenseID(source)

	MySQL.Sync.execute('UPDATE users SET odebrane = @odebrane WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@odebrane']     = odebrane
	})
end)

RegisterServerEvent('odbierz:giveitem')
AddEventHandler('odbierz:giveitem', function()
	local xPlayer = ESX.GetPlayerFromId(source) 
    xPlayer.addInventoryItem("pistol", 1)
    xPlayer.addInventoryItem("pistol_ammo_box", 20)
    xPlayer.addInventoryItem("bread", 15)
    xPlayer.addInventoryItem("water", 15)
    sendToDiscord('Odbierz','Gracz ' ..GetPlayerName(source).. ', '..GetLicenseID(source)..' odebrał /odbierz' ,3999999)
end)


function sendToDiscord (name,message,color)
	local DiscordWebHook = 'WEBHOOK'
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



GetLicenseID = function(src)
    local sid = GetPlayerIdentifiers(src)
    local license = 'Brak'
    for k,v in ipairs(sid)do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            break
        end
    end

    return license
end
