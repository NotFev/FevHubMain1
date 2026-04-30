print("FEVHub Optimized Loader Starting...")

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- === CONFIG ===
local SCRIPT_URL = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"

-- === SAFE LOADER ===
local function loadExternal(url)
    local ok, result = pcall(function()
        local src = game:HttpGet(url)

        if not src or #src < 100 then
            error("Empty or invalid response from URL")
        end

        local fn, compileErr = loadstring(src)
        if not fn then
            error("Compile error: " .. tostring(compileErr))
        end

        return fn()
    end)

    if not ok then
        warn("[FEVHub] Load failed:", result)
        return nil
    end

    return result
end

local loaded = loadExternal(SCRIPT_URL)
if not loaded then
    return
end

print("External script loaded - Cleaner init")

-- === CACHE (weak keys prevents memory leaks) ===
local processed = setmetatable({}, { __mode = "k" })

-- === CLEANER ===
local function CleanObject(obj)
    if not obj or processed[obj] then return end
    processed[obj] = true

    -- Guard against destroyed instances
    if not obj.Parent then return end

    -- Only touch safe UI classes
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local text = obj.Text
        if text and text ~= "" then
            -- Minimal / non-destructive normalization
            obj.Text = text:gsub("%s+", " ")
        end
    end

    -- OPTIONAL: very conservative visibility rule
    if obj:IsA("Frame") then
        local name = string.lower(obj.Name)

        -- Only hide clearly non-critical decorative containers
        if name == "title" or name == "header" then
            obj.Visible = false
        end
    end
end

-- === INITIAL PASS ===
for _, obj in ipairs(CoreGui:GetDescendants()) do
    CleanObject(obj)
end

-- === EVENT-DRIVEN (debounced) ===
CoreGui.DescendantAdded:Connect(function(obj)
    -- defer avoids race conditions during UI construction
    task.defer(CleanObject, obj)
end)

print("FEVHub cleaner running (stable mode)")
