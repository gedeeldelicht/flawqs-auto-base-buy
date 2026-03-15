local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBaseBuyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create a Frame (movable background)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

-- Make the frame draggable
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

-- Create a Button to Buy
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 280, 0, 50)
buyButton.Position = UDim2.new(0,10,0,50)
buyButton.Text = "Buy Base"
buyButton.Font = Enum.Font.SourceSansBold
buyButton.TextSize = 24
buyButton.TextColor3 = Color3.new(1,1,1)
buyButton.BackgroundColor3 = Color3.new(0,0,0)
buyButton.Parent = frame

-- Function to buy the base (trigger server event)
local function buyBase()
    -- Replace with your actual server event or purchase logic
    -- Example: remote event invocation (assuming you have a RemoteEvent named "BuyBaseEvent")
    local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("BuyBaseEvent")
    remoteEvent:FireServer() -- send request to buy the base
end

buyButton.MouseButton1Click:Connect(function()
    buyBase()
end)
