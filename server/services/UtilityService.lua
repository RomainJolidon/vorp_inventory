UtilityService = {}
local random = math.random

function UtilityService.uuid()
    math.randomseed(os.time())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

function UtilityService.FindItemByMetadata(itemList, metadata)
    local _metadata = json.encode(metadata)
    for _, item in pairs(itemList) do
        if json.encode(item.metadata) == _metadata then
            return item
        end
    end
    return nil
end