opt          = "alt"
kana         = {opt}
kanaCtrl     = {opt, "ctrl"}
kanaShift    = {opt, "shift"}
eisuu        = {"ctrl", opt, "cmd"}
colon        = "'"
semicolon    = "return"
atmark       = "["
hat          = "="
bracketLeft  = "]"
bracketRight = "\\"

rightCommandKeyCode = 54
rightCommandFlag    = 16
releasedFlag        = 256

local function keyCode(modifiers, character)
  return function()
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), false):post()
  end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function tmuxKeyCode(modifiers, character)
  return function()
    hs.eventtap.event.newKeyEvent({"ctrl"}, string.lower("T"), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), false):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent({"ctrl"}, string.lower("T"), false):post()
  end
end

-- [Common] -----------------------------------------------------------------------

-- Debug Mode
local rawEventDataPrinter = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event) print(hs.inspect(event:getRawEventData())) end)
debugMode = hs.hotkey.modal.new(eisuu, 'delete')
function debugMode:entered() hs.alert.show("Press eisuu-delete for canceling the debug mode", 5); rawEventDataPrinter:start() end
debugMode:bind(eisuu, 'delete', function() rawEventDataPrinter:stop() debugMode:exit() end)

remapKey({"ctrl"},  colon, keyCode({"shift"}, "7")) -- Ctrl + Colon -> SingleQuote

remapKey({opt}, "space", keyCode({}, "space"))
remapKey(kana, "space", keyCode({}, "space"))

-- Semicolon
remapKey({"ctrl"},  semicolon, keyCode({       }, ";")) -- Ctrl  + Semicolon -> Semicolon
remapKey({"shift"}, semicolon, keyCode({"shift"}, ";")) -- Shift + Semicolon -> Shift + Semicolon

-- Escape
remapKey(kana, "F", keyCode({}, "escape"))

-- Input Mode
remapKey(kana, "S", keyCode({"shift", "ctrl"}, "J")) -- Hiragana
remapKey(kana, "D", keyCode({"shift", "ctrl"}, ";")) -- Eisuu

-- Input conversion
remapKey(kana, "A", keyCode({}, "f10")) -- to Alphabet
remapKey(kana, "Z", keyCode({}, "f7"))  -- to Katakana

-- Move Cursor
remapKey(kana, "H", keyCode({}, "left"))
remapKey(kana, "J", keyCode({}, "down"))
remapKey(kana, "K", keyCode({}, "up"))
remapKey(kana, "L", keyCode({}, "right"))
remapKey(kana, "U", keyCode({"cmd"}, "left"))
remapKey(kana, "I", keyCode({"cmd"}, "right"))
remapKey(kanaShift, "H", keyCode({"shift"}, "left"))
remapKey(kanaShift, "J", keyCode({"shift"}, "down"))
remapKey(kanaShift, "K", keyCode({"shift"}, "up"))
remapKey(kanaShift, "L", keyCode({"shift"}, "right"))
remapKey(kanaShift, "U", keyCode({"cmd", "shift"}, "left"))
remapKey(kanaShift, "I", keyCode({"cmd", "shift"}, "right"))

-- Mouse
local function moveMousePosition(x, y)
  local point = hs.mouse.getAbsolutePosition()
  hs.mouse.setAbsolutePosition({x=point.x + x, y=point.y + y})
end

local function doubleLeftClick(point)
  local clickState = hs.eventtap.event.properties.mouseEventClickState
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], point):setProperty(clickState, 1):post()
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], point):setProperty(clickState, 1):post()
  hs.timer.usleep(1000)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], point):setProperty(clickState, 2):post()
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], point):setProperty(clickState, 2):post()
end

remapKey(kana, "N", function() moveMousePosition(-10, 0) end)                                    -- Move Left
remapKey(kana, "M", function() moveMousePosition(0, 10) end)                                     -- Move Down
remapKey(kana, ",", function() moveMousePosition(0, -10) end)                                    -- Move Up
remapKey(kana, ".", function() moveMousePosition(10, 0) end)                                     -- Move Right
remapKey(kana, "/", function() hs.eventtap.leftClick(hs.mouse.getAbsolutePosition()) end)        -- Left Click
remapKey(kanaCtrl, "/", function() doubleLeftClick(hs.mouse.getAbsolutePosition()) end)          -- Double Click
remapKey(kanaShift, "/", function() hs.eventtap.rightClick(hs.mouse.getAbsolutePosition()) end)  -- Right Click
-- remapKey(kana, "_", function() hs.eventtap.rightClick(hs.mouse.getAbsolutePosition()) end)  -- Right Click

-- Scroll Wheel
remapKey(kana, atmark, function() hs.eventtap.scrollWheel({0,5}, {}) end)
remapKey(kana, bracketRight, function() hs.eventtap.scrollWheel({0,-5}, {}) end)

-- Switch Tab
remapKey(kana, "O", keyCode({"shift", "ctrl"}, "tab"))
remapKey(kana, "P", keyCode({"ctrl"}, "tab"))

-- Input Tab
remapKey(kana, "G", keyCode({}, "tab"))
remapKey(kanaShift, "G", keyCode({"shift"}, "tab"))

-- Clipboard
remapKey(kana, "Y", keyCode({"cmd"}, "C")) -- Copy
remapKey(kana, "T", keyCode({"cmd"}, "X")) -- Cut
remapKey(kana, "X", keyCode({"cmd", "shift", opt}, "V")) -- Paste
-- remapKey(kana, "V", keyCode({"cmd"}, "V")) -- [INCOMPLETE]

-- Delete
remapKey(kana, "C", keyCode({    }, "delete")) -- backward
remapKey(kana, "E", keyCode({"ctrl"}, "D"))    -- forward

-- Undo
remapKey(kana, bracketLeft, keyCode({"cmd"}, "Z"))

-- Switch App [INCOMPLETE]
remapKey(eisuu, "F", keyCode({"cmd"}, "tab"))
-- remapKey(eisuu, "D", keyCode({"cmd"}, "tab"))
remapKey(eisuu, "S", keyCode({"cmd", "shift"}, "tab"))
remapKey(eisuu, "A", keyCode({"cmd", "shift"}, "tab"))

remapKey(eisuu, "D", keyCode({"cmd", opt}, "D"))

-- Window
remapKey(kana, colon, keyCode({"cmd"}, "H"))

-- Zoom
remapKey(eisuu, "9", keyCode({"cmd", "shift"}, ";"))
remapKey(eisuu, "0", keyCode({"cmd"}, "-"))

-- Volume & Brightness
local function changeVolume(x)
  return function()
    local device = hs.audiodevice.defaultOutputDevice()
    device:setVolume(device:volume() + x)
  end
end
local function changeBrightness(x)
  return function()
    local brightness = hs.brightness
    brightness.set(brightness.get() + x)
  end
end
remapKey(eisuu, "1", changeVolume(-5))
remapKey(eisuu, "2", changeVolume(5))
remapKey(eisuu, "3", changeBrightness(-5))
remapKey(eisuu, "4", changeBrightness(5))

-- Function Keys
remapKey(kana, "1", keyCode({}, "f1"))
remapKey(kana, "2", keyCode({}, "f2"))
remapKey(kana, "3", keyCode({}, "f3"))
remapKey(kana, "4", keyCode({}, "f4"))
remapKey(kana, "5", keyCode({}, "f5"))
remapKey(kana, "6", keyCode({}, "f6"))
remapKey(kana, "7", keyCode({}, "f7"))
remapKey(kana, "8", keyCode({}, "f8"))
remapKey(kana, "9", keyCode({}, "f9"))
remapKey(kana, "0", keyCode({}, "f10"))
remapKey(kana, "-", keyCode({}, "f11"))
remapKey(kana, hat, keyCode({}, "f12"))

-- Notification Center
remapKey(eisuu, "tab", keyCode({"cmd", "alt", "ctrl"}, "tab"))

-- Alfred
remapKey(eisuu, "L", keyCode({"cmd", "shift", "ctrl", opt}, "space")) -- Run
remapKey(kana, "tab", keyCode({"cmd", "shift"}, "V"))                 -- Snippet

-- ShiftIt
remapKey(eisuu, "H", keyCode({"cmd", "ctrl", opt}, "left"))
remapKey(eisuu, "O", keyCode({"cmd", "ctrl", opt}, "right"))
remapKey(eisuu, "N", keyCode({"cmd", "ctrl", opt}, "down"))
remapKey(eisuu, "P", keyCode({"cmd", "ctrl", opt}, "up"))
remapKey(eisuu, "U", keyCode({"cmd", "shift", "ctrl", opt}, "1"))
remapKey(eisuu, "I", keyCode({"cmd", "shift", "ctrl", opt}, "2"))
remapKey(eisuu, "M", keyCode({"cmd", "shift", "ctrl", opt}, "3"))
remapKey(eisuu, ",", keyCode({"cmd", "shift", "ctrl", opt}, "4"))
remapKey(eisuu, "B", keyCode({"cmd", "shift", opt}, "B"))
remapKey(kana,  "B", keyCode({"cmd", "shift", opt}, "B"))

-- Reload Hammerspoon settings
remapKey(eisuu, "R", function() hs.reload() end)

-- Right Command to Number
local module = {}
local rightCommandHandler = function(e)
  local watchFor    = { ["a"] = "1", ["s"] = "2", ["d"] = "3", ["f"] = "4", ["g"] = "5", ["h"] = "6", ["j"] = "7", ["k"] = "8", ["l"] = "9", ["\r"] = "0", [":"] = "-", [","] = ",", ["."] = "." }
  local actualKey   = e:getCharacters(true)
  local replacement = watchFor[actualKey:lower()]

  if replacement then
    local isDown           = e:getType() == hs.eventtap.event.types.keyDown
    local replacementEvent = hs.eventtap.event.newKeyEvent({}, replacement, isDown)

    if isDown then
      replacementEvent:setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat))
    end

    return true, { replacementEvent }
  end
end

module.modifierListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  if event:getKeyCode() == rightCommandKeyCode then
    local eventData = event:getRawEventData().NSEventData
    print(eventData.modifierFlags)
    if (eventData.modifierFlags & rightCommandFlag) == rightCommandFlag then
      module.keyListener = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, rightCommandHandler):start()
    elseif module.keyListener and (eventData.modifierFlags & releasedFlag) == releasedFlag then
      module.keyListener:stop()
      module.keyListener = nil
    end
  end
end):start()

-- [App] -----------------------------------------------------------------------

local function remapKeyInApp(appName, mod1, key1, fn)
  local hotkey = hs.hotkey.new(mod1, key1, fn, nil, fn)
  return hs.window.filter.new(appName)
    :subscribe(hs.window.filter.windowFocused,   function() hotkey:enable()  end)
    :subscribe(hs.window.filter.windowUnfocused, function() hotkey:disable() end)
end

-- iTerm2
--- switch pane
remapKeyInApp("iTerm2", kana, "O", tmuxKeyCode({}, "P"))
remapKeyInApp("iTerm2", kana, "P", tmuxKeyCode({}, "N"))

--- close
remapKeyInApp("iTerm2", kana, "W", keyCode({"ctrl"}, "D"))

--- copy
remapKeyInApp("iTerm2", kana, "Z", tmuxKeyCode({}, bracketLeft))
remapKeyInApp("iTerm2", kana, "Y", function() keyCode({}, "return")(); tmuxKeyCode({"ctrl"}, "M")() end)
-- remapKeyInApp("iTerm2", kana, "space", function() keyCode({}, "return")(); tmuxKeyCode({"ctrl"}, "M")() end)

--- move
remapKeyInApp("iTerm2", kana, "U", keyCode({"shift"}, "0")) -- line head
remapKeyInApp("iTerm2", kana, "I", keyCode({"shift"}, "4")) -- line tail

--- adjust pane
remapKeyInApp("iTerm2", kanaShift, "H", tmuxKeyCode({"ctrl"}, "left"))
remapKeyInApp("iTerm2", kanaShift, "J", tmuxKeyCode({"ctrl"}, "down"))
remapKeyInApp("iTerm2", kanaShift, "K", tmuxKeyCode({"ctrl"}, "up"))
remapKeyInApp("iTerm2", kanaShift, "L", tmuxKeyCode({"ctrl"}, "right"))

--- move pane
remapKeyInApp("iTerm2", kanaCtrl, "H", tmuxKeyCode({"ctrl"}, "H"))
remapKeyInApp("iTerm2", kanaCtrl, "J", tmuxKeyCode({"ctrl"}, "J"))
remapKeyInApp("iTerm2", kanaCtrl, "K", tmuxKeyCode({"ctrl"}, "K"))
remapKeyInApp("iTerm2", kanaCtrl, "L", tmuxKeyCode({"ctrl"}, "L"))

-- Slack
remapKeyInApp("Slack", kana, "O", function() hs.eventtap.keyStroke({"shift", opt}, "up") end)
remapKeyInApp("Slack", kana, "P", function() hs.eventtap.keyStroke({"shift", opt}, "down") end)

-- Google Chrome
remapKeyInApp("Google Chrome", eisuu, "C", function() hs.eventtap.keyStroke({"cmd", opt}, "J") end)
remapKeyInApp("Google Chrome", eisuu, "E", function() hs.eventtap.keyStroke({"cmd"}, "L") end)
remapKeyInApp("Google Chrome", eisuu, "T", function() hs.eventtap.keyStroke({"cmd", "shift"}, "T") end)
remapKeyInApp("Google Chrome", {"ctrl"}, "J", function() hs.eventtap.keyStroke({opt}, "return") end)

-- Safari
remapKeyInApp("Safari", eisuu, "C", function() hs.eventtap.keyStroke({"cmd", opt}, "L") end)

-- MindNode Pro
remapKeyInApp("MindNode Pro", eisuu, "9", keyCode({"cmd", "shift"}, "."))
remapKeyInApp("MindNode Pro", eisuu, "0", keyCode({"cmd", "shift"}, ","))
remapKeyInApp("MindNode Pro", kana, "2", keyCode({opt}, "return"))

hs.alert.show("Config loaded")
