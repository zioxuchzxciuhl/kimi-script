-- loader.lua
-- Loads the protected (sensitive) module first, then the main UI.
-- Run THIS file through PolSec, then paste the output into your executor.

local function fetch(url)
    if typeof(request) == "function" then
        local ok, res = pcall(function()
            return request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                }
            })
        end)
        if ok and res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 0 then
            return res.Body
        end
    end

    local ok, content = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok and type(content) == "string" and #content > 0 then
        return content
    end

    return nil, tostring(content or "empty response")
end

local function loadUrl(url)
    local content, err = fetch(url)
    if not content then
        warn("Failed to download " .. url .. ": " .. tostring(err))
        return
    end

    local chunk, loadErr = loadstring(content)
    if not chunk then
        warn("Invalid Lua from " .. url .. ": " .. tostring(loadErr))
        warn("Content preview: " .. string.sub(content, 1, 300))
        return
    end

    local ok, runErr = pcall(chunk, url)
    if not ok then
        warn("Failed to execute " .. url .. ": " .. tostring(runErr))
    end
end

local function loadFile(path)
    local ok, content = pcall(function()
        return readfile(path)
    end)
    if not ok or not content then
        warn("Failed to read " .. path .. ": " .. tostring(content))
        return
    end

    local chunk, loadErr = loadstring(content)
    if not chunk then
        warn("Invalid Lua from " .. path .. ": " .. tostring(loadErr))
        return
    end

    local runOk, runErr = pcall(chunk, path)
    if not runErr then
        warn("Failed to execute " .. path .. ": " .. tostring(runErr))
    end
end

local USE_LOCAL = false

local PROTECTED_URL = "https://raw.githubusercontent.com/zioxuchzxciuhl/kimi-script/refs/heads/main/protected.lua"
local UI_URL        = "https://raw.githubusercontent.com/zioxuchzxciuhl/kimi-script/refs/heads/main/use_kimi.txt"

local PROTECTED_PATH = "C:/Users/Adkin/Downloads/advanced/protected.lua"
local UI_PATH        = "C:/Users/Adkin/Downloads/advanced/use_kimi.txt"

if USE_LOCAL then
    loadFile(PROTECTED_PATH)
    loadFile(UI_PATH)
else
    loadUrl(PROTECTED_URL)
    loadUrl(UI_URL)
end
