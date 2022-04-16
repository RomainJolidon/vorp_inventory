Items = {}

Items.item = nil
Items.label = nil
Items.limit = nil
Items.canUse = false 
Items.canRemove = false
Items.type = nil

function Items:getName()
	return self.item
end

function Items:getLabel() 
	return self.label
end

-- TYPE
function Items:setType(type) 
	self.type = type
end

function Items:getType() 
	return self.type
end

-- LIMIT
function Items:getLimit() 
	return self.limit
end

-- CanUse
function Items:setCanUse(canUse) 
	self.canUse = canUse
end

function Items:getCanUse() 
	return self.canUse
end

-- CanRemove
function Items:getCanRemove() 
	return self.canRemove
end

 
function Items:New (t)
	t = t or {}
	setmetatable(t, self)
	self.__index = self
	return t
end