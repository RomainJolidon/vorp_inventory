Weapon = {}

Weapon.name = nil
Weapon.id = nil
Weapon.propietary = nil
Weapon.ammo = {}
Weapon.used = false
Weapon.used2 = false

function Weapon:UnequipWeapon()
	local hash = GetHashKey(self.name)
	self.setUsed(false)
	self.setUsed2(false)

	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, self.getUsed(), self.getUsed2())
	self.RemoveWeaponFromPed()

	Utils.cleanAmmo(self.id)
end

function Weapon:RemoveWeaponFromPed()
	RemoveWeaponFromPed(PlayerPedId(), GetHashKey(self.name), true, 0)
end

function Weapon:loadAmmo()
	-- Completar al final
end

function Weapon:getUsed()
	return self.used
end

function Weapon:getUsed2()
	return self.used2 
end

function Weapon:setUsed(used)
	self.used = used
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, used, self.used2)
end

function Weapon:setUsed2(used2)
	self.used2 = used2
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, self.used, used2)
end

function Weapon:getPropietary()
	return self.propietary
end

function Weapon:setPropietary(propietary)
	self.propietary = propietary
end

function Weapon:getId()
	return self.id
end

function Weapon:setId(id)
	self.id = id
end

function Weapon:getName()
	return self.name
end

function Weapon:setName(name)
	self.name = name
end

function Weapon:getAllAmmo()
	return self.ammo
end

function Weapon:getAmmo(type)
	if self.ammo[type] ~= nil then
		return self.ammo[type]
	end
	return 0
end

function Weapon:setAmmo(type, amount)
	self.ammo[type] = amount
	TriggerServerEvent("vorpinventory:setWeaponBullets", self.id, type, amount)
end

function Weapon:addAmmo(type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] + amount
	else
		self.ammo[type] = amount
	end
end

function Weapon:subAmmo(type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] - amount

		if self.ammo[type] <= 0 then
			self.ammo[type] = nil
		end
	end
end