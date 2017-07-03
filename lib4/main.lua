
--[[ main.lua Entry point in this game.
    Copyright (c) 2017 Szymon "pi_pi3" Walter

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
]]

-- set require path
local path = love.filesystem.getRequirePath()
love.filesystem.setRequirePath(path .. ';lib/?.lua;lib/?/init.lua')

-- global definitions
lib4 = require('lib4')

require('autobatch')
love3d = require('lib4/lo3d')
util = require('lib4/util')
log = require('log')
declare = util.declare -- global alias for declare, should work in every file

local lgui = require('lib4/lgui')
local file = require('lib4/file')
local phys = require('lib4/phys')

local node = require('lib4/node')

function love.load()
    math.randomseed(os.time()) -- don't forget your randomseed!
    love.math.setRandomSeed(os.time())
    love.keyboard.setKeyRepeat(true)

    -- this is called in love.load, because some external libraries might
    -- require global variables
    util.init_G()

    love3d.load()
    file.load()
    phys.load()

    lib4.load_splash()
end

function love.update(dt)
    if lib4.keyevents then
        for scancode, _ in ipairs(lib4.keysdown) do
            local key = love.keyboard.getKeyFromScancode(scancode)
            love.keydown(key, scancode)
        end
    end

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('update', dt)
    end
end

function love.draw()
    if love3d.enabled then
        love3d.clear()
    end

    if lib4.root then
        lib4.root:signal('draw')
    end
end

function love.keypressed(key, scancode, isrepeat)
    lib4.keysdown[scancode] = true

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('keypressed', key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    lib4.keysdown[scancode] = nil

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('keyreleased', key, scancode, isrepeat)
    end
end

for _, func in pairs({
    'directorydropped', 'errhand', 'filedropped', 'focus',
    'keydown', 'lowmemory',
    'mousefocus', 'mousemoved', 'mousepressed', 'mousereleased',
    'quit', 'resize', 'textedited', 'textinput',
    'threaderror', 'touchmoved', 'touchpressed', 'touchreleased',
    'visible', 'wheelmoved', 'gamepadaxis', 'gamepadpressed',
    'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
    'joystickpressed', 'joystickreleased', 'joystickremoved',
}) do
    love[func] = function(...)
        if lib4.root and not lib4.root.pause then
            lib4.root:signal(func, ...)
        end
    end
end

