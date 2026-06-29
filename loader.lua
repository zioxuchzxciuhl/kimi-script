-- loader.lua
-- Loads the protected module first, then the main UI.
-- Run THIS file through PolSec, then paste the output into your executor.

local function fetch(url)
    for i = 1, 3 do
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

        if i < 3 then
            task.wait(0.5)
        end
    end
    return nil
end

local function loadUrl(url)
    local content = fetch(url)
    if not content then
        return
    end

    local chunk = loadstring(content)
    if not chunk then
        return
    end

    pcall(chunk, url)
end

local function loadFile(path)
    local ok, content = pcall(function()
        return readfile(path)
    end)
    if not ok or not content then
        return
    end

    local chunk = loadstring(content)
    if not chunk then
        return
    end

    pcall(chunk, path)
end

local USE_LOCAL = false

local PROTECTED_URL = "https://cdn.jsdelivr.net/gh/zioxuchzxciuhl/kimi-script@main/protected.lua"
local UI_URL        = "https://cdn.jsdelivr.net/gh/zioxuchzxciuhl/kimi-script@main/use_kimi.txt"

local PROTECTED_PATH = "C:/Users/Adkin/Downloads/advanced/protected.lua"
local UI_PATH        = "C:/Users/Adkin/Downloads/advanced/use_kimi.txt"

if USE_LOCAL then
    loadFile(PROTECTED_PATH)
    loadFile(UI_PATH)
else
    loadUrl(PROTECTED_URL)
    loadUrl(UI_URL)
end
