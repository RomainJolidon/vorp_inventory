DbService = {}

DbService.GiveItem = function (giverCharIdentifier, receiverCharIdentifier, itemCraftedId)
    Log.print('Giving item to another player')
    exports.ghmattimysql:execute("UPDATE character_inventories SET character_id = @receiver WHERE character_id = @giver AND item_crafted_id = @itemid;", {
        ['receiver'] = tonumber(giverCharIdentifier),
        ['giver'] = tonumber(receiverCharIdentifier),
        ['itemid'] =  tonumber(itemCraftedId)
    })
end

DbService.SetItemAmount = function (sourceCharIdentifier, itemCraftedId, amount)
    Log.print('Character[' .. tostring(sourceCharIdentifier) .. '] Set Item[' .. tostring(itemCraftedId) .. '] amount to ' .. tostring(amount))
    exports.ghmattimysql:execute("UPDATE character_inventories SET amount = @amount WHERE character_id = @charid AND item_crafted_id = @itemid;", {
        ['amount'] = tonumber(amount),
        ['charid'] = tonumber(sourceCharIdentifier),
        ['itemid'] =  tonumber(itemCraftedId)
    })
end

DbService.SetItemMetadata = function (sourceCharIdentifier, itemCraftedId, metadata)
    Log.print('Set Item Metadata')
    exports.ghmattimysql:execute("UPDATE items_crafted SET metadata = @metadata WHERE character_id = @charid AND id = @itemid;", {
        ['metadata'] = metadata, -- Check if need to json.encode().
        ['itemCraftedId'] = tonumber(sourceCharIdentifier),
        ['itemid'] = tonumber(itemCraftedId)
    })
end

DbService.DropItem = function (sourceCharIdentifier, itemCraftedId)
    Log.print('Drop Item')
    exports.ghmattimysql:execute("UPDATE character_inventories SET character_id = NULL WHERE character_id = @charid  AND item_crafted_id = @itemid;", {
        ['charid'] = tonumber(sourceCharIdentifier),
        ['itemid'] =  tonumber(itemCraftedId)
    })
end

DbService.PickupItem = function (sourceCharIdentifier, itemCraftedId)
    Log.print('Pickup Item')
    exports.ghmattimysql:execute("UPDATE character_inventories SET character_id = @charid WHERE item_crafted_id = @itemid;", {
        ['charid'] = tonumber(sourceCharIdentifier),
        ['itemid'] =  tonumber(itemCraftedId)
    })
end

DbService.DeleteItem = function (itemCraftedId)
    Log.print('Delete item')
    exports.ghmattimysql:execute("DELETE FROM character_inventories WHERE item_crafted_id = @itemid;", {
        ['itemid'] =  tonumber(itemCraftedId)
    }, function ()
        -- Do we delete this item ?
        exports.ghmattimysql:execute("DELETE FROM items_crafted WHERE id = @itemid;", {
            ['itemid'] =  tonumber(itemCraftedId)
        })
    end)
end

DbService.CreateItem = function(sourceCharIdentifier, itemId, amount, metadata)
    local item = {}
    Log.print('Create Item')
    exports.ghmattimysql:execute("INSERT INTO items_crafted (character_id, item_id, metadata) VALUES (@charid, @itemid, @metadata);", {
        ['charid'] = tonumber(sourceCharIdentifier),
        ['itemid'] = tonumber(itemId),
        ['metadata'] = metadata -- Check if need to json.encode().
    })
    
    -- Can it be replaced with mysql_insert_id() ?
    exports.ghmattimysql:execute("SELECT * FROM items_crafted WHERE character_id = @charid AND item_id = @itemid AND JSON_CONTAINS(metadata, @metadata);", {
        ['charid'] = tonumber(sourceCharIdentifier),
        ['itemid'] = tonumber(itemId),
        ['metadata'] = metadata -- Check if need to json.encode().
    }, function (result)
        if result ~= nil then
            item.id = result.id
            item.metadata = result.metadata
            local itemCraftedId = result.id

            exports.ghmattimysql:execute("INSERT INTO character_inventories (character_id, item_crafted_id, amount) VALUES (@charid, @itemid, @amount);", {
                ['charid'] = tonumber(sourceCharIdentifier),
                ['itemid'] = tonumber(itemCraftedId),
                ['amount'] = tonumber(amount)
            })
        end
    end)
    return item
end