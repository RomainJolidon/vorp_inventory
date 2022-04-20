RegisterNetEvent('syn:getnuistuff')
AddEventHandler('syn:getnuistuff', function(x,y,mon,gol)
	local nuistuff = x 
    local player = PlayerPedId()

	SendNUIMessage({
		action = "changecheck",
		check = nuistuff,
		info = y,
	})
    SendNUIMessage({
        action      = "updateStatusHud",
        show        = not IsRadarHidden(),
        money       = mon,
        gold        = gol,
        id          = GetPlayerServerId(NetworkGetEntityOwner(player))
    })
end)

AddEventHandler('onClientResourceStart', function (resourceName) -- TODO remove once dev finished
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('loading resource')
    SetNuiFocus(false, false)
	SendNUIMessage({action= "hide"})
	print("Loading Inventory")
	TriggerServerEvent("vorpinventory:getItemsTable")
	Wait(300)
	TriggerServerEvent("vorpinventory:getInventory")
  end)
