InventoryService = {}
ItemPickUps = {}
MoneyPickUps = {}
Core = {}

Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        Core = core;
    end)
end)

InventoryService.DropMoney = function (amount) 
	local _source = source
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userMoney = userCharacter.money	
	
	if amount <= 0 then
		TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
	elseif userMoney < amount then
		TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughMoney"), 3000)
	else
		userCharacter.removeCurrency(0, amount)

		TriggerClientEvent("vorpInventory:createMoneyPickup", _source, amount)
	end
end

InventoryService.DropAllMoney = function () 
	local _source = source
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userMoney = userCharacter.money

	if userMoney > 0 then
		userCharacter.removeCurrency(0, userMoney)

		TriggerClientEvent("vorp:createMoneyPickup", _source, userMoney)
	end
end

InventoryService.giveMoneyToPlayer = function (target, amount) 
	local _source = source
	local _target = target

	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local targetCharacter = Core.getUser(_target).getUsedCharacter

	local sourceMoney = sourceCharacter.money
	
	if amount <= 0 then
		TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
		Wait(3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
	elseif sourceMoney < amount then
		TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughMoney"), 3000)
		Wait(3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
	else
		sourceCharacter.removeCurrency(0, amount)
		targetCharacter.addCurrency(0, amount)
		
		TriggerClientEvent("vorp:TipRight", _source, string.format(_U("YouPaid"), amount, targetCharacter.firstname .. " " .. targetCharacter.lastname), 3000)
		TriggerClientEvent("vorp:TipRight", _target, string.format(_U("YouReceived"), amount, sourceCharacter.firstname .. " " .. sourceCharacter.lastname), 3000)
		Wait(3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
	end
end

InventoryService.setWeaponBullets = function (weaponId, type, amount) 
	if UsersWeapons[weaponId] ~= nil then
		UsersWeapons[weaponId]:setAmmo(type, amount)
	end
end

InventoryService.SaveInventoryItemsSupport = function () 
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local characterInventory = {}

	if UsersInventories[identifier] ~= nil then
		for _, item in pairs(UsersInventories[identifier]) do
			characterInventory[_] = item
		end

		if characterInventory ~= nil then
			exports.ghmattimysql:execute('UPDATE characters SET inventory = @inventory WHERE identifier = @identifier AND charidentifier = @charid', { 
					['inventory'] = json.encode(characterInventory), 
					['identifier'] = identifier,
					['charidentifier'] = charId
				}, function() 
			end)
		end
	end
end

InventoryService.usedWeapon = function (id, _used, _used2) 
	local used = 0
	local used2 = 0

	if _used then used = 1 end
	if _used2 then used2 = 1 end

	exports.ghmattimysql:execute('UPDATE loadout SET used = @used, used2 = @used2 WHERE id = @id', { 
			['used'] = used, 
			['used2'] = used2,
			['id'] = id
		}, function() 
	end)
end

InventoryService.subItem = function (target, name, amount) 
	local _source = target 
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersInventories[identifier] ~= nil then
		if UsersInventories[identifier][name] ~= nil then
			if amount <= UsersInventories[identifier][name]:getCount() then
				UsersInventories[identifier][name]:quitCount(amount)
			end
			
			if UsersInventories[identifier][name]:getCount() == 0 then
				UsersInventories[identifier][name] = nil
			end
			InventoryService.SaveInventoryItemsSupport()
		end
	end
end

InventoryService.addItem = function (target, name, amount) 
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersInventories[identifier] ~= nil then
		if UsersInventories[identifier][name] ~= nil then
			if amount > 0 then
				UsersInventories[identifier][name]:addCount(amount)
				InventoryService.SaveInventoryItemsSupport()
			end
		else
			if svItems[name] ~= nil then
				UsersInventories[identifier][name] = Item:New({
					count = amount,
					limit = svItems[name]:getLimit(),
					label = svItems[name]:getLabel(),
					name = name,
					type = "item_inventory",
					canUse = svItems[name]:getCanUse(),
					canRemove = svItems[name]:getCanRemove() 
				})
				InventoryService.SaveInventoryItemsSupport()
			end
		end
	end
end

InventoryService.addWeapon = function (target, weaponId) 
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	
	if UsersWeapons[weaponId] ~= nil then
		UsersWeapons[weaponId]:setPropietary(identifier)
		exports.ghmattimysql:execute('UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id', { 
			['identifier'] = identifier, 
			['charid'] = charId,
			['id'] = weaponId
		}, function() 
		end)
	end
end

InventoryService.subWeapon = function (target, weaponId) 
	local _source = target 
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	
	if UsersWeapons[weaponId] ~= nil then	
		UsersWeapons[weaponId]:setPropietary('')
		
		exports.ghmattimysql:execute('UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id', { 
			['identifier'] = identifier,
			['charid'] = charId,
			['id'] = weaponId
		}, function() end)
	end
end

InventoryService.onPickup = function (obj) 
	local _source = source 
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier

	if ItemPickUps[obj] ~= nil then
		local name = ItemPickUps[obj].name
		local amount = ItemPickUps[obj].amount

		if ItemPickUps[obj].weaponid == 1 then

			if UsersInventories[identifier] ~= nil then
				if svItems[name]:getLimit() ~= -1 then
				
					if UsersInventories[identifier][name] ~= nil then
						local sourceItemCount = UsersInventories[identifier][name]:getCount()
						local totalAmount = amount + sourceItemCount

						if svItems[name]:getLimit() < totalAmount then
							TriggerClientEvent(player, "vorp:TipRight", _U("fullInventory"), 2000)
							return
						end
					end
				end

				if Config.MaxItemsInInventory.Items ~= 0 then
					local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier)
					sourceInventoryItemCount = sourceInventoryItemCount + amount 

					if sourceInventoryItemCount > Config.MaxItemsInInventory.Items then
						TriggerClientEvent("vorp:TipRight", _source, _U(fullInventory), 2000)
						return
					end
				end

				InventoryService.addItem(_source, name, amount)

				TriggerClientEvent("vorpInventory:sharePickUpClient", _source, name, ItemPickUps[obj].obj, amount, ItemPickUps[obj].coords, 2, ItemPickUps[obj].weaponId)

				TriggerClientEvent("vorpInventory:removePickupClient", _source, ItemPickUps[obj].obj)

				TriggerClientEvent("vorpInventory:receiveItem", _source, name, amount)

				TriggerClientEvent("vorpInventory:playerAnim", _source, obj)

				ItemPickUps[obj] = nil
			end
		else
			if Config.MaxItemsInInventory.Weapons ~= 0 then
				local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId)
				sourceInventoryWeaponCount = sourceInventoryWeaponCount + 1

				if sourceInventoryWeaponCount <= Config.MaxItemsInInventory.Weapons then
					local weaponId = ItemPickUps[obj].weaponid
					local weaponObj = ItemPickUps[obj].obj
					InventoryService.addWeapon(_source, weaponId)

					TriggerEvent("syn_weapons:onpickup", weaponId)
					TriggerClientEvent("vorpInventory:sharePickupClient", _source, name, obj)
					TriggerClientEvent("vorpInventory:receiveWeapon", _source, weaponId, UsersWeapons[weaponId]:getPropietary(), UsersWeapons[weaponId]:getName(), UsersWeapons[weaponId]:getAllAmmo())
					TriggerClientEvent("vorpInventory:playerAnim", _source, obj)
					ItemPickUps[obj] = nil
				end
			end
		end
	end
end

InventoryService.onPickupMoney = function (obj) 
	local _source = source

	if MoneyPickUps[obj] ~= nil then
		local moneyObj = MoneyPickUps[obj].obj
		local moneyAmount = MoneyPickUps[obj].amount
		local moneyCoords = MoneyPickUps[obj].coords

		TriggerClientEvent("vorpInventory:shareMoneyPickupClient", _source, moneyObj, moneyAmount, moneyCoords, 2)
		TriggerClientEvent("vorpInventory:removePickupClient", _source, moneyObj)
		TriggerClientEvent("vorpInventory:playerAnim", _source, moneyObj)
		TriggerEvent("vorp:addMoney", _source, 0, moneyAmount)

		MoneyPickUps[obj] = nil
	end
end

InventoryService.sharePickupServer = function (name, obj, amount, position, weaponId) 
	local _source = source
	TriggerClientEvent("vorpInventory:sharePickupClient", _source, name, obj, amount, position, 1, weaponId)

	ItemPickUps[obj] = {
		name = name,
		obj = obj,
		amount = amount,
		weaponid = weaponId,
		inRange = false,
		coords = position
	}
end

InventoryService.shareMoneyPickupServer = function (obj, amount, position) 
	local _source = source
	TriggerClientEvent("vorpInventory:shareMoneyPickupClient", _source, obj, amount, position, 1)
	MoneyPickUps[obj] = {
		name = "Dollars",
		obj = obj,
		amount = amount,
		inRange = false,
		coords = position
	}
end


InventoryService.DropWeapon = function (weaponId) 
	local _source = source
	InventoryService.subWeapon(_source, weaponId)
	TriggerClientEvent("vorpInventory:createPickup", _source, UsersWeapons[weaponId]:getName(), 1, weaponId)
end

InventoryService.DropItem = function (itemName, amount)
	local _source = source 
	InventoryService.subItem(_source, itemName, amount)
	TriggerClientEvent("vorpInventory:createPickup", _source, itemName, amount, 1)
end

InventoryService.GiveWeapon = function (weaponId, target) 
	local _source = source
	local _target = target

	if UsersWeapons[weaponId] ~= nil then
		InventoryService.subWeapon(_source, weaponId)
		InventoryService.addWeapon(_target, weaponId)

		local propietary = UsersWeapons[weaponId]:getPropietary()
		local name = UsersWeapons[weaponId]:getName()
		local allAmmo = UsersWeapons[weaponId]:getAllAmmo()

		TriggerClientEvent("vorpInventory:receiveWeapon", _target, weaponId, propietary, name, allAmmo)
	end
end

InventoryService.GiveItem = function (itemName, amount, target) 
	local give = true
	local _source = source
	local _target = target

	local sourceIdentifier = GetPlayerIdentifiers(_source)[1]
	local targetIdentifier = GetPlayerIdentifiers(_target)[1]

	if UsersInventories[sourceIdentifier] == nil or UsersInventories[targetIdentifier] == nil or UsersInventories[sourceIdentifier][itemName] == nil then
		TriggerClientEvent("vorp:TipRight", _source, _U('itemerror'), 2000)
		return
	end

	local sourceItemAmount = UsersInventories[sourceIdentifier][itemName]:getCount() 
	local targetItemAmount = UsersInventories[targetIdentifier][itemName]:getCount() 
	local targetItemLimit = UsersInventories[targetIdentifier][itemName]:getLimit() 
	local targetInventoryItemCount = InventoryAPI.getUserTotalCount(targetIdentifier)
	
	if sourceItemAmount < amount then
		TriggerClientEvent("vorp:TipRight", _source, _U("itemerror"), 2000)
		TriggerClientEvent("vorp:TipRight", _target, _U("itemerror"), 2000)
		return
	end

	if targetItemAmount + amount > targetItemLimit or targetInventoryItemCount + amount > Config.MaxItemsInInventory.Items then
		TriggerClientEvent("vorp:TipRight", _source, _U('fullinventory'), 2000)
		TriggerClientEvent("vorp:TipRight", _target, _U('fullinventory'), 2000)
		return
	end

	InventoryService.addItem(_target, itemName, amount)
	InventoryService.subItem(_source, itemName, amount)

	TriggerClientEvent("vorpInventory:receiveItem", _target, itemName, amount)
	TriggerClientEvent("vorpInventory:receiveItem2", _source, itemName, amount)

	TriggerClientEvent("vorp:TipRight", _source, _U("yougaveitem"), 2000)
	TriggerClientEvent("vorp:TipRight", _target, _U("youreceiveditem"), 2000)
end

InventoryService.getItemsTable = function () 
	local _source = source

	if DB_Items ~= nil then
		TriggerClientEvent("vorpInventory:giveItemsTable", _source, DB_Items)
	end
end

InventoryService.getInventory = function () 
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	local sourceInventory = json.decode(sourceCharacter.inventory)

	local characterInventory = {}
	local characterWeapons = {}

	if sourceInventory ~= nil then
		for _, item in pairs(DB_Items) do -- TODO reverse loop: Iterate on inventory item instead of DB_items. Should save some iterations

			if sourceInventory[item.item] ~= nil then
				local newItem = Item:New({
					count = tonumber(sourceInventory[item.item]),
					limit = item.limit,
					label = item.label,
					name = item.item,
					type = item.type,
					canUse = item.usable,
					canRemove = item.can_remove,
				})
				characterInventory[item.item] = newItem
			end
		end
	end
	UsersInventories[sourceIdentifier] = characterInventory
	
	TriggerClientEvent("vorpInventory:giveInventory", _source, json.encode(sourceInventory))

	exports.ghmattimysql:execute('SELECT * FROM loadout WHERE identifier = @identifier AND charidentifier = @charid', { 
			['identifier'] = sourceIdentifier,
			['charid'] = sourceCharId,
		}, 
	function(result)
		if result ~= nil then
			for _, weapon in pairs(result) do
				local db_Ammo = json.decode(weapon.ammo)
				local weaponAmmo = {}
				local used = false
				local used2 = false

				for _, ammo in pairs(db_Ammo) do
					weaponAmmo[_] = ammo
				end

				if weapon.used == 1 then used = true end
				if weapon.used2 == 1 then used2 = true end

				local newWeapon = Weapon:New({
					id = weapon.id,
					propietary = weapon.identifier,
					name = weapon.name,
					ammo = weaponAmmo,
					used = used,
					used2 = used2,
					charId = sourceCharId,
				})
				UsersWeapons[newWeapon:getId()] = newWeapon
			end
			TriggerClientEvent("vorpInventory:giveLoadout", _source, result)
		end
	end)
end