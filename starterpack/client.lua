

ESX = nil 
odebrane = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("starterpack", function()
    ESX.TriggerServerCallback('odbierz:check', function(odebrane)
        if odebrane then 
            ESX.ShowNotification("Nie można odebrać itemów dwa razy!")
        else 
            ESX.ShowNotification("Odebrano itemy!")
            odebrane = true
            TriggerServerEvent("odbierz:odebrane", true)
            TriggerServerEvent("odbierz:giveitem")

        end
    end)
end, false)