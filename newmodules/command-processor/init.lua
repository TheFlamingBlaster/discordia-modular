local module = {}



module.event = 'messageCreate'
module.func = function(msg) 
    --print(msg.content:sub(1,1))
    if msg.content:sub(1,prefix:len()) == prefix then
        
        local args = getArgs(msg.content:sub(2))
        for i,v in pairs(commands) do
            if v.command == args[1] then
                local nf = v.func
                local p = get_perms(msg.member,msg.author,v,msg)
                if p[1] == true then
                    debug_fancy_output("Running command "..v.command.." on user "..msg.author.name..'.')
                    setfenv(nf,getfenv())
                    local s,m = pcall(function() nf(msg,args) end)
                    if not s then
                        fancy_embed(msg,'Command '..v.command..' encountered an internal error and cannot continue.','Internal Error',discordia.Color.fromRGB(255,0,0).value)
                        --print(m)
                    end
                else
                    
                    fancy_embed(msg,"You're not allowed to execute this command because you "..p[2],'Permissions',discordia.Color.fromRGB(255,0,0).value)
                end
            end
        end
    end
end

module.type = 'event-handler'

return module