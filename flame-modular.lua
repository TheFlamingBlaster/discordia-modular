--[[
    Modular Admin v 0.0.0 by TheFlamingBlaster
    
    Copyright 2018, TheFlamingBlaster

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
       http://www.apache.org/licenses/LICENSE-2.0
    
    THIS SOFTWARE IS PROVIDED AS-IS AND HAS NO WARRANTY. 
    I DO NOT HAVE ANY RESPONSABILITY IF YOU EXPERIENCE DATA LOSS, CORRUPTION OR SUFFER ANY OTHER DAMAGES RELATED TO THIS SOFTWARE.
    I AM NOT OBLIGATED TO PAY OR COMPANSATE FOR ANY DAMAGES.
    USING THIS SOFTWARE IS AT YOUR OWN RISK.
--]]

discordia = require('Discordia')
client = discordia.Client()
json = require('json')
prefix = '-' -- <-- Prefix
path = "C:\\Users\\TheFlamingBlaster\\Documents\\luvit\\flame-modular\\" -- <-- Directory where the admin resides. 
modules = {}
token = '' -- <-- Insert your token here!

info = {-- <-- We use placeholders in various areas around the admin for commonly used variables. You can change these here if you see fit. 
['DOCS'] = 'http://rtestnew.000webhostapp.com/modular-admin/docs',
['PREFIX'] = prefix,
['BOT-NAME'] = 'Modular Bot',
['AUTHOR'] = "TheFlamingBlaster",
['LICENCE'] = "[Apache Licence 2.0](http://www.apache.org/licenses/LICENSE-2.0)",

}

function readpermissions(filename)
    
end 

debugger = true -- <-- Turn this on if you're making new modules or like extra information

stop_on_error = false 

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
[2] = "Nonexistant module!"
}

commands = {}

import_commands = function(lib) -- <-- Imports commands from CommandModules
    for i,v in pairs(lib.cmds) do
        print(i,v)
        v.lib = lib.name
        debug_fancy_output('Imported command: '..v.name)
        commands[v.name] = v
    end
end

execute_function = function(lib) -- <-- Executes a function from a module under this enviroment
    local f = lib.func
    setfenv(f,setmetatable({},{__index = getfenv()}))
    local s,m = pcall(f)()
end

handle_event = function(lib) -- <-- Handles any discordia event and passes it on to the module's function
    
    client:on(lib.event,function(...) 
    local f = lib.func
    
    setfenv(f,setmetatable({},{__index = getfenv()}))
        f(...)
    end)
    
end

handle_lib = function(lib) -- <-- Imports functions and other stuff to the bot's enviroment
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



local types = { -- <-- Tells the loader how to handle each type of module
    ['command-lib'] = import_commands,
    ['execute-function'] = handle_func,
    ['event-handler'] = handle_event,
    ['func-lib'] = handle_lib,
    ['lib'] = handle_lib
} 

local function import_module(t)
    if t then
    if types[t.type] then
        types[t.type](t)
        return {['complete'] = true}
    else
        return {['complete'] = false,['msg'] = messages[1]}
    end
    else
    return {['complete'] = false,['msg'] = messages[2]}
    end
end -- <-- Imports a module using the correct import function

prefix = '-'

for file in io.popen([[dir "]]..path..[[/newmodules]]..[[" /b ]]):lines() do -- <-- Finds files & loads them into the admin
    debug_fancy_output("..\\newmodules\\"..file)
    local t
    local s,m = pcall(function() t = require(path.."newmodules\\"..file:sub(1,file:len()-1)) end)
    if not s then
        if debugger == false then
        fancy_error('Module '..file..' could not be loaded. If you\'d like the full text, enable debugger mode.')
        else
        fancy_error('Module could not be loaded due to: '..m)
        end
        if stop_on_error == true then
            fancy_error('Stopping execution due to load error.')
            process:exit()
        end
    end
    local r = import_module(t)
    debug_fancy_output('Attempting to load module: '..file)
    if r.complete == true then
        table.insert(modules,{name=file,status=true})
        fancy_output('Module loaded: '..file)
    else
        table.insert(modules,{name=file,status=false})
        fancy_error('Module '..file..' could not be loaded. If you\'d like the full text, enable debugger mode.')
        if stop_on_error == true then
            fancy_error('Stopping execution due to load error.')
            process:exit()
        end
    end
end

fancy_output('Pre-initalization steps complete, proceeding onto bot startup...')
print('\n')

client:run('Bot '..token) -- <-- Informs discordia to run the bot after everything is imported into the bot via modules.
