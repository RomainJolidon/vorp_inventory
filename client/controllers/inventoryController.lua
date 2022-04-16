RegisterNetEvent("vorpInventory:giveItemsTable")
AddEventHandler("vorpInventory:giveItemsTable", InventoryService.processItems)

RegisterNetEvent("vorpInventory:giveInventory")
AddEventHandler("vorpInventory:giveInventory", InventoryService.getInventory)

RegisterNetEvent("vorpInventory:giveLoadout")
AddEventHandler("vorpInventory:giveLoadout", InventoryService.getLoadout)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", InventoryService.onSelectedCharacter)

RegisterNetEvent("vorpInventory:receiveItem")
AddEventHandler("vorpInventory:receiveItem", InventoryService.receiveItem)

RegisterNetEvent("vorpInventory:receiveItem2")
AddEventHandler("vorpInventory:receiveItem2", InventoryService.receiveItem2)

RegisterNetEvent("vorpinventory:receiveWeapon")
AddEventHandler("vorpinventory:receiveWeapon", InventoryService.receiveWeapon)

Citizen.CreateThread(InventoryService.updateAmmoInWeapon)
	