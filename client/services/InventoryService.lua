DB_Items = {}
InventoryService = {}
UserWeapons = {}
---@class UserInventory: table<string, Item>
UserInventory = {}
bulletsHash = {}

InventoryService.receiveItem = function (name, id, amount, metadata)

	if UserInventory[id] ~= nil then
		UserInventory[id]:addCount(amount)
	else
		UserInventory[id] = Item:New({
			id = id,
			count = amount,
			limit = DB_Items[name].limit,
			label = DB_Items[name].label,
			name = name,
			metadata = SharedUtils.MergeTables(DB_Items[name].metadata, metadata),
			type = "item_standard",
			canUse = true,
			canRemove = DB_Items[name].can_remove
		})
	end
	
	UserInventory[name] = Item:New({
		count = amount,
		limit = DB_Items[name].limit,
	        label = DB_Items[name].label,
		name = name,
		type = "item_standard",
		canUse = true,
		canRemove = DB_Items[name].can_remove,
		desc = DB_Items[name].desc
	})
	NUIService.LoadInv()
end

InventoryService.removeItem = function (name, id, count, metadata)
	if UserInventory[id] == nil then
		return
	end

	local item = UserInventory[id]

	if item ~= nil then
		item:quitCount(count)

		if item:getCount() <= 0 then
			UserInventory[id] = nil
		end

		NUIService.LoadInv()
	end
end

InventoryService.receiveWeapon = function (id, propietary, name, ammos)
	local weaponAmmo = {}

	for type, amount in pairs(ammos) do
		weaponAmmo[type] = tonumber(amount)
	end


	if UserWeapons[id] == nil then
		local newWeapon = Weapon:New({
			id = id,
			propietary = propietary,
			name = name,
			label = Utils.GetWeaponLabel(name),
			ammo = weaponAmmo,
			used = false,
			used2 = false,
			desc = Utils.GetWeaponDesc(name)
		})

		UserWeapons[newWeapon:getId()] = newWeapon
		NUIService.LoadInv()
	end

end

InventoryService.onSelectedCharacter = function (charId)
	SetNuiFocus(false, false)
	SendNUIMessage({action= "hide"})
	print("Loading Inventory")
	TriggerServerEvent("vorpinventory:getItemsTable")
	Wait(300)
	TriggerServerEvent("vorpinventory:getInventory")
end

InventoryService.processItems = function (items)
	DB_Items = {}
	for _, item in pairs(items) do
		DB_Items[item.item] = {
			item = item.item,
			label = item.label,
			limit = item.limit,
			can_remove = item.can_remove,
			type = item.type,
			usable = item.usable,
			desc = item.desc,
			metadata = item.metadata
		}
	end
end

InventoryService.getLoadout = function (loadout)
	for _, weapon in pairs(loadout) do
		local weaponAmmo = json.decode(weapon.ammo)

		for type, amount in pairs(weaponAmmo) do
			weaponAmmo[type] = tonumber(amount)
		end

		local weaponUsed = false
		local weaponUsed2 = false

		if weapon.used == 1 then weaponUsed = true end
		if weapon.used2 == 1 then weaponUsed2 = true end

		if weapon.dropped == nil or weapon.dropped == 0 then
			local newWeapon = Weapon:New({
				id = tonumber(weapon.id),
				identifier = weapon.identifier,
				label = Utils.GetWeaponLabel(weapon.name),
				name = weapon.name,
				ammo = weaponAmmo,
				used = weaponUsed,
				used2 = weaponUsed2,
				desc = Utils.GetWeaponDesc(weapon.name)
			})
	
			UserWeapons[newWeapon:getId()] = newWeapon
	
			if newWeapon:getUsed() then
				Utils.useWeapon(newWeapon:getId())
			end
		end
	end
end

InventoryService.getInventory = function (inventory)
	UserInventory = {}
	
	if inventory ~= '' then
		local inventoryItems = json.decode(inventory)

		for _, item in pairs(inventoryItems) do
			if DB_Items[item.item] ~= nil then
				local dbItem = DB_Items[item.item]
				local itemAmount = tonumber(item.amount)
				local itemLimit = tonumber(dbItem.limit)
				local itemCreatedAt = item.created_at
				local itemLabel = dbItem.label
				local itemCanRemove = dbItem.can_remove
				local itemType = dbItem.type
				local itemCanUse = dbItem.usable
				local itemDesc = dbItem.desc
				local itemDefaultMetadata = dbItem.metadata

				local newItem = Item:New({
					id = item.id,
					count = itemAmount,
					limit = itemLimit,
					label = itemLabel,
					name = item.item,
					metadata = SharedUtils.MergeTables(itemDefaultMetadata, item.metadata),
					type = itemType,
					canUse = itemCanUse,
					canRemove = itemCanRemove,
					desc = itemDesc
				})

				UserInventory[item.id] = newItem
			end
		end
	end
end


-- Threads
Citizen.CreateThread(function()
	while true do
		Wait(500)

		local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, PlayerPedId(), 4)
		
		if isArmed then
			for _, weapon in pairs(UserWeapons) do
				if weapon:getUsed() then
					local ammo = weapon:getAllAmmo()
					for ammoName, _ in pairs(ammo) do
						local ammoQty = Citizen.InvokeNative(0x39D22031557946C1, PlayerPedId(), GetHashKey(ammoName))
						weapon:setAmmo(ammoName, ammoQty)
					end
				end
			end
		end
	end
end)
