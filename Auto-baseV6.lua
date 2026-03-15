-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHub_Mobile_Fixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui) or CoreGui

-- Toggle Knop (Versleepbaar)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
toggleBtn.Text = "HUB"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn)

-- Hoofdvenster
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5, -160, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Visible = false
frame.Parent = screenGui
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "FLAWQS HUB V6 (DRAG FIXED)"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

-- ==========================================
-- CUSTOM DRAG SCRIPT (Mobiel Vriendelijk)
-- ==========================================
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    -- Gebruik een snelle tween voor soepele beweging zonder lag
    TweenService:Create(frame, TweenInfo.new(0.1), {Position = newPos}):Play()
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ==========================================
-- REST VAN DE FEATURES
-- ==========================================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -55)
scroll.Position = UDim2.new(0, 5, 0, 50)
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 2
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function createButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 42)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = scroll
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

createButton("EXECUTE AUTO-BASE V6", Color3.fromRGB(255, 0, 100), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gedeeldelicht/flawqs-auto-base-buy/refs/heads/main/Auto-baseV6.lua"))()
end)

createButton("Speed & Jump Boost", Color3.fromRGB(0, 200, 100), function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 100
        hum.JumpPower = 100
    end
end)

createButton("DESTROY HUB", Color3.fromRGB(50, 50, 50), function()
    screenGui:Destroy()
end)
