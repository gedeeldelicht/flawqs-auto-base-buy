-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Hoofdvenster (Zwarte achtergrond)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Donkerzwart
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true -- Maakt het versleepbaar
frame.Parent = screenGui

-- Titel (FlawQs Hub)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FlawQs Hub"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

--- 1. FEATURE: Buy Base ---
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 210, 0, 45)
buyButton.Position = UDim2.new(0, 20, 0, 60)
buyButton.Text = "Buy Base (Robux)"
buyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
buyButton.TextColor3 = Color3.new(1, 1, 1)
buyButton.Font = Enum.Font.SourceSans
buyButton.TextSize = 18
buyButton.Parent = frame

buyButton.MouseButton1Click:Connect(function()
    print("Inkoopverzoek verzonden...")
    -- Let op: De RemoteEvent naam moet exact overeenkomen met die in de game
    local buyRemote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyOpponentsBaseEvent")
    if buyRemote then
        buyRemote:FireServer()
    else
        warn("Buy RemoteEvent niet gevonden in ReplicatedStorage")
    end
end)

--- 2. FEATURE: Flash TP ---
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 210, 0, 45)
tpButton.Position = UDim2.new(0, 20, 0, 120)
tpButton.Text = "Flash TP (Base)"
tpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Groen voor TP
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSans
tpButton.TextSize = 18
tpButton.Parent = frame

tpButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Controleer of de speler iets vastheeft (de "brainrot")
    local hasItem = char:FindFirstChildOfClass("Tool")
    
    if root and hasItem then
        -- Pas deze coördinaten aan naar het groene pad in jouw specifieke map
        local targetPos = Vector3.new(0, 5, 0) 
        root.CFrame = CFrame.new(targetPos)
    elseif not hasItem then
        print("Je moet eerst een item vasthouden!")
    end
end)

-- Draggable Script Fix (voor soepele beweging)
local dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
