local t = {
['cmds'] = {
['bot_avatar'] = {
name = 'botavatar',
command = 'botavatar',
desc = 'Changes the bot\'s avatar to a url or to an image attached to this message. **REQUIRES BOT OWNER**.',
func = function(m,args)
    local url = args[2]
    if url then
        client:setAvatar(url)
        fancy_embed(m,'Changed avatar to url '..url..'.')
    end
end,
requires_bot_owner = true,
permissions = {}
}
},
['type'] = 'command-lib'
}

return t