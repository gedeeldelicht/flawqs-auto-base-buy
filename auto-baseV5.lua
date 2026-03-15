-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlawQsHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Hoofdvenster
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
frame.Active = true
frame.Draggable = true -- Versleepbaar over het hele scherm
frame.Parent = screenGui

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FLAWQS HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

--- 1. FEATURE: Buy Base Anywhere ---
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 210, 0, 45)
buyButton.Position = UDim2.new(0.5, -105, 0, 50)
buyButton.Text = "BUY BASE (ROBUX)"
buyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
buyButton.TextColor3 = Color3.fromRGB(0, 255, 120)
buyButton.Font = Enum.Font.SourceSansBold
buyButton.TextSize = 18
buyButton.Parent = frame

buyButton.MouseButton1Click:Connect(function()
    -- Zoekt naar alle knoppen die te maken hebben met het kopen/claimen van bases
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == "Buy" or v.Name == "Claim" or v.Name == "RobuxBuy" then
            if v:IsA("BasePart") then
                firetouchinterest(player.Character.HumanoidRootPart, v, 0)
                task.wait(0.1)
                firetouchinterest(player.Character.HumanoidRootPart, v, 1)
            end
        end
    end
end)

--- 2. FEATURE: Flash TP naar Eigen Base ---
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 210, 0, 45)
tpButton.Position = UDim2.new(0.5, -105, 0, 110)
tpButton.Text = "FLASH TP (BASE)"
tpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextSize = 18
tpButton.Parent = frame

-- Functie om specifiek jouw base te vinden in "Steal a Brainrot"
local function getMyBase()
    for _, tycoon in pairs(game.Workspace.Tycoons:GetChildren()) do
        -- Controleert of jouw naam op de eigenaar-waarde staat
        local ownerValue = tycoon:FindFirstChild("Owner")
        if ownerValue and ownerValue.Value == player then
            return tycoon
        end
    end
    return nil
end

tpButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        local myBase = getMyBase()
        if myBase then
            -- Teleporteer naar het groene pad (meestal genaamd 'Entrance' of 'Start')
            local spawnPoint = myBase:FindFirstChild("Entrance") or myBase:FindFirstChild("Spawn") or myBase:FindFirstChild("Main")
            if spawnPoint then
                root.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
            end
        else
            warn("Je hebt nog geen basis geclaimd!")
        end
    end
end)
