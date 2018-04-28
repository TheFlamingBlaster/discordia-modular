local module = {}

module.type = 'func-lib'
module.values = {
    {
    vname = 'getArgs',
    value = function(str)
    local del = " "
	local items = {}
	local test1,test2 = str:find(del)
	while (test1~=nil) do
		items[#items+1] = str:sub(1,test1-1)
		str = str:sub(test2+1)
		test1,test2 = str:find(del)
	end
	items[#items+1] = str
	return items
    end
    },
    {
    vname = 'fancy_embed',
    value = function(orig,m,title,colour)
        local embed = {}
        local m = m
        for i,v in pairs(info) do
            m=m:gsub('{'..i..'}',v)
        end
        embed.description = m
        embed.title = title or "Notification"
        embed.color = discordia.Color.fromRGB(0,255,0).value
        embed.footer = {text=info["BOT-NAME"]..' | '..info["AUTHOR"],icon_url=client.user:getAvatarURL()}
        orig:reply({
           embed = embed
        })
    end
    },
    {
    vname = 'get_muted_role',
    value = function(guild,resetup)
        if not resetup then
        for i,v in pairs(guild.roles) do
            if v.name == 'muted' then
                return v
            end
        end
        end
        
        local newrole = guild:createRole('muted')
        newrole:disableAllPermissions()
        
        for i,v in pairs(guild.textChannels) do
            local overwrite = v:getPermissionOverwriteFor(newrole)
            overwrite:denyPermissions('sendMessages')
        end
        for i,v in pairs(guild.voiceChannels) do
            local overwrite = v:getPermissionOverwriteFor(newrole)
            overwrite:denyPermissions('speak')
        end
        for i,v in pairs(guild.categories) do
            local overwrite = v:getPermissionOverwriteFor(newrole)
            overwrite:denyPermissions('speak')
            overwrite:denyPermissions('sendMessages')
        end
        
        return newrole
    end
    },
    {
    vname = "get_role_by_name",
    value = function(guild,name)
        if name == 'everyone' or name == 'here' then
            name = '@everyone'
        end
        for i,v in pairs(guild.roles) do
            if v.name == name then
                return v
            end
        end
    end
    },
    {
    vname = "add_role_bot_permissions",
    value = function(role,guild,perm)
        local file = io.open("permissions.json","r")
        if not file then
            io.popen("call>permissions.json")
        end
        if file then
        file:close()
        end
        
        local file = io.open("permissions.json","r")
        local t 
        local s,m = pcall(function() t=json.decode(file:read("*all"))  end)
        if not t then
            t = {}
        end
        if file then
        file:close()
        end
        
        if not t[role.id] then
            t[role.id] = json.stringify({})
        end
        
        local rtab = json.decode(t[role.id])
        table.insert(rtab,perm)
        t[role.id] = json.stringify(rtab)
        local file = io.open(path.."".."permissions.json","w")
        file:write(json.stringify(t))
        file:close()
    end
    },
        {
    vname = "remove_role_bot_permissions",
    value = function(role,guild,perm)
        local file = io.open("permissions.json","r")
        if not file then
            io.popen("call>permissions.json")
        end
        if file then
        file:close()
        end
        
        local file = io.open("permissions.json","r")
        local t 
        local s,m = pcall(function() t=json.decode(file:read("*all"))  end)
        if not t then
            t = {}
        end
        if file then
        file:close()
        end
        
        if not t[role.id] then
            t[role.id] = json.stringify({})
        end
        
        local rtab = json.decode(t[role.id])
        local nt = {}
        for i,v in pairs(rtab) do
            if v~= perm then
                table.insert(nt,v)
            end
        end
        t[role.id] = json.stringify(nt)
        local file = io.open(path.."".."permissions.json","w")
        file:write(json.stringify(t))
        file:close()
    end
    },
    {
    vname = "get_role_bot_permissions",
    value = function(role)
        
        local file = io.open("permissions.json","r")
        if file then
        local t 
        pcall(function() t = json.parse(file:read("*all"))  end)
        if not t then
            t = {}
        end
        
        if t[role.id] then
            file:close()
            return json.decode(t[role.id])
        end
        
        end
    end,

},
    {
    vname = "get_perm_mode",
    value = function(guild)
        
        local file = io.open("guilds.json","r")
        if file then
        local t 
        pcall(function() t = json.parse(file:read("*all"))  end)
        if not t then
            t = {}
        end
        
        if t[guild.id] then
            file:close()
            return json.decode(t[guild.id]).bot_perm_mode
        else
            return {['bot_perm_mode'] = true}
        end
        
        end
    end,
    }
}

return module