SvUtils = {}
local processingUser = {}

SvUtils.FindItemByNameAndMetadata = function (identifier, name, metadata)
    if UsersInventories[identifier] == nil then
        return nil
    end
    
    for _, item in pairs(UsersInventories[identifier]) do
        if name == item:getName() and SharedUtils.Table_equals(metadata, item:getMetadata()) then
            return item
        end
    end
    return nil
end


SvUtils.ProcessUser = function(id)
	table.insert(processingUser, id)
end

SvUtils.InProcessing = function(id)
	for _, v in pairs(processingUser) do
		if v == id then
			return true
		end
	end
	return false
end

SvUtils.Trem = function(id)
	for k, v in pairs(processingUser) do
		if v == id then
			table.remove(processingUser, k)
		end
	end
end