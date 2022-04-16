RegisterCommand("getInv", function(source, args, rawCommand)
    -- If the source is > 0, then that means it must be a player.
    if (source > 0) then
        local character = Core.getUser(source).getUsedCharacter
    
        TriggerClientEvent("vorp:SelectedCharacter", source, character.id)
    
    -- If it's not a player, then it must be RCON, a resource, or the server console directly.
    else
        print("This command was executed by the server console, RCON client, or a resource.")
    end
end, false --[[this command is not restricted, everyone can use this.]])