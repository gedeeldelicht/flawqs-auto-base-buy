-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHub_Mobile_V5"
screenGui.ResetOnSpawn = false

-- Delta/Executor Injectie
local success, err = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Toggle Knop (Voor Mobiel)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
toggleBtn.Text = "OPEN"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui
local btnCorner = Instance.new("UICorner", toggleBtn)

-- Hoofdvenster
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 350)
frame.Position = UDim2.new(0.5, -160, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FLAWQS HUB V5"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 6, 0) -- Ruimte voor alle features
scroll.ScrollBarThickness = 4
scroll.Parent = frame

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "CLOSE" or "OPEN"
end)

local layoutOrder = 0
local function createButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 290, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, layoutOrder * 45)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = scroll
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    layoutOrder = layoutOrder + 1
end

local function createHeader(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Position = UDim2.new(0, 0, 0, layoutOrder * 45)
    l.Text = "--- " .. text:upper() .. " ---"
    l.TextColor3 = Color3.fromRGB(150, 0, 255)
    l.BackgroundTransparency = 1
    l.Parent = scroll
    layoutOrder = layoutOrder + 1
end

--- [ FEATURES ] ---

createHeader("Main Stuff")
createButton("Execute Auto-Base V5", Color3.fromRGB(255, 0, 100), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gedeeldelicht/flawqs-auto-base-buy/refs/heads/main/auto-baseV5.lua"))()
end)

createHeader("Player Visuals")
createButton("ESP: Players (Box/Name)", Color3.fromRGB(200, 0, 0), function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)
createButton("Held Item ESP", Color3.fromRGB(150, 0, 0), function()
    print("Held Item ESP Geactiveerd")
end)

createHeader("Movement & Rage")
createButton("Speed & Jump Boost", Color3.fromRGB(0, 200, 100), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 100
        player.Character.Humanoid.JumpPower = 100
    end
end)

local flying = false
createButton("Toggle Fly", Color3.fromRGB(200, 150, 0), function()
    flying = not flying
end)
RunService.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1, 0)
    end
end)

createHeader("Stealer & Combat")
createButton("Auto Grab (Radius)", Color3.fromRGB(100, 0, 150), function()
    print("Auto Grab Geactiveerd")
end)

createButton("Auto Hit (Aura)", Color3.fromRGB(255, 165, 0), function()
    _G.AutoHit = not _G.AutoHit
    task.spawn(function()
        while _G.AutoHit do
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)

createHeader("World & Base")
createButton("Base Lock ESP", Color3.fromRGB(80, 0, 255), function()
    for _, t in pairs(workspace.Tycoons:GetChildren()) do
        local timer = t:FindFirstChild("LockTimer", true)
        if timer then
            local bg = Instance.new("BillboardGui", t)
            bg.Size = UDim2.new(0,100,0,50)
            bg.AlwaysOnTop = true
            local tl = Instance.new("TextLabel", bg)
            tl.Text = "Lock: " .. timer.Text
            tl.TextColor3 = Color3.new(1,1,0)
            tl.Parent = bg
        end
    end
end)

createButton("Fullbright / Time of Day", Color3.fromRGB(60, 60, 60), function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
end)

createButton("Bring Shop", Color3.fromRGB(80, 80, 80), function()
    local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Store")
    if shop and player.Character then
        shop:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 5))
    end
end)

createHeader("Panic")
createButton("DESTROY HUB", Color3.fromRGB(50, 50, 50), function()
    screenGui:Destroy()
end)

print("FlawQs Mobile Hub Geladen.")
