
--[[ lib4/inpt.lua
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

local inpt = {}

inpt.keyevents = false
inpt.keycodes = {}
inpt.keycode_data = {}
inpt.keysdown = {}
inpt.scancodes = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z',
    '1', '2', '3', '4', '5',
    '6', '7', '8', '9', '0',
    'return', 'escape', 'backspace', 'tab', 'space',
    '-', '=', '[', ']', '\\', 'nonus#', ';',
    '\'', '`', ',', '.', '/', 'capslock',
    'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8',
    'f9', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16',
    'f17', 'f18', 'f19', 'f20', 'f21', 'f22', 'f23', 'f24',
    'lctrl', 'lshift', 'lalt', 'lgui', 'rctrl', 'rshift', 'ralt', 'rgui',
    'printscreen', 'scrolllock', 'pause', 'insert', 'home',
    'numlock', 'pageup', 'delete', 'end', 'pagedown',
    'right', 'left', 'down', 'up',
    'nonusbackslash', 'application', 'execute', 'help',
    'menu', 'select', 'stop', 'again', 'undo',
    'cut', 'copy', 'paste', 'find',
    'kp/', 'kp*', 'kp-', 'kp+', 'kp=', 'kpenter', 'kp.',
    'kp1', 'kp2', 'kp3', 'kp4', 'kp5',
    'kp6', 'kp7', 'kp8', 'kp9', 'kp0',
    'international1', 'international2', 'international3',
    'international4', 'international5', 'international6',
    'international7', 'international8', 'international9',
    'lang1', 'lang2', 'lang3', 'lang4', 'lang5',
    'mute', 'volumeup', 'volumedown', 'audionext', 'audioprev',
    'audiostop', 'audioplay', 'audiomute', 'mediaselect',
    'www', 'mail', 'calculator', 'computer', 'acsearch', 'achome',
    'acback', 'acforward', 'acstop', 'acrefresh', 'acbookmarks',
    'power', 'brightnessdown', 'brightnessup', 'displayswitch',
    'kbdillumtoggle', 'kbdillumdown', 'kbdillumup',
    'eject', 'sleep', 'alterase', 'sysreq', 'cancel', 'clear',
    'prior', 'return2', 'separator', 'out', 'oper', 'clearagain',
    'crsel', 'exsel', 'kp00', 'kp000', 'thsousandsseparator',
    'decimalseparator', 'currencyunit', 'currencysubunit', 'app1',
    'app2', 'unknown'
}

function inpt.enable_keyevents(p)
    inpt.keyevents = (p == nil) or p
end

function inpt.disable_keyevents()
    inpt.keyevents = false
end

function inpt.add_keycode(key, scancode, ...)
    if not inpt.keycode_data[key] then inpt.keycode_data[key] = {} end
    for _, v in ipairs({scancode, ...}) do
        table.insert(inpt.keycode_data[key], v)
        inpt.keycodes[v] = key
    end
end

function inpt.clear_keycode(key)
    for _, v in ipairs(inpt.keycode_data[key]) do
        inpt.keycodes[v] = nil
    end
    inpt.keycode_data[key] = nil
end

function inpt.keycode_down(key, ...)
    if select('#', ...) > 0 then
        for _, v in ipairs({key, ...}) do
            if inpt.keycode_down(v) then return true end
        end
    elseif inpt.keycode_data[key] then
        local mouse = table.filter(inpt.keycode_data[key],
            function(_, v) return type(v) == 'number' end)
        local keys = table.filter(inpt.keycode_data[key],
            function(_, v) return type(v) == 'string' end)
        return love.keyboard.isScancodeDown(unpack(keys))
            or love.mouse.isDown(unpack(mouse))
    end

    return false
end

return inpt
