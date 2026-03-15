-- Teleport functie met vertraging
local teleportDelay = 2 -- seconden

local function teleportOutOfBase()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local baseClosed = true -- Voeg hier je eigen logica toe om te controleren of de base gesloten is

    if baseClosed then
        -- Wacht 2 seconden voordat teleporteren
        wait(teleportDelay)
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local targetPosition = Vector3.new(0, 0, 0) -- Pas dit aan naar jouw gewenste locatie
                humanoidRootPart.CFrame = CFrame.new(targetPosition)
            end
        end
    end
end

-- Eventueel: functie om te teleporter te activeren, bijvoorbeeld via knop of commando
local function onTeleportButtonClicked()
    teleportOutOfBase()
end

-- GUI setup
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Maak de ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBaseBuyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Maak een draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Maak een knop om te kopen
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 280, 0, 50)
buyButton.Position = UDim2.new(0, 10, 0, 50)
buyButton.Text = "Buy Base"
buyButton.Font = Enum.Font.SourceSansBold
buyButton.TextSize = 24
buyButton.TextColor3 = Color3.new(1, 1, 1)
buyButton.BackgroundColor3 = Color3.new(0, 0, 0)
buyButton.Parent = frame

-- Functie om basis te kopen (stuurt een RemoteEvent, vervang door jouw event)
local function buyBase()
    local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("BuyBaseEvent")
    remoteEvent:FireServer()
end

buyButton.MouseButton1Click:Connect(function()
    buyBase()
end)

-- Optioneel: Voeg een knop toe die de teleport doet wanneer geklikt
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 280, 0, 50)
teleportButton.Position = UDim2.new(0, 10, 0, 110)
teleportButton.Text = "Teleport Out"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 24
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.BackgroundColor3 = Color3.new(0, 0, 0)
teleportButton.Parent = frame

teleportButton.MouseButton1Click:Connect(function()
    teleportOutOfBase()
end)
