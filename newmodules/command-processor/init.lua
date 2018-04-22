local module = {}



module.event = 'messageCreate'
module.func = function(msg)
    if msg.content:sub(1,prefix:len()) == prefix then
        local args = getArgs(msg.content)
        for i,v in pairs(commands) do
            if v.command == args[1] then
                local nf = v.func
                local p = get_perms(msg.member,msg.author)
                if p > v.permissionLevel or p == v.permissionLevel then
                    debug_fancy_output("Running command "..v.command.." on user "..msg.author.name..'.')
                    setfenv(nf,getfenv())
                    nf(msg,args)
                end
            end
        end
    end
end

module.type = 'event-handler'

return module