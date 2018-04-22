discordia = require('Discordia')
client = discordia.Client()
json = require('json')
prefix = '-'
local path = "C:\\Users\\TheFlamingBlaster\\Documents\\luvit\\flame-modular\\"
local token = '[YOUR TOKEN HERE]'

debugger = true

function fancy_error(m)
    local logger = discordia.Logger(1,"%F %T")
    logger:log(1,tostring(m))
end

function fancy_output(m)
    local logger = discordia.Logger(3,"%F %T")
    logger:log(3,tostring(m))
end

function debug_fancy_output(m)
    if debugger == true then
        local logger = discordia.Logger(4,"%F %T")
        logger:log(4,tostring(m))
    end
end


local messages = {
[0] = "An unknown error occured, no response code was provided.",
[1] = "The module couldn't be imported because it doesn't have a defined type.",
}

commands = {}

import_commands = function(lib)
    for i,v in pairs(lib.cmds) do
        debug_fancy_output('Imported command: '..v.name)
        commands[v.name] = v
    end
end

execute_function = function(lib)
    local f = lib.func
    setfenv(f,setmetatable({},{__index = getfenv()}))
    local s,m = pcall(f)()
end

handle_event = function(lib)
    
    client:on(lib.event,function(...) 
    local f = lib.func
    
    setfenv(f,setmetatable({},{__index = getfenv()}))
        f(...)
    end)
    
end

handle_lib = function(lib)
    for i,v in pairs(lib.values) do
    
        if type(v.value) == 'function' then
        
        local nf = v.value
        setfenv(nf,getfenv())
        getfenv(0)[v.vname] = nf
        else
        getfenv(0)[v.vname] = v.value
        end
        debug_fancy_output('Imported '..type(v.value)..' '..v.vname..' to enviroment')
    end
end



local types = {
    ['command-lib'] = import_commands,
    ['execute-function'] = handle_func,
    ['event-handler'] = handle_event,
    ['func-lib'] = handle_lib,
    ['lib'] = handle_lib
}

local function import_module(t)
    if types[t.type] then
        types[t.type](t)
        return {['complete'] = true}
    else
        return {['complete'] = false,['msg'] = messages[1]}
    end
end

prefix = '-'

for file in io.popen([[dir "]]..path..[[/newmodules]]..[[" /b ]]):lines() do
    debug_fancy_output("..\\newmodules\\"..file)
    local t = require(path.."newmodules\\"..file:sub(1,file:len()-1))
    local r = import_module(t) 
    debug_fancy_output('Attempting to load module: '..file)
    if r.complete == true then
        fancy_output('Module loaded: '..file)
    else
        fancy_error(r.msg)
    end
end

fancy_output('Pre-initalization steps complete, proceeding onto bot startup...')
print('\n')
client:run('Bot '..token)
