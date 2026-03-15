-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup (Beveiligd via CoreGui indien mogelijk, anders PlayerGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHubV3"
screenGui.ResetOnSpawn = false

-- Probeer in CoreGui te zetten voor extra onzichtbaarheid, anders fallback naar PlayerGui
local success, err = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Hoofdvenster
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0.5, -150, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(150, 0, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FLAWQS HUB - STEAL A BRAINROT"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 4
scroll.Parent = frame

-- Functie om knoppen te maken
local layoutOrder = 0
local function createButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 270, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, layoutOrder * 40)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    layoutOrder = layoutOrder + 1
    return btn
end

--- FEATURES ---

-- 1. Buy Base Anywhere
createButton("Buy Base (Robux)", Color3.fromRGB(40, 40, 40), function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if (v.Name == "Buy" or v.Name == "Claim" or v.Name == "RobuxBuy") and v:IsA("BasePart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                firetouchinterest(player.Character.HumanoidRootPart, v, 0)
                task.wait(0.05)
                firetouchinterest(player.Character.HumanoidRootPart, v, 1)
            end
        end
    end
end)

-- 2. Flash TP naar Eigen Base
createButton("Flash TP (Base)", Color3.fromRGB(0, 100, 200), function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, tycoon in ipairs(workspace:FindFirstChild("Tycoons") and workspace.Tycoons:GetChildren() or {}) do
            local owner = tycoon:FindFirstChild("Owner")
            if owner and owner.Value == player then
                local spawnPoint = tycoon:FindFirstChild("Entrance") or tycoon:FindFirstChild("Spawn") or tycoon:FindFirstChild("Main")
                if spawnPoint then
                    root.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
                end
                break
            end
        end
    end
end)

-- 3. Player ESP
local espEnabled = false
createButton("Toggle Player ESP", Color3.fromRGB(150, 0, 0), function()
    espEnabled = not espEnabled
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if espEnabled then
                if not p.Character:FindFirstChild("FlawQsESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "FlawQsESP"
                    highlight.Adornee = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.Parent = p.Character
                end
            else
                local hl = p.Character:FindFirstChild("FlawQsESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 4. Speed & Jump Boost
local boostEnabled = false
createButton("Toggle Speed/Jump Boost", Color3.fromRGB(0, 150, 50), function()
    boostEnabled = not boostEnabled
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = boostEnabled and 100 or 16
        hum.JumpPower = boostEnabled and 100 or 50
    end
end)

-- 5. Inf Jump
local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)
createButton("Toggle Inf Jump", Color3.fromRGB(0, 150, 150), function()
    infJumpEnabled = not infJumpEnabled
end)

-- 6. Fly (CFrame based for better bypass)
local flying = false
local flySpeed = 50
createButton("Toggle Fly (Press F)", Color3.fromRGB(200, 150, 0), function()
    flying = not flying
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        flying = not flying
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        -- Override velocity to prevent falling
        root.Velocity = Vector3.new(0,0,0)
        if moveDir.Magnitude > 0 then
            root.CFrame = root.CFrame + (moveDir.Unit * (flySpeed * RunService.RenderStepped:Wait()))
        end
    end
end)

-- 7. Give All Tools
createButton("Give All Tools", Color3.fromRGB(100, 0, 100), function()
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Tool") then
            local clone = v:Clone()
            clone.Parent = player.Backpack
        end
    end
end)

-- 8. Auto Hit
local autoHit = false
createButton("Toggle Auto Hit", Color3.fromRGB(200, 100, 0), function()
    autoHit = not autoHit
    task.spawn(function()
        while autoHit do
            if player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            task.wait(0.1)
        end
    end)
end)

-- 9. Bring Shop
createButton("Bring Shop", Color3.fromRGB(100, 100, 100), function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Store")
    
    if root and shop then
        for _, part in ipairs(shop:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CFrame = root.CFrame + Vector3.new(0, 0, 5)
            end
        end
    end
end)

-- 10. Auto Lock Base
createButton("Auto Lock Base", Color3.fromRGB(0, 50, 150), function()
    for _, tycoon in ipairs(workspace:FindFirstChild("Tycoons") and workspace.Tycoons:GetChildren() or {}) do
        local owner = tycoon:FindFirstChild("Owner")
        if owner and owner.Value == player then
            for _, obj in ipairs(tycoon:GetDescendants()) do
                if obj:IsA("RemoteEvent") and (obj.Name:lower():match("lock") or obj.Name:lower():match("door")) then
                    obj:FireServer(true)
                end
            end
        end
    end
end)

-- 11. Base Lock Time ESP
local baseEspEnabled = false
createButton("Toggle Base Lock ESP", Color3.fromRGB(50, 0, 100), function()
    baseEspEnabled = not baseEspEnabled
    for _, tycoon in ipairs(workspace:FindFirstChild("Tycoons") and workspace.Tycoons:GetChildren() or {}) do
        local timerLabel = tycoon:FindFirstChild("LockTimer", true)
        if timerLabel and timerLabel:IsA("TextLabel") then
            if baseEspEnabled then
                if not tycoon:FindFirstChild("FlawQsBaseESP") then
                    local billboard = Instance.new("BillboardGui", tycoon)
                    billboard.Name = "FlawQsBaseESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.Adornee = tycoon:FindFirstChild("Entrance") or tycoon:FindFirstChild("Main")
                    
                    local txt = Instance.new("TextLabel", billboard)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextScaled = true
                    txt.TextColor3 = Color3.new(1, 1, 0)
                    
                    task.spawn(function()
                        while baseEspEnabled and txt.Parent do
                            txt.Text = "Lock: " .. timerLabel.Text
                            task.wait(1)
                        end
                    end)
                end
            else
                local esp = tycoon:FindFirstChild("FlawQsBaseESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)
