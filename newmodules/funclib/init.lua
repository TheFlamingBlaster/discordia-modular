local module = {}

module.type = 'func-lib'
module.values = {
    {
    vname = 'getArgs',
    value = function(v)
	local t = {}
        for x in v:gmatch("%w+") do
            table.insert(t,x)
        end
        return t
    end
    },
    {
    vname = 'fancy_embed',
    value = function(orig,m,title,colour)
        local embed = {}
        embed.description = m
        embed.title = title or "Notification"
        embed.color = discordia.Color.fromRGB(0,255,0).value
        orig:reply({
           embed = embed
        })
    end
    }
}

return module