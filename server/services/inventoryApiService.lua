InventoryAPI = {}
UsableItemsFunctions = {}

InventoryAPI.SaveInventoryItemsSupport = function(player)
	Wait(1000)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local items = {}

	if (UsersInventories[identifier]) then
		for _, item in pairs(UsersInventories[identifier]) do
			table.insert(items, {name= item:getName(), amount= item:getCount(), metadata= item:getMetadata()})
			--items[_] = item:getCount()
		end


		if (items) then
			exports.ghmattimysql:execute("UPDATE characters SET inventory = @inventory WHERE identifier = @identifier AND charidentifier = @charid"
				, {
					['inventory'] = json.encode(items),
					['identifier'] = identifier,
					['charid'] = charId
				}, function() end)
		end
	end
end

InventoryAPI.canCarryAmountWeapons = function(player, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier

	local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + amount

	if Config.MaxItemsInInventory.Weapons ~= -1 then
		if sourceInventoryWeaponCount <= Config.MaxItemsInInventory.Weapons then
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end

InventoryAPI.canCarryAmountItem = function(player, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersInventories[identifier] ~= nil and Config.MaxItemsInInventory.Items ~= -1 then
		local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount
		if sourceInventoryItemCount <= Config.MaxItemsInInventory.Items then
			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
end

InventoryAPI.canCarryItem = function(player, itemName, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if svItems[itemName] then
		local limit = svItems[itemName]:getLimit()

		if limit ~= -1 then
			if UsersInventories[identifier] ~= nil then
				if UsersInventories[identifier][itemName] ~= nil then
					local count = UsersInventories[identifier][itemName]:GetCount()
					local total = count + amount

					if total <= limit then
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

InventoryAPI.getInventory = function(player, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersInventories[identifier] then
		local playerItems = {}

		for _, itemGroup in pairs(UsersInventories[identifier]) do
			for _, item in pairs(itemGroup.items) do
				local newItem = {
					label = item:getLabel(),
					name = item:getName(),
					metadata = item:getMetadata(),
					type = item:getType(),
					count = item:getCount(),
					limit = item:getLimit(),
					usable = item:getCanUse(),
					desc = item:getDesc()
				}
				table.insert(playerItems, newItem)
			end
		end
		cb(playerItems)
	end
end

InventoryAPI.useItem = function(itemName, args)
	local _source = source
	if UsableItemsFunctions[itemName] then
		if svItems[itemName] then
			local arguments = {
				source = _source,
				item = svItems[itemName],
				args = args
			}
			UsableItemsFunctions[itemName](arguments)
		end
	end
end

InventoryAPI.registerUsableItem = function(name, cb)
	UsableItemsFunctions[name] = cb
	if Config.Debug then
		Wait(9000) -- so it doesn't print everywhere in the console
		Log.print("Callback for item[^3" .. name .. "^7] ^2Registered!^7")
	end
end

InventoryAPI.getUserWeapon = function(player, cb, weaponId)
	local weapon = {}

	if (UsersWeapons[weaponId]) then
		local foundWeapon = UsersWeapons[weaponId]
		weapon.name = foundWeapon:getName()
		weapon.id = foundWeapon:getId()
		weapon.propietary = foundWeapon:getPropietary()
		weapon.used = foundWeapon:getUsed()
		weapon.ammo = foundWeapon:getAllAmmo()
		weapon.desc = foundWeapon:getDesc()
	end

	cb(weapon)
end

InventoryAPI.getUserWeapons = function(player, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charidentifier = sourceCharacter.charIdentifier

	local userWeapons = {}

	for _, currentWeapon in pairs(UsersWeapons) do
		if currentWeapon:getPropietary() == identifier and currentWeapon:getCharId() == charidentifier then
			local weapon = {
				name = currentWeapon:getName(),
				id = currentWeapon:getId(),
				propietary = currentWeapon:getPropietary(),
				used = currentWeapon:getUsed(),
				ammo = currentWeapon:getAllAmmo(),
				desc = currentWeapon:getDesc()
			}
			table.insert(userWeapons, weapon)
		end
	end
	cb(userWeapons)
end

InventoryAPI.getWeaponBullets = function(player, cb, weaponId)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if (UsersWeapons[weaponId]) then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			cb(UsersWeapons[weaponId]:getAllAmmo())
		end
	end
end

InventoryAPI.addBullets = function(player, weaponId, bulletType, amount)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersWeapons[weaponId] then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			UsersWeapons[weaponId]:addAmmo(bulletType, amount)
			TriggerClientEvent("vorpCoreClient:addBullets", _source, weaponId, bulletType, amount)
		end
	end
end

InventoryAPI.subBullets = function(weaponId, bulletType, amount)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if (UsersWeapons[weaponId]) then
		if UsersWeapons[weaponId]:getPropietary() == identifier then
			UsersWeapons[weaponId]:subAmmo(bulletType, amount)
			TriggerClientEvent("vorpCoreClient:subBullets", _source, bulletType, amount)
		end
	end
end

InventoryAPI.getItems = function(player, cb, item)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if UsersInventories[identifier] ~= nil then
		if UsersInventories[identifier][item] ~= nil then
			cb(UsersInventories[identifier][item]:GetCount())
		else
			cb(0)
		end
	end
end

InventoryAPI.getItem = function(player, item, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if (UsersInventories[identifier]) then
		if (UsersInventories[identifier][item]) then
			cb(UsersInventories[identifier][item])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end

InventoryAPI.addItem = function(player, name, amount, metadata)
	local _source = player
	local sourceUser = Core.getUser(_source)
	local added = false

	if (sourceUser) == nil then
		return
	end

	metadata = metadata or {}

	local sourceCharacter = sourceUser.getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charIdentifier = sourceCharacter.charIdentifier

	if svItems[name] == nil then
		if Config.Debug then
			Log.Warning("Item: [^2" .. name .. "^7] ^1 do not exist on Database please add this item on ^7 Table Items")
		end
		return
	end

	if UsersInventories[identifier] == nil then
		UsersInventories[identifier] = {}
	end

	if UsersInventories[identifier] == nil then
		return
	end

	if amount <= 0 then
		return
	end

	local sourceItemLimit = svItems[name]:getLimit()
	local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier) + amount

	local itemLabel = svItems[name]:getLabel()
	local itemType = svItems[name]:getType()
	local itemCanRemove = svItems[name]:getCanRemove()

	if UsersInventories[identifier][name] ~= nil then
		
		if UsersInventories[identifier][name]:GetCount() + amount <= sourceItemLimit or sourceItemLimit == -1 then
			local item = UsersInventories[identifier][name]:FindByMetadata(metadata)
			if item == nil then
				local dbCraftedItem = DbService.CreateItem(charIdentifier, svItems[name]:getId(), amount, metadata)
				item = Item:New({
					id = dbCraftedItem.id,
					count = amount,
					limit = sourceItemLimit,
					label = itemLabel,
					metadata = metadata,
					name = name,
					type = itemType,
					usable = true,
					canRemove = itemCanRemove
				})
				UsersInventories[identifier][name]:Add(item)
			else
				if Config.MaxItemsInInventory.Items ~= -1 then
					if sourceInventoryItemCount <= Config.MaxItemsInInventory.Items then
						item:addCount(amount)
						DbService.SetItemAmount(charIdentifier, item:getId(), item:getCount())
						added = true
					end
				else
					item:addCount(amount)
					DbService.SetItemAmount(charIdentifier, item:getId(), item:getCount())
					added = true
				end
			end
		end
	else
		UsersInventories[identifier][name] = ItemGroup:New(name)

		if amount <= sourceItemLimit or sourceItemLimit == -1 then
			local itemLabel = svItems[name]:getLabel()
			local itemType = svItems[name]:getType()
			local itemCanRemove = svItems[name]:getCanRemove()
			local itemDesc = svItems[name]:getDesc()

			if Config.MaxItemsInInventory.Items ~= -1 then
				if sourceInventoryItemCount <= Config.MaxItemsInInventory.Items then
					local dbCraftedItem = DbService.CreateItem(charIdentifier, svItems[name]:getId(), amount, metadata)
					UsersInventories[identifier][name]:Add(Item:New({
						id = dbCraftedItem.id,
						count = amount,
						limit = sourceItemLimit,
						label = itemLabel,
						metadata = metadata,
						name = name,
						type = itemType,
						usable = true,
						canRemove = itemCanRemove,
						desc = itemDesc
					}))
					added = true
				end
			else
				local dbCraftedItem = DbService.CreateItem(charIdentifier, svItems[name]:getId(), amount, metadata)
				UsersInventories[identifier][name]:Add(Item:New({
					id = dbCraftedItem.id,
					count = amount,
					limit = sourceItemLimit,
					label = itemLabel,
					metadata = metadata,
					name = name,
					type = itemType,
					usable = true,
					canRemove = itemCanRemove,
					desc = itemDesc
				}))
				added = true
			end
		end
	end

	if UsersInventories[identifier][name] ~= nil and added then
		local item = UsersInventories[identifier][name]:FindByMetadata(metadata)

		local itemLimit = item:getLimit()
		local itemLabel = item:getLabel()
		local itemType = item:getType()
		local itemUsable = item:getLimit()
		local itemCanRemove = item:getCanRemove()
		local itemMetadata = item:getMetadata()
		local itemDesc = UsersInventories[identifier][name]:getDesc()

		TriggerClientEvent("vorpCoreClient:addItem", _source, amount, itemLimit, itemLabel, name, itemType, itemUsable, itemCanRemove, itemMetadata)
		--InventoryAPI.SaveInventoryItemsSupport(_source)
	else
		TriggerClientEvent("vorp:Tip", _source, _U("fullInventory"), 2000)
	end
end

InventoryAPI.subItem = function(player, name, amount, metadata)
	local _source = player
	local sourceUser = Core.getUser(_source)
	metadata = metadata or {}

	if (sourceUser) == nil then
		return
	end


	local sourceCharacter = sourceUser.getUsedCharacter
	local identifier = sourceCharacter.identifier

	if svItems[name] == nil then
		if Config.Debug then
			Log.Warning("Item: [^2" .. name .. "^7] ^1 do not exist on Database please add this item on ^7 Table Items")
		end
		return
	end

	if UsersInventories[identifier] ~= nil then
		if UsersInventories[identifier][name] ~= nil then
			local item = UsersInventories[identifier][name]:FindByMetadata(metadata)
			if item ~= nil then
				local sourceItemCount = item:getCount()

				if amount <= sourceItemCount then
					item:quitCount(amount)
				else
					return
				end

				TriggerClientEvent("vorpCoreClient:subItem", _source, name, item:getCount(), metadata)

				if item:getCount() == 0 then
					UsersInventories[identifier][name]:Sub(item)
				end
				InventoryAPI.SaveInventoryItemsSupport(_source)
			end
		end
	end
end

InventoryAPI.registerWeapon = function(target, name, ammos, components)
	local _target = target
	local targetUser = Core.getUser(_target)
	local targetCharacter
	local targetIdentifier
	local targetCharId
	local ammo = {}
	local component = {}

	local canGive = false

	for index, weapons in pairs(Config.Weapons) do
		if weapons.HashName == name then
			canGive = true
			break
		end

	end


	if targetUser then
		targetCharacter = targetUser.getUsedCharacter
		targetIdentifier = targetCharacter.identifier
		targetCharId = targetCharacter.charIdentifier
	end

	if Config.MaxItemsInInventory.Weapons ~= 0 then
		local targetTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(targetIdentifier, targetCharId) + 1

		if targetTotalWeaponCount > Config.MaxItemsInInventory.Weapons then
			TriggerClientEvent("vorp:TipRight", _target, "Can't carry more weapons", 2000)
			if Config.Debug then
				Log.Warning(targetCharacter.firstname .. " " .. targetCharacter.lastname .. " ^1Can't carry more weapons^7")
			end
			return
		end
	end

	if ammos then
		for _, value in pairs(ammos) do
			ammo[_] = value
		end
	end

	if components then
		for key, value in pairs(components) do
			component[#component + 1] = key
		end
	end
	if canGive then
		exports.ghmattimysql:execute("INSERT INTO loadout (identifier, charidentifier, name, ammo, components) VALUES (@identifier, @charid, @name, @ammo, @components)"
			, {
				['identifier'] = targetIdentifier,
				['charid'] = targetCharId,
				['name'] = name,
				['ammo'] = json.encode(ammo),
				['components'] = json.encode(component)
			}, function(result)
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

			TriggerEvent("syn_weapons:registerWeapon", weaponId)
			TriggerClientEvent("vorpInventory:receiveWeapon", _target, weaponId, targetIdentifier, name, ammo)
		end)
	else
		Log.Warning("Weapon: [^2" .. name .. "^7] ^1 do not exist on the config or its a WRONG HASH")
	end
end

InventoryAPI.giveWeapon = function(player, weaponId, target)
	print(weaponId)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	local _target = tonumber(target)
	local targetisPlayer = false

	for _, pl in pairs(GetPlayers()) do
		if tonumber(pl) == _target then
			targetisPlayer = true
			break
		end
	end

	if Config.MaxItemsInInventory.Weapons ~= 0 then
		local sourceTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(sourceIdentifier, sourceCharId) + 1

		if sourceTotalWeaponCount > Config.MaxItemsInInventory.Weapons then

			TriggerClientEvent("vorp:TipRight", _source, "Can't carry more weapons", 2000)
			if Config.Debug then
				Log.print(sourceCharacter.firstname .. " " .. sourceCharacter.lastname .. " ^1Can't carry more weapons^7")
			end
			return
		end
	end

	if UsersWeapons[weaponId] then
		UsersWeapons[weaponId]:setPropietary(sourceIdentifier)
		UsersWeapons[weaponId]:setCharId(sourceCharId)

		local weaponPropietary = UsersWeapons[weaponId]:getPropietary()
		local weaponName = UsersWeapons[weaponId]:getName()
		local weaponAmmo = UsersWeapons[weaponId]:getAllAmmo()

		exports.ghmattimysql:execute("UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id",
			{
				['identifier'] = sourceIdentifier,
				['charid'] = sourceCharId,
				['id'] = weaponId
			}, function() end)

		if targetisPlayer then
			--TriggerClientEvent("vorp:TipRight", _target, _U("youGaveWeapon"), 2000)
			TriggerClientEvent('vorp:ShowAdvancedRightNotification', _target, _U("youGaveWeapon"), "inventory_items", weaponName,
				"COLOR_PURE_WHITE",4000)
			TriggerClientEvent("vorpCoreClient:subWeapon", _target, weaponId)
		end

		--TriggerClientEvent("vorp:TipRight", _source, _U("youReceivedWeapon"), 2000)
		TriggerClientEvent('vorp:ShowAdvancedRightNotification', _source, _U("youReceivedWeapon"), "inventory_items",
			weaponName,"COLOR_PURE_WHITE", 4000)
		TriggerClientEvent("vorpInventory:receiveWeapon", _source, weaponId, weaponPropietary, weaponName, weaponAmmo)
	end
end

InventoryAPI.subWeapon = function(player, weaponId)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier

	if (UsersWeapons[weaponId]) then
		UsersWeapons[weaponId]:setPropietary('')

		exports.ghmattimysql:execute("UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id",
			{
				['identifier'] = '',
				['charid'] = charId,
				['id'] = weaponId
			}, function() end)
	end

	TriggerClientEvent("vorpCoreClient:subWeapon", _source, weaponId)
end

InventoryAPI.getUserTotalCount = function(identifier)
	local userTotalItemCount = 0
	for _, itemGroup in pairs(UsersInventories[identifier]) do
		userTotalItemCount = userTotalItemCount + itemGroup:GetCount()
	end
	return userTotalItemCount
end

InventoryAPI.getUserTotalCountWeapons = function(identifier, charId)
	local userTotalWeaponCount = 0
	for _, weapon in pairs(UsersWeapons) do
		if weapon:getPropietary() == identifier and weapon:getCharId() == charId then
			userTotalWeaponCount = userTotalWeaponCount + 1
		end
	end
	return userTotalWeaponCount
end

InventoryAPI.onNewCharacter = function(playerId)
	Wait(5000)
	local player = Core.getUser(playerId)

	if player == nil then
		if Config.Debug then
			Log.print("Player [^2" .. playerId .. "^7] ^1 was not found^7")
		end
		return
	end

	--local identifier = player.getIdentifier()

	-- Attempt to add all starter items/weapons from the Config.lua
	for key, value in pairs(Config.startItems) do

		TriggerEvent("vorpCore:addItem", playerId, tostring(key), tonumber(value), {})
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

		if weaponConfig then
			local ammoHash = weaponConfig["AmmoHash"]

			if ammoHash then
				for ammohashKey, ammohashValue in pairs(ammoHash) do
					auxBullets[ammohashKey] = ammohashValue
				end
			end
		end

		for bulletKey, bulletValue in pairs(value) do
			if auxBullets[bulletKey] then
				receivedBullets[bulletKey] = tonumber(bulletValue)
			end
		end

		TriggerEvent("vorpCore:registerWeapon", playerId, key, receivedBullets)
	end
end
