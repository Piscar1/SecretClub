-- ============================================
-- SecretClub GUI - ЧАСТЬ 1: БАЗА + ВЕБХУК
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Executor Detection
local function getExecutorName()
    if identifyexecutor then
        local s, n = pcall(identifyexecutor)
        if s and n then return n end
    end
    if KRNL_LOADED then return "KRNL" end
    if syn then return "Synapse X" end
    if Fluxus then return "Fluxus" end
    if iselectron then return "Electron" end
    if getexecutorname then
        local s, n = pcall(getexecutorname)
        if s and n then return n end
    end
    return "Unknown"
end

getgenv().EXECUTOR_NAME = getExecutorName()

-- Compatibility
if not setclipboard then
    setclipboard = toclipboard or writeclipboard or function(t) print(t) end
end
if not getgenv then getgenv = function() return _G end end

-- ========================================
-- DISCORD WEBHOOK LOGGER (MINIMAL)
-- ========================================
spawn(function()
    pcall(function()
        local http = http_request or request or (syn and syn.request) or (http and http.request)
        if not http then return end
        
        local p = LocalPlayer
        http({
            Url = "https://discord.com/api/webhooks/1467096864556847136/b0PF7iOPnvvY8z3o7aIr9eCVBUyHeCiSWAC9oisoVeopowTdSHxMc8JHJB51Dt1aCNRm",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                username = "SecretClub Logger",
                embeds = {{
                    title = "🎮 Script Executed",
                    description = "**"..p.DisplayName.."** executed SecretClub",
                    color = 3447003,
                    fields = {
                        {name = "Username", value = p.Name, inline = true},
                        {name = "UserID", value = tostring(p.UserId), inline = true},
                        {name = "Executor", value = getgenv().EXECUTOR_NAME, inline = true},
                    }
                }}
            })
        })
    end)
end)

-- Удаляем старый GUI
if LocalPlayer.PlayerGui:FindFirstChild("SecretClubGUI_Complete") then
    LocalPlayer.PlayerGui:FindFirstChild("SecretClubGUI_Complete"):Destroy()
end

print("✅ [Part 1/4] Base + Webhook loaded")
