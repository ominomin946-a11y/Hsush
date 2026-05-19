-- Server Hopper UI System (Enhanced)
-- Execute with: loadstring(game:HttpGet("https://raw.githubusercontent.com/ominomin946-a11y/Hsush/main/ui_system.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

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
    currentServer = game.JobId,
    lastUpdate = tick()
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerHopperUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Border effect
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ SERVER HOPPER"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
closeButton.TextColor3 = Color3.fromRGB(20, 20, 20)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Dragging
local dragging = false
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

titleBar.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and dragStart and startPos then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 850)
scrollFrame.Parent = contentFrame

-- Padding for content
local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 15)
contentPadding.PaddingRight = UDim.new(0, 15)
contentPadding.PaddingTop = UDim.new(0, 15)
contentPadding.PaddingBottom = UDim.new(0, 15)
contentPadding.Parent = scrollFrame

-- Stats Panel
local statsPanel = Instance.new("Frame")
statsPanel.Name = "StatsPanel"
statsPanel.Size = UDim2.new(1, -30, 0, 120)
statsPanel.Position = UDim2.new(0, 15, 0, 15)
statsPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statsPanel.BorderSizePixel = 0
statsPanel.Parent = scrollFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsPanel

local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Color3.fromRGB(255, 140, 0)
statsStroke.Thickness = 1
statsStroke.Parent = statsPanel

local statsPadding = Instance.new("UIPadding")
statsPadding.PaddingLeft = UDim.new(0, 12)
statsPadding.PaddingRight = UDim.new(0, 12)
statsPadding.PaddingTop = UDim.new(0, 12)
statsPadding.PaddingBottom = UDim.new(0, 12)
statsPadding.Parent = statsPanel

local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1, 0, 1, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.TextSize = 13
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = statsPanel

-- Section Title: Settings
local settingsTitleLabel = Instance.new("TextLabel")
settingsTitleLabel.Name = "SettingsTitle"
settingsTitleLabel.Size = UDim2.new(1, -30, 0, 25)
settingsTitleLabel.Position = UDim2.new(0, 15, 0, 145)
settingsTitleLabel.BackgroundTransparency = 1
settingsTitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
settingsTitleLabel.TextSize = 16
settingsTitleLabel.Font = Enum.Font.GothamBold
settingsTitleLabel.Text = "⚙️ SETTINGS"
settingsTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
settingsTitleLabel.Parent = scrollFrame

-- Auto Hop Setting
local autoHopContainer = Instance.new("Frame")
autoHopContainer.Name = "AutoHopContainer"
autoHopContainer.Size = UDim2.new(1, -30, 0, 45)
autoHopContainer.Position = UDim2.new(0, 15, 0, 180)
autoHopContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoHopContainer.BorderSizePixel = 0
autoHopContainer.Parent = scrollFrame

local autoHopCorner = Instance.new("UICorner")
autoHopCorner.CornerRadius = UDim.new(0, 8)
autoHopCorner.Parent = autoHopContainer

local autoHopStroke = Instance.new("UIStroke")
autoHopStroke.Color = Color3.fromRGB(255, 140, 0)
autoHopStroke.Thickness = 1
autoHopStroke.Parent = autoHopContainer

local autoHopLabel = Instance.new("TextLabel")
autoHopLabel.Size = UDim2.new(0.6, 0, 1, 0)
autoHopLabel.Position = UDim2.new(0, 12, 0, 0)
autoHopLabel.BackgroundTransparency = 1
autoHopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHopLabel.TextSize = 14
autoHopLabel.Font = Enum.Font.GothamBold
autoHopLabel.Text = "Auto Hop"
autoHopLabel.TextXAlignment = Enum.TextXAlignment.Left
autoHopLabel.TextYAlignment = Enum.TextYAlignment.Center
autoHopLabel.Parent = autoHopContainer

local autoHopToggle = Instance.new("TextButton")
autoHopToggle.Name = "Toggle"
autoHopToggle.Size = UDim2.new(0, 45, 0, 25)
autoHopToggle.Position = UDim2.new(1, -60, 0.5, -12)
autoHopToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
autoHopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHopToggle.TextSize = 10
autoHopToggle.Font = Enum.Font.GothamBold
autoHopToggle.Text = "ON"
autoHopToggle.BorderSizePixel = 0
autoHopToggle.Parent = autoHopContainer

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = autoHopToggle

autoHopToggle.MouseButton1Click:Connect(function()
    settings.autoHop = not settings.autoHop
    autoHopToggle.Text = settings.autoHop and "ON" or "OFF"
    autoHopToggle.BackgroundColor3 = settings.autoHop and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(150, 50, 50)
end)

autoHopToggle.MouseEnter:Connect(function()
    autoHopToggle.TextSize = 11
end)

autoHopToggle.MouseLeave:Connect(function()
    autoHopToggle.TextSize = 10
end)

-- Wait Time Setting
local waitTimeContainer = Instance.new("Frame")
waitTimeContainer.Name = "WaitTimeContainer"
waitTimeContainer.Size = UDim2.new(1, -30, 0, 70)
waitTimeContainer.Position = UDim2.new(0, 15, 0, 235)
waitTimeContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
waitTimeContainer.BorderSizePixel = 0
waitTimeContainer.Parent = scrollFrame

local waitTimeCorner = Instance.new("UICorner")
waitTimeCorner.CornerRadius = UDim.new(0, 8)
waitTimeCorner.Parent = waitTimeContainer

local waitTimeStroke = Instance.new("UIStroke")
waitTimeStroke.Color = Color3.fromRGB(255, 140, 0)
waitTimeStroke.Thickness = 1
waitTimeStroke.Parent = waitTimeContainer

local waitTimePadding = Instance.new("UIPadding")
waitTimePadding.PaddingLeft = UDim.new(0, 12)
waitTimePadding.PaddingRight = UDim.new(0, 12)
waitTimePadding.PaddingTop = UDim.new(0, 12)
waitTimePadding.PaddingBottom = UDim.new(0, 12)
waitTimePadding.Parent = waitTimeContainer

local waitTimeLabel = Instance.new("TextLabel")
waitTimeLabel.Size = UDim2.new(1, 0, 0, 20)
waitTimeLabel.BackgroundTransparency = 1
waitTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
waitTimeLabel.TextSize = 14
waitTimeLabel.Font = Enum.Font.GothamBold
waitTimeLabel.Text = "Wait Time: 10s"
waitTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
waitTimeLabel.Parent = waitTimeContainer

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, 0, 0, 8)
sliderBack.Position = UDim2.new(0, 0, 0, 35)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = waitTimeContainer

local sliderBackCorner = Instance.new("UICorner")
sliderBackCorner.CornerRadius = UDim.new(0, 4)
sliderBackCorner.Parent = sliderBack

local sliderButton = Instance.new("Frame")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 16, 0, 24)
sliderButton.Position = UDim2.new(0, 0, 0.5, -12)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBack

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4)
sliderCorner.Parent = sliderButton

-- Slider functionality
local sliderDragging = false

sliderButton.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if sliderDragging then
        local mousePos = mouse.X
        local sliderBackPos = sliderBack.AbsolutePosition.X
        local sliderBackSize = sliderBack.AbsoluteSize.X
        
        local relativeX = mousePos - sliderBackPos
        relativeX = math.clamp(relativeX, 0, sliderBackSize)
        
        local percentage = relativeX / sliderBackSize
        settings.waitTime = math.floor(percentage * 29) + 1
        
        sliderButton.Position = UDim2.new(0, relativeX - 8, 0.5, -12)
        waitTimeLabel.Text = "Wait Time: " .. settings.waitTime .. "s"
    end
end)

-- Section Title: Actions
local actionsTitleLabel = Instance.new("TextLabel")
actionsTitleLabel.Name = "ActionsTitle"
actionsTitleLabel.Size = UDim2.new(1, -30, 0, 25)
actionsTitleLabel.Position = UDim2.new(0, 15, 0, 315)
actionsTitleLabel.BackgroundTransparency = 1
actionsTitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
actionsTitleLabel.TextSize = 16
actionsTitleLabel.Font = Enum.Font.GothamBold
actionsTitleLabel.Text = "🎯 ACTIONS"
actionsTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
actionsTitleLabel.Parent = scrollFrame

-- Hop Now Button
local hopButton = Instance.new("TextButton")
hopButton.Name = "HopButton"
hopButton.Size = UDim2.new(1, -30, 0, 45)
hopButton.Position = UDim2.new(0, 15, 0, 350)
hopButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
hopButton.TextColor3 = Color3.fromRGB(20, 20, 20)
hopButton.TextSize = 16
hopButton.Font = Enum.Font.GothamBold
hopButton.Text = "🔄 HOP NOW"
hopButton.BorderSizePixel = 0
hopButton.Parent = scrollFrame

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 10)
hopCorner.Parent = hopButton

hopButton.MouseButton1Click:Connect(function()
    hopButton.Text = "⏳ HOPPING..."
    hopButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    hopButton.Enabled = false
    task.wait(2)
    hopButton.Text = "🔄 HOP NOW"
    hopButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    hopButton.Enabled = true
end)

hopButton.MouseEnter:Connect(function()
    hopButton.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
end)

hopButton.MouseLeave:Connect(function()
    hopButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Reset Stats Button
local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(1, -30, 0, 45)
resetButton.Position = UDim2.new(0, 15, 0, 405)
resetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetButton.TextColor3 = Color3.fromRGB(255, 140, 0)
resetButton.TextSize = 14
resetButton.Font = Enum.Font.GothamBold
resetButton.Text = "🔄 RESET STATS"
resetButton.BorderSizePixel = 0
resetButton.Parent = scrollFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetButton

local resetStroke = Instance.new("UIStroke")
resetStroke.Color = Color3.fromRGB(255, 140, 0)
resetStroke.Thickness = 1
resetStroke.Parent = resetButton

resetButton.MouseButton1Click:Connect(function()
    stats.hops = 0
    stats.targetsFound = 0
end)

resetButton.MouseEnter:Connect(function()
    resetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

resetButton.MouseLeave:Connect(function()
    resetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Toggle UI with key (Press 'P' to show/hide)
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end
end)

-- Update stats display
local function updateStats()
    statsLabel.Text = string.format(
        "📊 SERVER HOPS\n%d\n\n🎯 TARGETS FOUND\n%d\n\n🖥️ CURRENT SERVER\n%s",
        stats.hops,
        stats.targetsFound,
        string.sub(stats.currentServer, 1, 6) .. "..."
    )
end

updateStats()

-- Update stats every 0.5 seconds
RunService.Heartbeat:Connect(function()
    stats.currentServer = game.JobId
    if tick() - stats.lastUpdate > 0.5 then
        updateStats()
        stats.lastUpdate = tick()
    end
end)

print("✅ Server Hopper UI Loaded!")
print("📌 Press 'P' to toggle the UI")
