RegisterServerEvent("vorpinventory:getItemsTable")
AddEventHandler("vorpinventory:getItemsTable", InventoryService.getItemsTable)

RegisterServerEvent("vorpinventory:getInventory")
AddEventHandler("vorpinventory:getInventory", InventoryService.getInventory)

RegisterServerEvent("vorpinventory:getStatus") -- Get update of money and gold. Status is only get from vorp_inventory evevents. money transaction outside script will not update status in Hud
AddEventHandler("vorpinventory:getStatus", InventoryService.getStatus)

RegisterServerEvent("vorpinventory:serverGiveItem")
AddEventHandler("vorpinventory:serverGiveItem", InventoryService.GiveItem)

RegisterServerEvent("vorpinventory:serverGiveWeapon")
AddEventHandler("vorpinventory:serverGiveWeapon", InventoryService.GiveWeapon)

RegisterServerEvent("vorpinventory:serverDropItem")
AddEventHandler("vorpinventory:serverDropItem", InventoryService.DropItem)

RegisterServerEvent("vorpinventory:serverDropMoney")
AddEventHandler("vorpinventory:serverDropMoney", InventoryService.DropMoney)

RegisterServerEvent("vorpinventory:serverDropAllMoney")
AddEventHandler("vorpinventory:serverDropAllMoney", InventoryService.DropAllMoney)

RegisterServerEvent("vorpinventory:serverDropWeapon")
AddEventHandler("vorpinventory:serverDropWeapon", InventoryService.DropWeapon)

RegisterServerEvent("vorpinventory:sharePickupServer")
AddEventHandler("vorpinventory:sharePickupServer", InventoryService.sharePickupServer)

RegisterServerEvent("vorpinventory:shareMoneyPickupServer")
AddEventHandler("vorpinventory:shareMoneyPickupServer", InventoryService.shareMoneyPickupServer)

RegisterServerEvent("vorpinventory:onPickup")
AddEventHandler("vorpinventory:onPickup", InventoryService.onPickup)

RegisterServerEvent("vorpinventory:onPickupMoney")
AddEventHandler("vorpinventory:onPickupMoney", InventoryService.onPickupMoney)

RegisterServerEvent("vorpinventory:setUsedWeapon")
AddEventHandler("vorpinventory:setUsedWeapon", InventoryService.usedWeapon)

RegisterServerEvent("vorpinventory:setWeaponBullets")
AddEventHandler("vorpinventory:setWeaponBullets", InventoryService.setWeaponBullets)

RegisterServerEvent("vorpinventory:giveMoneyToPlayer")
AddEventHandler("vorpinventory:giveMoneyToPlayer", InventoryService.giveMoneyToPlayer)
