-- Server Hopper UI System
-- Execute with: loadstring(game:HttpGet("https://raw.githubusercontent.com/ominomin946-a11y/Hsush/main/ui_system.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local settings = {
    autoHop = true,
    waitTime = 10,
    maxServers = 100,
    logOutput = true
}

-- Stats
local stats = {
    hops = 0,
    targetsFound = 0,
    currentServer = game.JobId
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerHopperUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🔄 Server Hopper"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Dragging
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and dragStart then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.Parent = contentFrame

-- Stats Panel
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1, -20, 0, 90)
statsLabel.Position = UDim2.new(0, 10, 0, 10)
statsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
statsLabel.BorderSizePixel = 0
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statsLabel.TextSize = 12
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = scrollFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsLabel

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = statsLabel

-- Settings Panel
local settingsLabel = Instance.new("TextLabel")
settingsLabel.Name = "SettingsLabel"
settingsLabel.Size = UDim2.new(0.5, -7, 0, 25)
settingsLabel.Position = UDim2.new(0, 10, 0, 110)
settingsLabel.BackgroundTransparency = 1
settingsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsLabel.TextSize = 14
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.Text = "Settings"
settingsLabel.Parent = scrollFrame

-- Auto Hop Toggle
local autoHopLabel = Instance.new("TextLabel")
autoHopLabel.Size = UDim2.new(1, -20, 0, 20)
autoHopLabel.Position = UDim2.new(0, 10, 0, 140)
autoHopLabel.BackgroundTransparency = 1
autoHopLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
autoHopLabel.TextSize = 12
autoHopLabel.Font = Enum.Font.Gotham
autoHopLabel.Text = "Auto Hop: ON"
autoHopLabel.TextXAlignment = Enum.TextXAlignment.Left
autoHopLabel.Parent = scrollFrame

local autoHopButton = Instance.new("TextButton")
autoHopButton.Size = UDim2.new(0, 40, 0, 20)
autoHopButton.Position = UDim2.new(1, -60, 0, 140)
autoHopButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
autoHopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHopButton.TextSize = 10
autoHopButton.Font = Enum.Font.Gotham
autoHopButton.Text = "ON"
autoHopButton.Parent = scrollFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = autoHopButton

autoHopButton.MouseButton1Click:Connect(function()
    settings.autoHop = not settings.autoHop
    autoHopButton.Text = settings.autoHop and "ON" or "OFF"
    autoHopButton.BackgroundColor3 = settings.autoHop and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(150, 50, 50)
    autoHopLabel.Text = "Auto Hop: " .. (settings.autoHop and "ON" or "OFF")
end)

-- Wait Time Slider
local waitTimeLabel = Instance.new("TextLabel")
waitTimeLabel.Size = UDim2.new(1, -20, 0, 20)
waitTimeLabel.Position = UDim2.new(0, 10, 0, 170)
waitTimeLabel.BackgroundTransparency = 1
waitTimeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
waitTimeLabel.TextSize = 12
waitTimeLabel.Font = Enum.Font.Gotham
waitTimeLabel.Text = "Wait Time: 10s"
waitTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
waitTimeLabel.Parent = scrollFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, -20, 0, 8)
sliderBack.Position = UDim2.new(0, 10, 0, 200)
sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = scrollFrame

local sliderBackCorner = Instance.new("UICorner")
sliderBackCorner.CornerRadius = UDim.new(0, 4)
sliderBackCorner.Parent = sliderBack

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, 10, 0, 192)
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = scrollFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sliderButton

-- Slider functionality
local sliderDragging = false
sliderButton.MouseButton1Down:Connect(function()
    sliderDragging = true
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if sliderDragging then
        local mouse = Players.LocalPlayer:GetMouse()
        local relativeX = mouse.X - sliderBack.AbsolutePosition.X
        local maxX = sliderBack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, maxX)
        local percentage = relativeX / maxX
        settings.waitTime = math.floor(percentage * 30) + 1
        sliderButton.Position = UDim2.new(0, 10 + (relativeX - 10), 0, 192)
        waitTimeLabel.Text = "Wait Time: " .. settings.waitTime .. "s"
    end
end)

-- Hop Now Button
local hopButton = Instance.new("TextButton")
hopButton.Size = UDim2.new(1, -20, 0, 35)
hopButton.Position = UDim2.new(0, 10, 0, 230)
hopButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hopButton.TextSize = 14
hopButton.Font = Enum.Font.GothamBold
hopButton.Text = "🔄 Hop Now"
hopButton.Parent = scrollFrame

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 8)
hopCorner.Parent = hopButton

hopButton.MouseButton1Click:Connect(function()
    hopButton.Text = "⏳ Hopping..."
    hopButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    hopButton.Enabled = false
    task.wait(2)
    hopButton.Text = "🔄 Hop Now"
    hopButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    hopButton.Enabled = true
end)

-- Update stats display
local function updateStats()
    statsLabel.Text = string.format(
        "📊 Statistics\n\nServer Hops: %d\nTargets Found: %d\nCurrent Server: %s",
        stats.hops,
        stats.targetsFound,
        string.sub(stats.currentServer, 1, 8) .. "..."
    )
end

updateStats()

-- Update stats every second
RunService.Heartbeat:Connect(function()
    stats.currentServer = game.JobId
    updateStats()
end)

print("✅ Server Hopper UI Loaded!")
