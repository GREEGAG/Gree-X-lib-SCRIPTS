-- GreeXklib.lua
-- A script library for Gree X Executor, compatible with Nezur
-- Created by Gree, enhanced with help from xAI's Grok
-- Version 1.2

local GreeXklib = {}
GreeXklib.__index = GreeXklib

-- Library metadata
GreeXklib.Name = "GreeXklib"
GreeXklib.Version = "1.2"
GreeXklib.Author = "Gree"

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Notification function (compatible with both Gree X and Nezur)
local function Notify(title, content, duration)
    duration = duration or 5
    -- Try Gree X's Fluent UI first
    if _G.WINDOW then
        _G.WINDOW:Notify({
            Title = title,
            Content = content,
            Duration = duration
        })
        return
    end
    -- Fallback to Nezur's notification system (if available)
    if _G.Nezur and _G.Nezur.Notify then
        _G.Nezur.Notify(title, content, duration)
        return
    end
    -- Fallback to console output
    warn(string.format("[GreeXklib] %s: %s", title, content))
end

-- Safety check (aligned with Nezur's safety standards)
local function IsSafeToExecute()
    -- Placeholder for UNC/SUNC Level 3 checks (Gree X specific)
    -- Nezur typically checks for anti-cheat flags, so let's simulate that
    local success, result = pcall(function()
        -- Example: Check if getrawmetatable is accessible (common anti-cheat detection)
        return getrawmetatable(game) ~= nil
    end)
    if not success then
        Notify("Safety Check Failed", "Anti-cheat detection triggered.", 5)
        return false
    end
    -- Add your UNC/SUNC Level 3 logic here
    return true
end

-- Teleport function
function GreeXklib:Teleport(position)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Notify("Error", "Character not found for teleport.", 5)
        return false
    end

    if not IsSafeToExecute() then
        Notify("Error", "Unsafe to teleport at this time.", 5)
        return false
    end

    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    Notify("Success", "Teleported to " .. tostring(position), 5)
    return true
end

-- ESP function with customization
function GreeXklib:EnableESP(color)
    if not IsSafeToExecute() then
        Notify("Error", "Unsafe to enable ESP at this time.", 5)
        return false
    end

    color = color or Color3.fromRGB(255, 0, 0) -- Default to red
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = color
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            highlight.Name = "GreeXklibESP"
        end
    end

    Notify("Success", "ESP enabled for all players.", 5)
    return true
end

-- Disable ESP function
function GreeXklib:DisableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("GreeXklibESP")
            if highlight then
                highlight:Destroy()
            end
        end
    end

    Notify("Success", "ESP disabled for all players.", 5)
    return true
end

-- Load script from URL (compatible with Nezur's script execution)
function GreeXklib:LoadScript(url)
    if not IsSafeToExecute() then
        Notify("Error", "Unsafe to execute script at this time.", 5)
        return false
    end

    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        local scriptFunc, err = loadstring(result)
        if scriptFunc then
            -- Nezur often wraps script execution in a pcall for safety
            local execSuccess, execErr = pcall(scriptFunc)
            if execSuccess then
                Notify("Success", "Script loaded from " .. url, 5)
                return true
            else
                Notify("Error", "Script execution failed: " .. tostring(execErr), 5)
                return false
            end
        else
            Notify("Error", "Failed to compile script: " .. tostring(err), 5)
            return false
        end
    else
        Notify("Error", "Failed to fetch script: " .. tostring(result), 5)
        return false
    end
end

-- Auto-farm placeholder
function GreeXklib:StartAutoFarm()
    if not IsSafeToExecute() then
        Notify("Error", "Unsafe to start auto-farm at this time.", 5)
        return false
    end

    spawn(function()
        while true do
            if not LocalPlayer.Character then break end
            -- Add game-specific farming logic here
            wait(1)
        end
    end)

    Notify("Success", "Auto-farm started. (Placeholder)", 5)
    return true
end

-- Blox Fruits auto-farm
function GreeXklib:BloxFruitsAutoFarm()
    if game.PlaceId ~= 2753915549 then
        Notify("Error", "This function only works in Blox Fruits.", 5)
        return false
    end

    if not IsSafeToExecute() then
        Notify("Error", "Unsafe to start Blox Fruits auto-farm.", 5)
        return false
    end

    spawn(function()
        while true do
            if not LocalPlayer.Character then break end
            self:Teleport(Vector3.new(1000, 50, 1000)) -- Replace with actual fruit spawn coordinates
            wait(5)
        end
    end)

    Notify("Success", "Blox Fruits auto-farm started!", 5)
    return true
end

-- Initialize the library
function GreeXklib.new()
    local self = setmetatable({}, GreeXklib)
    Notify("GreeXklib", "Library loaded successfully! Version " .. self.Version, 5)
    return self
end

return GreeXklib
