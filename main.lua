-- FEVHub Purple Loading Animation (Small Size + Arcade Font)
-- Put this at the very top
local LoadingGui = local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "FevHubLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = CoreGui

-- Main Frame with Purple Glow
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = LoadingGui

-- Purple Glow Effect
local Glow = Instance.new("UIStroke")
Glow.Thickness = 8
Glow.Color = Color3.fromRGB(180, 80, 255)
Glow.Transparency = 0.6
Glow.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Title - Purple FEVHUB
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "FEVHUB"
Title.TextColor3 = Color3.fromRGB(180, 80, 255)   -- Purple
Title.TextScaled = true
Title.Font = Enum.Font.Arcade
Title.Parent = MainFrame

-- Loading Text - White
local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 0, 35)
LoadingText.Position = UDim2.new(0, 0, 0.48, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "LOADING"
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)   -- White
LoadingText.TextScaled = true
LoadingText.Font = Enum.Font.Arcade
LoadingText.Parent = MainFrame

-- Spinner (Purple tint)
local Spinner = Instance.new("ImageLabel")
Spinner.Size = UDim2.new(0, 45, 0, 45)
Spinner.Position = UDim2.new(0.5, -22.5, 0.75, 0)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://3926305904"
Spinner.ImageRectOffset = Vector2.new(236, 764)
Spinner.ImageRectSize = Vector2.new(36, 36)
Spinner.ImageColor3 = Color3.fromRGB(180, 80, 255)   -- Purple spinner
Spinner.Parent = MainFrame

-- Animation
local function startLoadingAnimation()
    TweenService:Create(Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), 
    {Rotation = 360}):Play()

    local dots = 0
    spawn(function()
        while LoadingGui and LoadingGui.Parent do
            dots = (dots % 3) + 1
            LoadingText.Text = "LOADING" .. string.rep(".", dots)
            wait(0.35)
        end
    end)
end

startLoadingAnimation()

print("Purple FevHub Loading Animation Started!")

-- LoadingGui:Destroy()   -- Call this when your script finishes loadingprint("FEVHub Optimized Loader Starting...")

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

print("FEVHub X quantom onyx hub loaded")
-- Then at the end of your script when everything is loaded:
wait(2) -- or when your hub is fully ready
LoadingGui:Destroy()
print("FEVHub Loaded!")
