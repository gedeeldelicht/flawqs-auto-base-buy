-- Teleport functie met vertraging
local teleportDelay = 2 -- seconden

local function teleportOutOfBase(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Hier voeg je je eigen check toe of de basis gesloten is
    local baseClosed = true -- vervang door je logica

    if baseClosed then
        wait(teleportDelay)
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(targetPosition)
            end
        end
    end
end

-- GUI setup
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQshub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame (Hub)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

-- Draggable logica (behouden)
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

-- Knop voor "Steal Brainrots" (teleport uit base)
local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(0, 280, 0, 50)
stealButton.Position = UDim2.new(0, 10, 0, 10)
stealButton.Text = "Steal Brainrots"
stealButton.Font = Enum.Font.SourceSansBold
stealButton.TextSize = 24
stealButton.TextColor3 = Color3.new(1, 1, 1)
stealButton.BackgroundColor3 = Color3.new(0, 0, 0)
stealButton.Parent = frame

stealButton.MouseButton1Click:Connect(function()
    -- Hier definieer je je target positie naar jouw "groen basis" of het te stelen object
    local targetPosition = Vector3.new(100, 10, 100) -- pas aan naar jouw locatie
    teleportOutOfBase(targetPosition)
end)

-- Knop voor "Buy Base"
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 280, 0, 50)
buyButton.Position = UDim2.new(0, 10, 0, 70)
buyButton.Text = "Buy Base"
buyButton.Font = Enum.Font.SourceSansBold
buyButton.TextSize = 24
buyButton.TextColor3 = Color3.new(1, 1, 1)
buyButton.BackgroundColor3 = Color3.new(0, 0, 0)
buyButton.Parent = frame

buyButton.MouseButton1Click:Connect(function()
    -- Open een simpel menu of prompt om "tegenstander base" te kopen
    local result = Instance.new("Message")
    result.Text = "Klik op OK om te kopen (voor demo)"
    result.Parent = game.CoreGui
    wait(2)
    result:Destroy()

    -- Hier kun je je aankoop logica toevoegen, bijvoorbeeld:
    local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("BuyOpponentsBaseEvent")
    remoteEvent:FireServer() -- stuur de info dat je tegenstander zijn basis koopt
end)

-- Optioneel, je kunt een bevestigingsmenu maken met een Frame en Buttons
-- maar voor eenvoud gebruik ik hier een Message prompt

-- Als je wilt dat de "hub" rond het scherm blijft bewegen, is dat al geactiveerd
-- Zorg dat je de remote events hebt voor kopieer en teleport functies
