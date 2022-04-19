PickupsService = {}

local PickPrompt = nil
local WorldPickups = {}
local WorldMoneyPickups = {}

local dropAll = false
local lastCoords = {}


PickupsService.createPickup = function (name, amount, weaponId)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = GetHashKey("P_COTTONBOX01X")


	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)

		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	if not Citizen.InvokeNative(0x1283B8B89DD5D1B6, pickupModel) then
		Citizen.InvokeNative(0xFA28FE3A6246FC30, pickupModel)
	end

	while not HasModelLoaded(pickupModel) do
		Wait(1)
	end

	local obj = Citizen.InvokeNative(0x509D5878EB39E842, pickupModel, position.x, position.y, position.z, true, true, true)
	Citizen.InvokeNative(0x58A850EAEE20FAA3, obj)
	Citizen.InvokeNative(0xDC19C288082E586E, obj, true, true)
	Citizen.InvokeNative(0x7D9EFB7AD6B19754, obj, true)

	TriggerServerEvent("vorpinventory:sharePickupServer", name, obj, amount, position, weaponId)
	Citizen.InvokeNative(0x67C540AA08E4A6F5, "show_info", "Study_Sounds", true, 0)

end

PickupsService.createMoneyPickup = function (amount)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = GetHashKey("p_moneybag02x")

	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)

		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	if not Citizen.InvokeNative(0x1283B8B89DD5D1B6, pickupModel) then
		Citizen.InvokeNative(0xFA28FE3A6246FC30, pickupModel)
	end

	while not HasModelLoaded(pickupModel) do
		Wait(1)
	end

	local obj = Citizen.InvokeNative(0x509D5878EB39E842, pickupModel, position.x, position.y, position.z, true, true, true)
	Citizen.InvokeNative(0x58A850EAEE20FAA3, obj)
	Citizen.InvokeNative(0xDC19C288082E586E, obj, true, true)
	Citizen.InvokeNative(0x7D9EFB7AD6B19754, obj, true)

	TriggerServerEvent("vorpinventory:shareMoneyPickupServer", obj, amount, position)
	Citizen.InvokeNative(0x67C540AA08E4A6F5, "show_info", "Study_Sounds", true, 0)
end

PickupsService.sharePickupClient = function (name, obj, amount, position, value, weaponId)
	if value == 1 then
		WorldPickups[obj] = {
			name = name, 
			obj = obj,
			amount = amount,
			weaponid = weaponId,
			inRange = false,
			active = false,
			coords = position
		}
	else
		WorldPickups[obj] = nil
	end
end

PickupsService.shareMoneyPickupClient = function (obj, amount, position, value)
	if value == 1 then
		WorldMoneyPickups[obj] = {
			name = "money",
			obj = obj,
			amount = amount,
			inRange = false,
			active = false,
			coords = position
		}
	else
		WorldMoneyPickups[obj] = nil
	end
end

PickupsService.removePickupClient = function (obj)
	Citizen.InvokeNative(0xDC19C288082E586E, obj, false, true)
	local timeout = 0

	while not NetworkHasControlOfEntity(obj) and timeout < 5000 do
		timeout = timeout + 100
		if timeout == 5000 then
			print("Failed to get Control of the Entity")
		end
		Wait(100)
	end

	Citizen.InvokeNative(0x7D9EFB7AD6B19754, obj, false)
	DeleteObject(obj)
end

PickupsService.playerAnim = function (obj)
	local animDict = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
	Citizen.InvokeNative(0xA862A2AD321F94B4, animDict)

	while not Citizen.InvokeNative(0x27FF6FE8009B40CA, animDict) do
		Wait(10)
	end

	Citizen.InvokeNative(0xEA47FE3719165B94, PlayerPedId(), animDict, "exit_front", 1.0, 8.0, -1, 1, 0, false, false, false)
	Wait(1200)
	Citizen.InvokeNative(0x67C540AA08E4A6F5, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
	Wait(1000)
	Citizen.InvokeNative(0xE1EF3C1216AFF2CD, PlayerPedId())
end

PickupsService.DeadActions = function ()
	lastCoords = GetEntityCoords(PlayerPedId(), true, true)
	dropAll = true

	PickupsService.dropAllPlease()
end

PickupsService.dropAllPlease = function ()
	Wait(200)


	if Config.DropOnRespawn.Money then
		TriggerServerEvent("vorpinventory:serverDropAllMoney")
		Wait(200)
	end

	if Config.DropOnRespawn.Items then
		local items = UserInventory

		for _, item in pairs(items) do
			local itemName = item:getName()
			local itemCount = item:getCount()

			TriggerServerEvent("vorpinventory:serverDropItem", itemName, itemCount)
			UserInventory[itemName]:quitCount(itemCount)

			if UserInventory[itemName]:getCount() == 0 then
				UserInventory[itemName] = nil
			end

			Wait(200)
		end
	end

	if Config.DropOnRespawn.Weapons then
		local weapons = UserWeapons

		for index, weapon in pairs(weapons) do
			TriggerServerEvent("vorpinventory:serverDropWeapon", index)

			if next(UserWeapons[index]) ~= nil then
				local currentWeapon = UserWeapons[index]

				if currentWeapon:getUsed() then
					currentWeapon:setUsed(false)
					RemoveWeaponFromPed(PlayerPedId(), GetHashKey(currentWeapon:getName()), true, 0)
				end

				UserWeapons[index] = nil
				Wait(200)
			end
		end
	end

	Wait(200)
	dropAll = false
end

PickupsService.principalFunctionsPickups = function ()
	local playerPed = PlayerPedId()	
	local coords = GetEntityCoords(playerPed, true, true)

	if next(WorldPickups) == nil then
		return 
	end

	for _, pickup in pairs(WorldPickups) do
		local pickupCoords = vector3(pickup.coords.x, pickup.coords.y, pickup.coords.z)
		local distance = #(pickupCoords - coords)

		if distance <= 5.0 and not pickup.inRange then
			if pickup.weaponid == 1 then
				local name = pickup.name
				if next(DB_Items[name]) ~= nil then
					name = DB_Items[name].label
				end
				Utils.DrawText3D(pickup.coords, name)
			else
				local name = Utils.GetWeaponLabel(pickup.name)
				Utils.DrawText3D(pickup.coords, name)
			end
		end

		if distance <= 1.2 and not pickup.inRange then
			TaskLookAtEntity(playerPed, pickup.obj, 3000, 2048, 3)

			if not pickup.active then
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, true)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, true)
				pickup.active = true
			end

			if Citizen.InvokeNative(0xE0F65F0640EF0617, PickPrompt) then
				TriggerServerEvent("vorpinventory:onPickup", pickup.obj)
				pickup.inRange = true
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, false)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, false)
			end
		else
			if pickup.active then
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, false)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, false)
				pickup.active = false
			end
		end
	end
end

PickupsService.principalFunctionsPickupsMoney = function () -- Tick
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)

	if next(WorldMoneyPickups) == nil then
		return
	end

	for _, pickup in pairs(WorldMoneyPickups) do
		local pickupCoords = vector3(pickup.coords.x, pickup.coords.y, pickup.coords.z)
		local distance = #(pickupCoords - coords)

		if distance <= 5.0 then
			Utils.DrawText3D(pickup.coords, pickup.name)
		end

		if distance <= 1.2 and not pickup.inRange then
			Citizen.InvokeNative(0x69F4BE8C8CC4796C, playerPed, pickup.obj, 3000, 2048, 3)

			if not pickup.active then
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, true)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, true)
				pickup.active = true
			end

			if Citizen.InvokeNative(0xE0F65F0640EF0617, PickPrompt) then
				TriggerServerEvent("vorpinventory:onPickupMoney", pickup.obj)
				pickup.inRange = true
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, false)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, false)
			end
		else
			if pickup.active then
				Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, false)
				Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, false)
				pickup.active = false
			end
		end
	end
end

PickupsService.SetupPickPrompt = function ()
	PickPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
	local str = CreateVarString(10, "LITERAL_STRING", _U("TakeFromFloor"))
    Citizen.InvokeNative(0x5DD02A8318420DD7, PickPrompt, str)
    Citizen.InvokeNative(0xB5352B7494A08258, PickPrompt, 0xF84FA74F)
    Citizen.InvokeNative(0x8A0FB4D03A630D21, PickPrompt, false)
    Citizen.InvokeNative(0x71215ACCFDE075EE, PickPrompt, false)
    Citizen.InvokeNative(0x94073D5CA3F16B7B, PickPrompt, true)
    Citizen.InvokeNative(0xF7AA2696A22AD8B9, PickPrompt)
end



-- Setup Thread
Citizen.CreateThread(function()
    PickupsService.SetupPickPrompt()
end)

-- Threads
Citizen.CreateThread(function()
	while true do
		Wait(0)
		PickupsService.principalFunctionsPickups()
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		PickupsService.principalFunctionsPickupsMoney()
	end
end)