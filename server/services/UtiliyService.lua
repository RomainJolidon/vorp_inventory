UtilityService = {}

UtilityService.FindItemByNameAndMetadata = function (identifier, name, metadata)
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