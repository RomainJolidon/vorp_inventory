exports('vorp_inventoryApi',function()
    local self = {}
    self.subWeapon = function(source,weaponid)
        TriggerEvent("vorpCore:subWeapon",source,tonumber(weaponid))
    end

    self.createWeapon = function(source,weaponName,ammoaux,compaux)
        TriggerEvent("vorpCore:registerWeapon",source,tostring(weaponName),ammoaux,compaux)
    end

    self.giveWeapon = function(source,weaponid,target)
        TriggerEvent("vorpCore:giveWeapon",source,weaponid,target)
    end

    self.addItem = function(source,itemName,qty, metadata)
        TriggerEvent("vorpCore:addItem",source,tostring(itemName),tonumber(qty), metadata)
    end

    self.subItem = function(source,itemName,qty, metadata)
        TriggerEvent("vorpCore:subItem",source,tostring(itemName),tonumber(qty), metadata)
    end

    self.getItem = function(source, itemName)
        local item
        
        TriggerEvent("vorpCore:getItem", source, tostring(itemName), function(responseItem)
            item = responseItem
        end)

        return item
    end

    self.getItemCount = function(source,item, metadata)
        local count = 0
        TriggerEvent("vorpCore:getItemCount",source,function(itemcount)
            count = itemcount
        end,tostring(item), metadata)
        return count
    end

    self.getDBItem = function(source, itemName)
        local item
        local done = false

        exports.ghmattimysql:execute( "SELECT * FROM items WHERE item=@id;", {['@id'] = itemName}, 
            function(result)
                -- Add check for if the item exists.
                if result[1] then
                    item = result[1]
                else
                    print('Item does not exist in Items table. Item: '..itemName)
                end
                done = true
            end)

        -- Wait for the call to finish (aka makes this task more syncronous)
        while done == false do
            Wait(500)
        end

        return item
    end

    self.addBullets = function(source,weaponId,type,qty)
        TriggerEvent("vorpCore:addBullets",source,weaponId,type,qty)
    end

    self.subBullets = function(source,weaponId,type,qty)
        TriggerEvent("vorpCore:subBullets",source,weaponId,type,qty)
    end

    self.getWeaponBullets = function(source,weaponId)
        local bull
        TriggerEvent("vorpCore:getWeaponBullets",source,function(bullets)
            bull = bullets
        end,weaponId)
        return bull
    end
    
    self.getWeaponComponents = function(source,weaponId)
        local comp
        TriggerEvent("vorpCore:getWeaponComponents",source,function(components)
            comp = components
        end,weaponId) 
        return comp
    end

    self.getUserWeapons = function(source)
        local weapList
        TriggerEvent("vorpCore:getUserWeapons",source,function(weapons)
            weapList = weapons
        end)
        return weapList
    end

    self.canCarryItems = function(source, amount)
        local can
        TriggerEvent("vorpCore:canCarryItems",source,amount,function(data)
            can = data
        end)
        return can
    end

    self.canCarryItem = function(source, item, amount, metadata)
        local can
        TriggerEvent("vorpCore:canCarryItem",source, item, amount,function(data)
            can = data
        end, metadata)
        return can
    end

    self.getUserWeapon = function(source,weaponId)
        local weap
        TriggerEvent("vorpCore:getUserWeapon",source,function(weapon)
            weap = weapon
        end,weaponId)
        return weap
    end
        
    self.RegisterUsableItem = function(itemName,cb)
        TriggerEvent("vorpCore:registerUsableItem",itemName,cb)
    end

    self.getUserInventory = function(source)
        local inv
        TriggerEvent("vorpCore:getUserInventory", source, function(invent)
            inv = invent
        end)
        return inv
    end

    self.canCarryWeapons = function(source, amount, cb)
        TriggerEvent("vorpCore:canCarryWeapons", source, amount, cb)
    end

    self.CloseInv = function(source) 
        TriggerClientEvent("vorp_inventory:CloseInv",source)
    end

    self.OpenInv = function(source)
        TriggerClientEvent("vorp_inventory:OpenInv",source)
    end
    
    return self
end)
