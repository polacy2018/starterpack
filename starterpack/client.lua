ESX = nil 
odebrane = false
local antispam = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("starterpack", function()
    local last = GetGameTimer() - antispam
    if last > 5000 then -- 5 seconds
        antispam = GetGameTimer()
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
    else
        ESX.ShowNotification(("You should wait %s seconds."):format(last))
    end
end, false)
