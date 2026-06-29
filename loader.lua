-- loader.lua
-- Loads the protected (sensitive) module first, then the main UI.
-- This is the ONLY file you need to run in your executor.
--
-- Recommended obfuscation strategy:
--   loader.lua     -> PolSec (medium) - this is the file you actually run
--   protected.lua  -> leave plain on GitHub
--   use kimi.txt   -> leave plain on GitHub (NO VM obfuscation) for FPS

local function loadUrl(url)
    local success, content = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success and content then
        local ok, err = pcall(loadstring(content), url)
        if not ok then
            warn("Failed to execute " .. url .. ": " .. tostring(err))
        end
    else
        warn("Failed to download " .. url .. ": " .. tostring(content))
    end
end

local function loadFile(path)
    local success, content = pcall(function()
        return readfile(path)
    end)
    if success and content then
        local ok, err = pcall(loadstring(content), path)
        if not ok then
            warn("Failed to execute " .. path .. ": " .. tostring(err))
        end
    else
        warn("Failed to read " .. path .. ": " .. tostring(content))
    end
end

-- === CONFIG ===
-- Set USE_LOCAL to true if you want to test from your executor's workspace folder.
-- Set it to false (or nil) to load from GitHub raw URLs.
local USE_LOCAL = false

local PROTECTED_URL = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/protected.lua"
local UI_URL        = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/use%20kimi.txt"

local PROTECTED_PATH = "C:/Users/Adkin/Downloads/advanced/protected.lua"
local UI_PATH        = "C:/Users/Adkin/Downloads/advanced/use kimi.txt"

-- Load protected FIRST so getgenv().ForceHit and getgenv().AnimGodmode exist before the UI sets up toggles.
if USE_LOCAL then
    loadFile(PROTECTED_PATH)
    loadFile(UI_PATH)
else
    loadUrl(PROTECTED_URL)
    loadUrl(UI_URL)
end
