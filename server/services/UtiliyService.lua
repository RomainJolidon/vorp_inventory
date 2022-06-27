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
	TriggerClientEvent("vorp_inventory:transactionStarted", id)
	table.insert(processingUser, id)
	Log.print("Start Processing user " .. id)
end

SvUtils.InProcessing = function(id)
	for _, v in pairs(processingUser) do
		if v == id then
			return true
		end
	end
	return false
end

SvUtils.Trem = function(id, keepInventoryOpen)
	keepInventoryOpen = keepInventoryOpen == nil and true or keepInventoryOpen

	for k, v in pairs(processingUser) do
		if v == id then
			TriggerClientEvent("vorp_inventory:transactionCompleted", id, keepInventoryOpen)
			table.remove(processingUser, k)
			Log.print("Stop Processing user " .. id)
		end
	end
end