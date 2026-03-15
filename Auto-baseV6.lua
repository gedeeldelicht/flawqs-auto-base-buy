-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHub_V6_Mobile"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Veilige injectie
local parent = (RunService:IsStudio() and player.PlayerGui) or CoreGui
screenGui.Parent = parent

-- Toggle Knop
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
toggleBtn.Text = "OPEN"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Active = true
toggleBtn.Draggable = true
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
title.Text = "FLAWQS HUB V6 (NO-LAG)"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -55)
scroll.Position = UDim2.new(0, 5, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Automatisch
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 2
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Toggle Functie
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "CLOSE" or "OPEN"
end)

-- UI Builders
local function createButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 42)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = scroll
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

local function createHeader(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 35)
    l.Text = "--- " .. text:upper() .. " ---"
    l.TextColor3 = Color3.fromRGB(150, 0, 255)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.Parent = scroll
end

--- [ FEATURES ] ---

createHeader("Main Scripts")
createButton("EXECUTE AUTO-BASE V6", Color3.fromRGB(255, 0, 100), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gedeeldelicht/flawqs-auto-base-buy/refs/heads/main/Auto-baseV6.lua"))()
end)

createHeader("Visuals")
createButton("Player ESP (No-Lag)", Color3.fromRGB(200, 0, 0), function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

createHeader("Movement")
createButton("Max Speed & Jump", Color3.fromRGB(0, 200, 100), function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 100
        hum.JumpPower = 100
    end
end)

local flying = false
createButton("Toggle Fly", Color3.fromRGB(200, 150, 0), function()
    flying = not flying
    if not flying then 
        player.Character.HumanoidRootPart.Velocity = Vector3.zero 
    end
end)

RunService.Heartbeat:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) -- Stabiel zweven
    end
end)

createHeader("Combat & Farming")
createButton("Toggle Auto-Hit (Aura)", Color3.fromRGB(255, 165, 0), function()
    _G.AutoHit = not _G.AutoHit
    task.spawn(function()
        while _G.AutoHit and screenGui.Parent do
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)

createHeader("Utilities")
createButton("Fullbright", Color3.fromRGB(60, 60, 60), function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
end)

createButton("Bring Shop", Color3.fromRGB(80, 80, 80), function()
    local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Store")
    if shop and player.Character:FindFirstChild("HumanoidRootPart") then
        shop:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 6))
    end
end)

createHeader("System")
createButton("DESTROY HUB", Color3.fromRGB(50, 50, 50), function()
    _G.AutoHit = false
    flying = false
    screenGui:Destroy()
end)

print("FlawQs V6 Geladen: Stabiel & No-Lag.")
