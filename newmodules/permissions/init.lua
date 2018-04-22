local module = {}

module.type = 'lib'
module.values = {
    {
    vname = 'uperms',
    value = {['185856215262298113'] = 6}
    },
    {
    vname = 'permnames',
    value = {[6] = 'Developer',[5] = 'Owner',[4] = 'Head-Admin',[3] = 'Administrator',[2] = 'Moderator',[1] = 'User'}
    },
    {
    vname = 'get_perms',
    value = function(mem,usr)
        if uperms[usr.id] then
            return uperms[usr.id]
        end
        return 1
    end
    }
}

return module