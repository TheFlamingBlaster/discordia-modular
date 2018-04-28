local t = {
['cmds'] = {
['ping'] = {
name = 'ping',
command = 'ping',
desc='Replies to a message.',
func = function(m)
    if not args[2] then
        fancy_embed(m,'Pong!')
    else
        fancy_embed(args[3],'Pong!')
    end
end,
permissions = {'readMessages'},
bot_permissions = {'ping'}
},
['status'] = {
name = 'status',
command='status',
desc = 'Displays the status of all running modules.',
func = function(m)
    local fields = {}
    for i,v in pairs(modules) do
        table.insert(fields,{name = v.name,value = tostring(v.status),inline = true})
    end
    m:reply(
    {
        embed = {
        title = 'Module status',
        fields = fields
        }
    }
    )
    
end,
bot_permissions = {"status"},
permissions = {}
},
['cmds'] = {
    name = 'Commands',
    command = 'cmds',
    desc = 'Displays all commands imported to {BOT-NAME}.',
    permissions = {'readMessages'},
    bot_permissions = {'cmds'},
    func = function(m,args)
        local fields = {}
        local tm = ''
        local cmd = args[2]
        for i,v in pairs(commands) do
            if v.command == args[2] or v.name == args[2] then
            local m='**'..v.name..'**'
            local m='**Name:**\n'..v.name..'\n\n'
            m=m..'**Command:** \n'..v.command
            local pm = ''
            if v.desc then
                m = m..'\n\n**Description:** \n'..v.desc
            end
            m = m..'\n\n**Discord Permissions:** '
            for i,v in pairs(v.permissions) do
                m = m..'\n'..v
            end
            m = m..'\n\n**Bot Permissions:** '
            for i,v in pairs(v.bot_permissions) do
                m = m..'\n'..v
            end
            m = m..'\n'
            --print(m)
            tm = tm..m..'\n'
            end
        end
        if tm == '' then
            tm = 'Command information can be found on our documentation website [here]({DOCS}). To find command information on a specific command, do {PREFIX}cmds {COMMAND}'
        end
        fancy_embed(m,tm,'Commands')
    end
}

},
['type'] = 'command-lib'

}

return t