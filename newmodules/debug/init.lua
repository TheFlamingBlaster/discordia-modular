local t = {
['cmds'] = {
['ping'] = {
name = 'ping',
command = 'ping',
func = function(m)
fancy_embed(m,'Pong!')
end,
permissionLevel = 1,
},
['rank'] = {
name = 'getrank',
command = 'myrank',
func = function(m)
fancy_embed(m,'Your rank is: '..get_perms(m.member,m.author),'Rank')
end,
permissionLevel = 1,
},

},
['type'] = 'command-lib'

}

return t