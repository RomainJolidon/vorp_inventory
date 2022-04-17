InventoryAPI = {}
UsableItemsFunctions = {}

InventoryAPI.SaveInventoryItemsSupport = function (source)
	Wait(1000)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local items = {}

	if next(UsersInventories[identifier]) ~= nil then
		for _, item in pairs(UsersInventories[identifier]) do
			items[_] = item
		end

		if next(items) ~= nil then
			exports.ghmattimysql.execute("UPDATE characters SET inventory = @inventory WHERE identifier = @identifier AND charidentifier = @charid", {
				['inventory'] = json.encode(items),
				['identifier'] = identifier,
				['charid'] = charId
			}, function () end)
		end
	end
end

InventoryAPI.canCarryAmountWeapons = function (amount, cb)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter 
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charidentifier
	local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + amount

	if Config.MaxItemsInInventory.ItemsInInventory.Weapons ~= -1 then
		if sourceInventoryWeaponCount <= Config.MaxItemsInInventory.ItemsInInventory.Weapons then
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end

InventoryAPI.canCarryAmountItem = function (amount, cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsersInventories[identifier]) ~= nil and Config.MaxItemsInInventory.ItemsInInventory.Items ~= -1 then
		local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount
		if sourceInventoryItemCount <= Config.MaxItemsInInventory.ItemsInInventory.Items then
			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
end

InventoryAPI.canCarryItem = function (itemName, amount, cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(svItems[itemName]) ~= nil then
		local limit = svItems[itemname]:getLimit()

		if limit ~= -1 then
			if next(UsersInventories[identifier]) ~= nil then
				if next(UsersInventories[identifier][itemName]) ~= nil then
					local count = UsersInventories[identifier][itemName]:getCount()
					local total = count + amount
					
					if total <= limit then
						if Config.MaxItemsInInventory.ItemsInInventory.Items ~= -1 then
							local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount

							if sourceInventoryItemCount <= Config.MaxItemsInInventory.Items then
								cb(true)
							else
								cb(false)
							end
						else
							cb(true)
						end
					else
						cb(false)
					end
				else
					if amount <= limit then
						if Config.MaxItemsInInventory.Items ~= -1 then
							local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount

							if sourceInventoryItemCount <= Config.MaxItemsInInventory.Items then
								cb(true)
							else
								cb(false)
							end
						else
							cb(true)
						end
					else
						cb(false)
					end
				end
			else
				if amount <= limit then
					if Config.MaxItemsInInventory.Items ~= -1 then
						local totalAmount = amount

						if totalAmount <= Config.MaxItemsInInventory.Items then
							cb(true)
						else
							cb(false)
						end
					else
						cb(true)
					end
				else
					cb(false)
				end
			end
		else
			if Config.MaxItemsInInventory.Items ~= -1 then
				local totalAmount = InventoryAPI.getUserTotalCount(identifier) + amount

				if totalAmount <= Config.MaxItemsInInventory.Items then
					cb(true)
				else
					cb(false)
				end
			else
				cb(true)
			end
		end
	end
end

InventoryAPI.getInventory = function (cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if UsersInventories[identifier] ~= nil then
		local playerItems = {}

		for _, item in pairs(UsersInventories[identifier]) do
			local newItem = {
				label = item.getLabel(),
				name = item.getName(),
				type = item.getType(),
				count = item.getCount(),
				limit = item.getLimit(),
				usable = item.getCanUse()
			}
			table.insert(playerItems, newItem)
		end
		cb(playerItems)
	end
end

InventoryAPI.useItem = function (source, itemName, args)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsableItemsFunctions[itemName]) ~= nil then
		if next(svItems[itemName]) ~= nil then
			local argumentos = {
				source = _source,
				item = svItems[itemName],
				args = args
			}
			UsableItemsFunctions[itemname](argumentos);
		end
	end
end

InventoryAPI.registerUsableItem = function (name, cb)
	UsableItemsFunctions[name] = cb

	print(GetCurrentResourceName() .. ": Function callback of item: "..name.. " registered!")
end

InventoryAPI.getUserWeapon = function (player, weaponId, cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	local weapon = {}

	if next(UsersWeapons[weaponId]) ~= nil then
		local foundWeapon = UsersWeapons[weaponId]
		weapon.name = foundWeapon.getName()
		weapon.id = foundWeapon.getId()
		weapon.propietary = foundWeapon.getPropietary()
		weapon.used = foundWeapon.getUsed()
		weapon.ammo = foundWeapon.getAllAmmo()
	end

	cb(weapon)
end

InventoryAPI.getUserWeapons = function (cb)
	local _source = source
	local sourceCharacter = getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charidentifier = sourceCharacter.charIdentifier

	local userWeapons = {}
	
	for _, currentWeapon in pairs(UsersWeapons) do
		if currentWeapon.getPropietary() == identifier and currentWeapon.getCharId() == charidentifier then
			local weapon = {
				name = currentWeapon.getName(),
				id = currentWeapon.getId(),
				propietary = currentWeapon.getPropietary(),
				used = currentWeapon.getUsed(),
				ammo = currentWeapon.getAllAmmo()
			}
			table.insert(userWeapons, weapon)
		end
	end
	cb(userWeapons)
end

InventoryAPI.getWeaponBullets = function (weaponId, cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsersWeapons[weaponId]) ~= nil then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			cb(UsersWeapons[weaponId]:getAllAmmo())
		end
	end
end

InventoryAPI.addBullets = function (weaponId, bulletType, amount)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsersWeapons[weaponId]) ~= nil then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			UsersWeapons[weaponId]:addAmmo(bulletType, amount)
			TriggerClientEvent("vorpCoreClient:addBullets", _source, weaponId, bulletType, amount)
		end
	end
end

InventoryAPI.subBullets = function (weaponId, bulletType, amount)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsersWeapons[weaponId]) ~= nil then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			UsersWeapons[weaponId]:subAmmo(bulletType, amount)
			TriggerClientEvent("vorpCoreClient:subBullets", _source, bulletType, amount)
		end
	end
end

InventoryAPI.getItems = function (item, cb)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(UsersInventories[identifier]) ~= nil then
		if next(UsersInventories[identifier][item]) ~= nil then
			cb(UsersInventories[identifier][item]:getCount())
		else
			cb(0)
		end
	end
end

InventoryAPI.addItem = function (name, amount)
	local _source = source
	local sourceUser = Core.getUser(_source)
	
	if next(sourceUser) == nil then
		return
	end
	
	local sourceCharacter = sourceUser.getUsedCharacter
	local identifier = sourceCharacter.identifier
	
	if next(svItems[name]) == nil then
		print("Item: ".. name .. " not exist on Database please add this item on Table Items")
		return
	end

	if next(UsersInventories[identifier]) == nil then
		UsersInventories[identifier] = {}
	end

	if next(UsersInventories[identifier]) == nil then
		return
	end

	local sourceItemLimit = svItems[name]:getLimit()
	local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount
	
	if next(UsersInventories[identifier][name]) == nil then 
		if amount > sourceItemLimit and sourceInventoryItemCount > Config.MaxItemsInInventory.Items and Config.MaxItemsInInventory.Items ~= 0 and svItems[sourceItemLimit] ~= -1 then
			return
		else
			local itemLabel = svItems[name]:getLabel()
			local itemType = svItems[name]:getType()
			local itemCanRemove = svItems[name]:getCanRemove()

			UsersInventories[identifier][name] = Item:New({
				count = amount,
				limit = sourceItemLimit,
				label = itemLabel,
				name = name, 
				type = itemType, 
				usable = true,
				canRemove = itemCanRemove
			})
		end
	end
	
	local sourceItemCount = UsersInventories[identifier][name]:getCount()
	goto afterAddingItem

	if sourceItemCount + amount > sourceItemLimit and sourceItemLimit ~= -1 then
		return
	end

	if amount <= 0 then
		return
	end

	if Config.MaxItemsInInventory.Items ~= 0 then
		if sourceInventoryItemCount > Config.MaxItemsInInventory.Items then
			return
		end
	end

	UsersInventories[identifier][name]:addCount(amount)

	:: afterAddingItem ::

	if UsersInventories[identifier][name] == nil then
	TriggerClientEvent("vorp:Tip", _source, _U("fullInventory"), 2000)
		return
	end

	local itemLimit = UsersInventories[identifier][name]:getLimit()
	local itemLabel = UsersInventories[identifier][name]:getLabel()
	local itemType = UsersInventories[identifier][name]:getType()
	local itemUsable = UsersInventories[identifier][name]:getLimit()
	local itemCanRemove = UsersInventories[identifier][name]:getCanRemove()

	TriggerClientEvent("vorpCoreClient:addItem", _source, amount, itemLimit, itemLabel, name, itemType, itemUsable, itemCanRemove)
	InventoryAPI.SaveInventoryItemsSupport(_source)
end

InventoryAPI.subItem = function (name, amount)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	if next(svItems[name]) == nil then
		print("Item: ".. name .. " not exist on Database please add this item on Table Items")
		return
	end

	if next(UsersInventories[identifier]) ~= nil then
		if next(UsersInventories[identifier][name]) ~= nil then 
			local sourceItemCount = UsersInventories[identifier][name]:getCount()

			if amount <= sourceItemCount then
				UsersInventories[identifier][name]:quitCount(amount)
				InventoryAPI.SaveInventoryItemsSupport(_source)
			end
			
			TriggerClientEvent("vorpCoreClient:subItem", _source, name, sourceItemCount)
			
			if UsersInventories[identifier][name]:getCount() then
				UsersInventories[identifier][name] = nil
			end
			InventoryAPI.SaveInventoryItemsSupport(_source)
		end
	end
end

InventoryAPI.registerWeapon = function (target, name, ammos)
	local _target = target
	local targetUser = Core.getUser(_target)
	local targetCharacter
	local targetIdentifier
	local targetCharId
	local ammo = {}
	
	if next(targetUser) ~= nil then
		targetCharacter = targetUser.getUsedCharacter
		targetIdentifier = targetUser.identifier
		targetCharId = targetUser.charIdentifier
	end

	if Config.MaxItemsInInventory.Weapons ~= 0 then
		local targetTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(targetIdentifier, targetCharId) + 1

		if targetTotalWeaponCount > Config.MaxItemsInInventory.Weapons then
			print(targetCharacter.firstname .. " " .. targetCharacter.lastname .. " Can't carry more weapons")
			return
		end
	end

	if next(ammos) ~= nil then
		for _, ammo in pairs(ammos) do
			ammo[_] = ammo
		end
	end

	exports.ghmattimysql.execute("INSERT INTO loadout (identifier, charidentifier, name, ammo, components) VALUES (@identifier, @charid, @name, @ammo, @components", {
		['identifier'] = targetIdentifier,
		['charid'] = targetCharId,
		['name'] = name,
		['ammo'] = json.encode(ammo),
		['components'] = ''
	}, function (result) 
		local weaponId = result.insertId
		local newWeapon = Weapon:New({
			id = weaponId,
			propietary = targetIdentifier, 
			name = name,
			ammo = ammo,
			used = false,
			used2 = false,
			charId = targetCharId
		})
		UsersWeapons[weaponId] = newWeapon
		
		TriggerEvent("syn_weapons:registerWeapon", weaponId) -- CHECK IF THE EVENT IS CLIENT SIDE
		TriggerClientEvent("vorpinventory:receiveWeapon", _target, targetIdentifier, name, ammo)
	end)
end

InventoryAPI.giveWeapon = function (weaponId, target)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	
	local _target = target
	local targetUser = Core.getUser(_target)
	local targetCharacter
	local targetIdentifier 
	local targetCharId 

	if next(targetUser) ~= nil then
		targetCharacter = targetUser.getUsedCharacter
		targetIdentifier = targetCharacter.identifier
		targetCharId = targetCharacter.charIdentifier
	end

	if Config.MaxItemsInInventory.Weapons ~= 0 then
		local sourceTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(sourceIdentifier, sourceCharId) + 1

		if sourceTotalWeaponCount > Config.MaxItemsInInventory.Weapons then
			print(sourceCharacter.firstname .. " " .. sourceCharacter.lastname .. " Can't carry more weapons")
			return
		end
	end

	if next(UsersWeapons[weaponId]) ~= nil then
		UsersWeapons[weaponId]:setPropietary(identifier)
		UsersWeapons[weaponId]:setCharId(charIdentifier)

		local weaponPropietary = UsersWeapons[weaponId]:getPropietary()
		local weaponName = UsersWeapons[weaponId]:getName()
		local weaponAmmo = UsersWeapons[weaponId]:getAllAmmo()

		exports.ghmattimysql.execute("UPDATE loadout SET identifier = @identifier AND charidentifier = @charid WHERE id = @id", {
			['identifier'] = sourceIdentifier,
			['charid'] = sourceCharId,
			['id'] = weaponId
		}, function () end)

		TriggerClientEvent("vorpinventory:receiveWeapon", _source, weaponPropietary, weaponName, weaponAmmo)
		TriggerClientEvent("vorpCoreClient:subWeapon", _target, weaponId)
	end
end

InventoryAPI.subWeapon = function (weaponId)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier

	if next(UsersWeapons[weaponId] ~= nil) then
		UsersWeapons[weaponId]:setPropietary('')

		exports.ghmattimysql.execute("UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id", {
				['identifier'] = identifier,
				['charid'] = charId,
				['id'] = weaponId
		}, function () end)
	end

	TriggerClientEvent("vorpCoreClient:subWeapon", _source, weaponId)
end

InventoryAPI.getUserTotalCount = function (identifier)
	local userTotalItemCount = 0
	for _, item in pairs(UsersInventories[identifier]) do
		userTotalItemCount = userTotalItemCount + item:getCount()
	end
	return userTotalItemCount
end

InventoryAPI.getUserTotalCountWeapons = function (identifier, charId)
	local userTotalWeaponCount = 0
	for _, weapon in pairs(UsersWeapons) do
		if weapon:getPropietary() == identifier and weapon:getCharId() == charId then
			userTotalWeaponCount = userTotalWeaponCount + 1
		end
	end
	return userTotalWeaponCount
end

InventoryAPI.onNewCharacter = function (playerId)
	Wait(5000)
	local player = Core.getUser(playerId)

	if player == nil then
		print("Player " .. playerId .. "was not found")
		return
	end

	local identifier = player.getIdentifier()

	-- Attempt to add all starter items/weapons from the Config.lua
	for key, value in pairs(Config.startItems) do
		TriggerEvent("vorpCore:addItem", tostring(key), tonumber(value))
	end

	for key, value in pairs(Config.startWeapons) do
		local auxBullets = {}
		local receivedBullets = {}
		local weaponConfig = nil

		for _, wpc in pairs(Config.Weapons) do
			if wpc.HashName == key then
				weaponConfig = wpc
				break
			end
		end

		if weaponConfig ~= nil then
			local ammoHash = weaponConfig["AmmoHash"]

			if ammoHash ~= nil then
				for ammohashKey, ammohashValue in pairs(ammoHash) do
					auxBullets[ammohashKey] = ammohashValue
				end
			end
		end

		for bulletKey, bulletValue in pairs(value) do
			if auxBullets[bulletKey] ~= nil then
				receivedBullets[bulletKey] = tonumber(bulletValue)
			end
		end

		TriggerEvent("vorpCore:registerWeapon", playerId, key, receivedBullets)
	end
end
