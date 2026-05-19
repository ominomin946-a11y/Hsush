-- Dev Hub - Bot Hopper UI System
-- Execute with: loadstring(game:HttpGet("https://raw.githubusercontent.com/ominomin946-a11y/Hsush/main/bot_hopper.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Settings
local settings = {
    botCount = 3,
    autoJoin = true,
    autoHop = true,
    waitTime = 10
}

-- Stats
local stats = {
    activeBots = 0,
    hops = 0,
    targetsFound = 0,
    currentServer = game.JobId,
    lastUpdate = tick()
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BotHopperUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Floating Button (Circle Toggle)
local floatingButton = Instance.new("Frame")
floatingButton.Name = "FloatingButton"
floatingButton.Size = UDim2.new(0, 60, 0, 60)
floatingButton.Position = UDim2.new(1, -80, 1, -80)
floatingButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
floatingButton.BorderSizePixel = 0
floatingButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = floatingButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 200, 100)
buttonStroke.Thickness = 2
buttonStroke.Parent = floatingButton

local buttonIcon = Instance.new("TextLabel")
buttonIcon.Size = UDim2.new(1, 0, 1, 0)
buttonIcon.BackgroundTransparency = 1
buttonIcon.TextColor3 = Color3.fromRGB(20, 20, 20)
buttonIcon.TextSize = 28
buttonIcon.Font = Enum.Font.GothamBold
buttonIcon.Text = "⚡"
buttonIcon.Parent = floatingButton

-- Make floating button draggable
local buttonDragging = false
local buttonDragStart = nil
local buttonStartPos = nil

floatingButton.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        buttonDragging = true
        buttonDragStart = input.Position
        buttonStartPos = floatingButton.Position
    end
end)

floatingButton.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        buttonDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseMovement and buttonDragging and buttonDragStart and buttonStartPos then
        local delta = input.Position - buttonDragStart
        floatingButton.Position = UDim2.new(buttonStartPos.X.Scale, buttonStartPos.X.Offset + delta.X, buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + delta.Y)
    end
end)

floatingButton.MouseEnter:Connect(function()
    floatingButton.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
end)

floatingButton.MouseLeave:Connect(function()
    floatingButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Main Frame (Hidden by default)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 650)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
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

-- Title Bar with Dev Hub branding
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

-- Main Title: Dev Hub
local mainTitleLabel = Instance.new("TextLabel")
mainTitleLabel.Name = "MainTitle"
mainTitleLabel.Size = UDim2.new(1, -20, 0, 20)
mainTitleLabel.Position = UDim2.new(0, 10, 0, 5)
mainTitleLabel.BackgroundTransparency = 1
mainTitleLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
mainTitleLabel.TextSize = 18
mainTitleLabel.Font = Enum.Font.GothamBold
mainTitleLabel.Text = "DEV HUB"
mainTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
mainTitleLabel.Parent = titleBar

-- Subtitle: Bot Hopper
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -20, 0, 18)
subtitleLabel.Position = UDim2.new(0, 10, 0, 22)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
subtitleLabel.TextSize = 11
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "🤖 Bot Hopper"
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = titleBar

-- Close button (Circle X)
local closeButton = Instance.new("Frame")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeLabel = Instance.new("TextLabel")
closeLabel.Size = UDim2.new(1, 0, 1, 0)
closeLabel.BackgroundTransparency = 1
closeLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
closeLabel.TextSize = 20
closeLabel.Font = Enum.Font.GothamBold
closeLabel.Text = "✕"
closeLabel.Parent = closeButton

local closeClickDetector = Instance.new("TextButton")
closeClickDetector.Size = UDim2.new(1, 0, 1, 0)
closeClickDetector.BackgroundTransparency = 1
closeClickDetector.Text = ""
closeClickDetector.Parent = closeButton

closeClickDetector.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Dragging (from title bar)
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1100)
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

-- Section Title: Bot Settings
local botTitleLabel = Instance.new("TextLabel")
botTitleLabel.Name = "BotTitle"
botTitleLabel.Size = UDim2.new(1, -30, 0, 25)
botTitleLabel.Position = UDim2.new(0, 15, 0, 145)
botTitleLabel.BackgroundTransparency = 1
botTitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
botTitleLabel.TextSize = 16
botTitleLabel.Font = Enum.Font.GothamBold
botTitleLabel.Text = "🤖 BOT SETTINGS"
botTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
botTitleLabel.Parent = scrollFrame

-- Bot Count Setting
local botCountContainer = Instance.new("Frame")
botCountContainer.Name = "BotCountContainer"
botCountContainer.Size = UDim2.new(1, -30, 0, 45)
botCountContainer.Position = UDim2.new(0, 15, 0, 180)
botCountContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
botCountContainer.BorderSizePixel = 0
botCountContainer.Parent = scrollFrame

local botCountCorner = Instance.new("UICorner")
botCountCorner.CornerRadius = UDim.new(0, 8)
botCountCorner.Parent = botCountContainer

local botCountStroke = Instance.new("UIStroke")
botCountStroke.Color = Color3.fromRGB(255, 140, 0)
botCountStroke.Thickness = 1
botCountStroke.Parent = botCountContainer

local botCountLabel = Instance.new("TextLabel")
botCountLabel.Size = UDim2.new(0.6, 0, 1, 0)
botCountLabel.Position = UDim2.new(0, 12, 0, 0)
botCountLabel.BackgroundTransparency = 1
botCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
botCountLabel.TextSize = 14
botCountLabel.Font = Enum.Font.GothamBold
botCountLabel.Text = "Bot Count: 3"
botCountLabel.TextXAlignment = Enum.TextXAlignment.Left
botCountLabel.TextYAlignment = Enum.TextYAlignment.Center
botCountLabel.Parent = botCountContainer

local botCountUpButton = Instance.new("TextButton")
botCountUpButton.Name = "UpButton"
botCountUpButton.Size = UDim2.new(0, 30, 0, 25)
botCountUpButton.Position = UDim2.new(1, -80, 0.5, -12)
botCountUpButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
botCountUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
botCountUpButton.TextSize = 12
botCountUpButton.Font = Enum.Font.GothamBold
botCountUpButton.Text = "+"
botCountUpButton.BorderSizePixel = 0
botCountUpButton.Parent = botCountContainer

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 5)
upCorner.Parent = botCountUpButton

local botCountDownButton = Instance.new("TextButton")
botCountDownButton.Name = "DownButton"
botCountDownButton.Size = UDim2.new(0, 30, 0, 25)
botCountDownButton.Position = UDim2.new(1, -40, 0.5, -12)
botCountDownButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
botCountDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
botCountDownButton.TextSize = 12
botCountDownButton.Font = Enum.Font.GothamBold
botCountDownButton.Text = "-"
botCountDownButton.BorderSizePixel = 0
botCountDownButton.Parent = botCountContainer

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 5)
downCorner.Parent = botCountDownButton

botCountUpButton.MouseButton1Click:Connect(function()
    if settings.botCount < 10 then
        settings.botCount = settings.botCount + 1
        botCountLabel.Text = "Bot Count: " .. settings.botCount
    end
end)

botCountDownButton.MouseButton1Click:Connect(function()
    if settings.botCount > 1 then
        settings.botCount = settings.botCount - 1
        botCountLabel.Text = "Bot Count: " .. settings.botCount
    end
end)

-- Auto Join Toggle
local autoJoinContainer = Instance.new("Frame")
autoJoinContainer.Name = "AutoJoinContainer"
autoJoinContainer.Size = UDim2.new(1, -30, 0, 45)
autoJoinContainer.Position = UDim2.new(0, 15, 0, 235)
autoJoinContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoJoinContainer.BorderSizePixel = 0
autoJoinContainer.Parent = scrollFrame

local autoJoinCorner = Instance.new("UICorner")
autoJoinCorner.CornerRadius = UDim.new(0, 8)
autoJoinCorner.Parent = autoJoinContainer

local autoJoinStroke = Instance.new("UIStroke")
autoJoinStroke.Color = Color3.fromRGB(255, 140, 0)
autoJoinStroke.Thickness = 1
autoJoinStroke.Parent = autoJoinContainer

local autoJoinLabel = Instance.new("TextLabel")
autoJoinLabel.Size = UDim2.new(0.6, 0, 1, 0)
autoJoinLabel.Position = UDim2.new(0, 12, 0, 0)
autoJoinLabel.BackgroundTransparency = 1
autoJoinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoJoinLabel.TextSize = 14
autoJoinLabel.Font = Enum.Font.GothamBold
autoJoinLabel.Text = "Auto Join"
autoJoinLabel.TextXAlignment = Enum.TextXAlignment.Left
autoJoinLabel.TextYAlignment = Enum.TextYAlignment.Center
autoJoinLabel.Parent = autoJoinContainer

local autoJoinToggle = Instance.new("TextButton")
autoJoinToggle.Name = "Toggle"
autoJoinToggle.Size = UDim2.new(0, 45, 0, 25)
autoJoinToggle.Position = UDim2.new(1, -60, 0.5, -12)
autoJoinToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
autoJoinToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoJoinToggle.TextSize = 10
autoJoinToggle.Font = Enum.Font.GothamBold
autoJoinToggle.Text = "ON"
autoJoinToggle.BorderSizePixel = 0
autoJoinToggle.Parent = autoJoinContainer

local joinToggleCorner = Instance.new("UICorner")
joinToggleCorner.CornerRadius = UDim.new(0, 5)
joinToggleCorner.Parent = autoJoinToggle

autoJoinToggle.MouseButton1Click:Connect(function()
    settings.autoJoin = not settings.autoJoin
    autoJoinToggle.Text = settings.autoJoin and "ON" or "OFF"
    autoJoinToggle.BackgroundColor3 = settings.autoJoin and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(150, 50, 50)
end)

-- Launch Bots Button
local launchButton = Instance.new("TextButton")
launchButton.Name = "LaunchButton"
launchButton.Size = UDim2.new(1, -30, 0, 45)
launchButton.Position = UDim2.new(0, 15, 0, 290)
launchButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
launchButton.TextColor3 = Color3.fromRGB(20, 20, 20)
launchButton.TextSize = 16
launchButton.Font = Enum.Font.GothamBold
launchButton.Text = "🚀 LAUNCH BOTS"
launchButton.BorderSizePixel = 0
launchButton.Parent = scrollFrame

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 10)
launchCorner.Parent = launchButton

launchButton.MouseButton1Click:Connect(function()
    launchButton.Text = "🔄 LAUNCHING..."
    launchButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    launchButton.Enabled = false
    stats.activeBots = settings.botCount
    task.wait(2)
    launchButton.Text = "🚀 LAUNCH BOTS"
    launchButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    launchButton.Enabled = true
end)

launchButton.MouseEnter:Connect(function()
    launchButton.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
end)

launchButton.MouseLeave:Connect(function()
    launchButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Section Title: Server Hopper
local hopTitleLabel = Instance.new("TextLabel")
hopTitleLabel.Name = "HopTitle"
hopTitleLabel.Size = UDim2.new(1, -30, 0, 25)
hopTitleLabel.Position = UDim2.new(0, 15, 0, 345)
hopTitleLabel.BackgroundTransparency = 1
hopTitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
hopTitleLabel.TextSize = 16
hopTitleLabel.Font = Enum.Font.GothamBold
hopTitleLabel.Text = "🌐 SERVER HOPPER"
hopTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
hopTitleLabel.Parent = scrollFrame

-- Auto Hop Toggle
local autoHopContainer = Instance.new("Frame")
autoHopContainer.Name = "AutoHopContainer"
autoHopContainer.Size = UDim2.new(1, -30, 0, 45)
autoHopContainer.Position = UDim2.new(0, 15, 0, 380)
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

local hopToggleCorner = Instance.new("UICorner")
hopToggleCorner.CornerRadius = UDim.new(0, 5)
hopToggleCorner.Parent = autoHopToggle

autoHopToggle.MouseButton1Click:Connect(function()
    settings.autoHop = not settings.autoHop
    autoHopToggle.Text = settings.autoHop and "ON" or "OFF"
    autoHopToggle.BackgroundColor3 = settings.autoHop and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(150, 50, 50)
end)

-- Hop Now Button
local hopButton = Instance.new("TextButton")
hopButton.Name = "HopButton"
hopButton.Size = UDim2.new(1, -30, 0, 45)
hopButton.Position = UDim2.new(0, 15, 0, 435)
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
    stats.hops = stats.hops + 1
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
resetButton.Position = UDim2.new(0, 15, 0, 490)
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
    stats.activeBots = 0
end)

resetButton.MouseEnter:Connect(function()
    resetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

resetButton.MouseLeave:Connect(function()
    resetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Toggle main frame when clicking floating button
floatingButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Also toggle with 'P' key
local uiVisible = false
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
        "🤖 ACTIVE BOTS\n%d\n\n🔄 HOPS\n%d\n\n🖥️ CURRENT SERVER\n%s",
        stats.activeBots,
        stats.hops,
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

print("✅ Dev Hub Bot Hopper Loaded!")
print("📌 Click the floating button or press 'P' to toggle the UI")
