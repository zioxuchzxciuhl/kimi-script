-- loader.lua
-- Loads the protected (sensitive) module first, then the main UI.
-- This is the ONLY file you need to run in your executor.
--
-- Recommended obfuscation strategy:
--   loader.lua     -> PolSec (medium) - this is the file you actually run
--   protected.lua  -> leave plain on GitHub
--   use_kimi.txt   -> leave plain on GitHub (NO VM obfuscation) for FPS

local function loadUrl(url)
    local success, content = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not success or not content then
        warn("Failed to download " .. url .. ": " .. tostring(content))
        return
    end

    local chunk, err = loadstring(content)
    if not chunk then
        warn("Invalid Lua from " .. url .. ": " .. tostring(err))
        warn("Content preview: " .. string.sub(content, 1, 300))
        return
    end

    local ok, runErr = pcall(chunk, url)
    if not ok then
        warn("Failed to execute " .. url .. ": " .. tostring(runErr))
    end
end

local function loadFile(path)
    local success, content = pcall(function()
        return readfile(path)
    end)
    if not success or not content then
        warn("Failed to read " .. path .. ": " .. tostring(content))
        return
    end

    local chunk, err = loadstring(content)
    if not chunk then
        warn("Invalid Lua from " .. path .. ": " .. tostring(err))
        return
    end

    local ok, runErr = pcall(chunk, path)
    if not ok then
        warn("Failed to execute " .. path .. ": " .. tostring(runErr))
    end
end

-- === CONFIG ===
-- Set USE_LOCAL to true if you want to test from your executor's workspace folder.
-- Set it to false (or nil) to load from GitHub raw URLs.
local USE_LOCAL = false

local PROTECTED_URL = "https://raw.githubusercontent.com/zioxuchzxciuhl/kimi-script/refs/heads/main/protected.lua"
local UI_URL        = "https://raw.githubusercontent.com/zioxuchzxciuhl/kimi-script/refs/heads/main/use_kimi.txt"

local PROTECTED_PATH = "C:/Users/Adkin/Downloads/advanced/protected.lua"
local UI_PATH        = "C:/Users/Adkin/Downloads/advanced/use_kimi.txt"

-- Load protected FIRST so getgenv().ForceHit and getgenv().AnimGodmode exist before the UI sets up toggles.
if USE_LOCAL then
    loadFile(PROTECTED_PATH)
    loadFile(UI_PATH)
else
    loadUrl(PROTECTED_URL)
    loadUrl(UI_URL)
end
