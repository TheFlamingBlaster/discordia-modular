local module = {}

module.type = 'lib'
module.values = {
    {
    vname = 'uperms',
    value = {['185856215262298113'] = {'manageBot','administrator'}}
    },
    {
    vname = 'permnames',
    value = {[6] = 'Developer',[5] = 'Owner',[4] = 'Head-Admin',[3] = 'Administrator',[2] = 'Moderator',[1] = 'User'}
    },
    
    {
    vname = 'get_perms',
    value = function(mem,usr,cmd,msg)
        local re = {true}
        local t = {}
        
        local perms = mem:getPermissions()
        local cperms = mem:getPermissions(msg.channel)
        if get_perm_mode(msg.guild) == false then
        for i,v in pairs(cmd.permissions) do
            if not perms:has(v) and not cperms:has(v) then
                re = {false,"you don\'t have permission to execute this command."}
            end
        end
        else
        re = {false,"you don\'t have permission to execute this command."}
        end
        if cmd.bot_permissions then
            for i1,v1 in pairs(cmd.bot_permissions) do
            for i2,v2 in pairs(mem.roles) do
                
                local perms=get_role_bot_permissions(v2)
                if perms then
                    for i,v in pairs(perms) do
                        --print(v,v1)
                        if v1 == v then
                            re = {true}
                        end
                    end
                end
            end
            end
        end
        
        if cmd.higher then
            for i,v in pairs(msg.mentionedUsers) do
                if msg.guild:getMember(v).highestRole.position > msg.member.highestRole.position or msg.guild:getMember(v).highestRole.position == msg.member.highestRole.position or v == client.user then
                    re = {false,"attempted to act apon someone of a higher or equal rank."}
                end
            end
        end
        
        if mem.guild.owner == mem then
            re = {true}
        end
        
        if cmd.requires_owner then
            if cmd.requires_owner == true and mem.guild.owner == mem then
                re = {true}
            else
                re = {false,'aren\'t owner of the guild.'}
            end
        end
        
        if cmd.requires_bot_owner then
            if cmd.requires_bot_owner == true and client.owner == msg.author then
                re = {true}
            else
                re = {false,"aren't the bots owner."}
            end
        end
        
        return re
    end,
    
    },
    
    }

return module