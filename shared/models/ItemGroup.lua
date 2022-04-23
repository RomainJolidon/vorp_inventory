ItemGroup = {}

ItemGroup.items = {}
ItemGroup.name = {}

function ItemGroup:FindByMetadata(metadata)
    local foundItem = nil
    for _, item in pairs(self.items) do
        print(json.encode(metadata) .. ' = ' .. json.encode(item.metadata))
        if Table_equals(metadata, item.metadata) then
            foundItem = item
            break
        end
    end
    return foundItem
end

function ItemGroup:FindIdxByMetadata(metadata)
    local foundIndex = 0
    for i, item in ipairs(self.items) do
        if Table_equals(metadata, item.metadata) then
            foundIndex = i
            break
        end
    end
    return foundIndex
end

function ItemGroup:GetCount()
    local count = 0
    for _, item in pairs(self.items) do
        count = count + item:getCount()
    end
    return count
end

function ItemGroup:Add(item)
    self.items[#self.items+1] = item
end

function ItemGroup:Sub(item)
    local idx = self:FindIdxByMetadata(item.metadata)

    if idx > 0 then
        table.remove(self.items, idx)
    end
end

function ItemGroup:New(name)
	local t =  {name = name, items = {}}
	setmetatable(t, self)
	self.__index = self
	return t
end

function Table_equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    
    local keySet = {}
    
    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end
    
    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end