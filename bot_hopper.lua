-- Dev Hub - Advanced Bot Hopper UI System
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
    waitTime = 10,
    targets = {
        ["Garama"] = true,
        ["Madundung"] = true,
        ["Dragon Cannelloni"] = true
    }
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

-- Main Frame - Dashboard with Sidebar
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0, 20, 1, -620)
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

-- Left Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 15)
sidebarCorner.Parent = sidebar

-- Sidebar Title
local sidebarTitle = Instance.new("TextLabel")
sidebarTitle.Size = UDim2.new(1, 0, 0, 50)
sidebarTitle.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
sidebarTitle.TextColor3 = Color3.fromRGB(20, 20, 20)
sidebarTitle.TextSize = 14
sidebarTitle.Font = Enum.Font.GothamBold
sidebarTitle.Text = "DEV HUB"
sidebarTitle.BorderSizePixel = 0
sidebarTitle.Parent = sidebar

local sidebarTitleCorner = Instance.new("UICorner")
sidebarTitleCorner.CornerRadius = UDim.new(0, 15)
sidebarTitleCorner.Parent = sidebarTitle

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
closeButton.TextColor3 = Color3.fromRGB(20, 20, 20)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

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

-- Main content area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -150, 1, 0)
contentFrame.Position = UDim2.new(0, 150, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 15)
contentPadding.PaddingRight = UDim.new(0, 15)
contentPadding.PaddingTop = UDim.new(0, 15)
contentPadding.PaddingBottom = UDim.new(0, 15)
contentPadding.Parent = contentFrame

-- Create navigation buttons
local navButtons = {}
local pages = {}
local currentPage = 1

local function createNavButton(name, index, icon)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, 60 + (index - 1) * 60)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 140, 0)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = icon .. "\n" .. name
    btn.BorderSizePixel = 0
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 140, 0)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    return btn
end

local finderBtn = createNavButton("FINDER", 1, "🔍")
local settingsBtn = createNavButton("SETTINGS", 2, "⚙️")
local statsBtn = createNavButton("STATS", 3, "📊")
local hopBtn = createNavButton("HOP", 4, "🔄")

-- Create pages
local function createPage()
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = contentFrame
    return page
end

-- PAGE 1: SERVER FINDER
pages[1] = createPage()
pages[1].Visible = true

local finderScroll = Instance.new("ScrollingFrame")
finderScroll.Size = UDim2.new(1, 0, 1, 0)
finderScroll.BackgroundTransparency = 1
finderScroll.ScrollBarThickness = 4
finderScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
finderScroll.CanvasSize = UDim2.new(0, 0, 0, 250)
finderScroll.Parent = pages[1]

for targetName, _ in pairs(settings.targets) do
    local targetCard = Instance.new("Frame")
    targetCard.Size = UDim2.new(1, 0, 0, 70)
    targetCard.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    targetCard.BorderSizePixel = 0
    targetCard.Parent = finderScroll

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = targetCard

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(255, 140, 0)
    cardStroke.Thickness = 1
    cardStroke.Parent = targetCard

    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0.5, 0, 1, 0)
    targetLabel.Position = UDim2.new(0, 10, 0, 0)
    targetLabel.BackgroundTransparency = 1
    targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetLabel.TextSize = 14
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.Text = targetName
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.TextYAlignment = Enum.TextYAlignment.Center
    targetLabel.Parent = targetCard

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 50, 0, 28)
    joinBtn.Position = UDim2.new(1, -115, 0.5, -14)
    joinBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.TextSize = 11
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.Text = "JOIN"
    joinBtn.BorderSizePixel = 0
    joinBtn.Parent = targetCard

    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 5)
    joinCorner.Parent = joinBtn

    local forceBtn = Instance.new("TextButton")
    forceBtn.Size = UDim2.new(0, 50, 0, 28)
    forceBtn.Position = UDim2.new(1, -55, 0.5, -14)
    forceBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    forceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    forceBtn.TextSize = 11
    forceBtn.Font = Enum.Font.GothamBold
    forceBtn.Text = "FORCE"
    forceBtn.BorderSizePixel = 0
    forceBtn.Parent = targetCard

    local forceCorner = Instance.new("UICorner")
    forceCorner.CornerRadius = UDim.new(0, 5)
    forceCorner.Parent = forceBtn

    joinBtn.MouseButton1Click:Connect(function()
        joinBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
        joinBtn.Text = "..."
        joinBtn.Enabled = false
        stats.hops = stats.hops + 1
        task.wait(2)
        joinBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        joinBtn.Text = "JOIN"
        joinBtn.Enabled = true
    end)

    forceBtn.MouseButton1Click:Connect(function()
        forceBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        forceBtn.Text = "..."
        forceBtn.Enabled = false
        stats.hops = stats.hops + 1
        task.wait(2)
        forceBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        forceBtn.Text = "FORCE"
        forceBtn.Enabled = true
    end)

    joinBtn.MouseEnter:Connect(function()
        joinBtn.BackgroundColor3 = Color3.fromRGB(120, 170, 255)
    end)

    joinBtn.MouseLeave:Connect(function()
        joinBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    end)

    forceBtn.MouseEnter:Connect(function()
        forceBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
    end)

    forceBtn.MouseLeave:Connect(function()
        forceBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end)
end

-- PAGE 2: SETTINGS
pages[2] = createPage()

local botCountLabel = Instance.new("TextLabel")
botCountLabel.Size = UDim2.new(1, 0, 0, 30)
botCountLabel.Position = UDim2.new(0, 0, 0, 10)
botCountLabel.BackgroundTransparency = 1
botCountLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
botCountLabel.TextSize = 14
botCountLabel.Font = Enum.Font.GothamBold
botCountLabel.Text = "Bot Count: 3"
botCountLabel.TextXAlignment = Enum.TextXAlignment.Left
botCountLabel.Parent = pages[2]

local botCountUpBtn = Instance.new("TextButton")
botCountUpBtn.Size = UDim2.new(0, 40, 0, 30)
botCountUpBtn.Position = UDim2.new(0, 0, 0, 50)
botCountUpBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
botCountUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
botCountUpBtn.TextSize = 14
botCountUpBtn.Font = Enum.Font.GothamBold
botCountUpBtn.Text = "+"
botCountUpBtn.BorderSizePixel = 0
botCountUpBtn.Parent = pages[2]

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 5)
upCorner.Parent = botCountUpBtn

local botCountDownBtn = Instance.new("TextButton")
botCountDownBtn.Size = UDim2.new(0, 40, 0, 30)
botCountDownBtn.Position = UDim2.new(0, 50, 0, 50)
botCountDownBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
botCountDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
botCountDownBtn.TextSize = 14
botCountDownBtn.Font = Enum.Font.GothamBold
botCountDownBtn.Text = "-"
botCountDownBtn.BorderSizePixel = 0
botCountDownBtn.Parent = pages[2]

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 5)
downCorner.Parent = botCountDownBtn

botCountUpBtn.MouseButton1Click:Connect(function()
    if settings.botCount < 10 then
        settings.botCount = settings.botCount + 1
        botCountLabel.Text = "Bot Count: " .. settings.botCount
    end
end)

botCountDownBtn.MouseButton1Click:Connect(function()
    if settings.botCount > 1 then
        settings.botCount = settings.botCount - 1
        botCountLabel.Text = "Bot Count: " .. settings.botCount
    end
end)

local launchBtn = Instance.new("TextButton")
launchBtn.Size = UDim2.new(1, 0, 0, 50)
launchBtn.Position = UDim2.new(0, 0, 0, 100)
launchBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
launchBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
launchBtn.TextSize = 14
launchBtn.Font = Enum.Font.GothamBold
launchBtn.Text = "🚀 LAUNCH BOTS"
launchBtn.BorderSizePixel = 0
launchBtn.Parent = pages[2]

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 8)
launchCorner.Parent = launchBtn

launchBtn.MouseButton1Click:Connect(function()
    launchBtn.Text = "🔄 LAUNCHING..."
    launchBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    launchBtn.Enabled = false
    stats.activeBots = settings.botCount
    task.wait(2)
    launchBtn.Text = "🚀 LAUNCH BOTS"
    launchBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    launchBtn.Enabled = true
end)

launchBtn.MouseEnter:Connect(function()
    launchBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
end)

launchBtn.MouseLeave:Connect(function()
    launchBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- PAGE 3: STATISTICS
pages[3] = createPage()

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, 0, 1, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = pages[3]

-- PAGE 4: HOP
pages[4] = createPage()

local hopLabel = Instance.new("TextLabel")
hopLabel.Size = UDim2.new(1, 0, 0, 30)
hopLabel.Position = UDim2.new(0, 0, 0, 10)
hopLabel.BackgroundTransparency = 1
hopLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
hopLabel.TextSize = 14
hopLabel.Font = Enum.Font.GothamBold
hopLabel.Text = "Server Hopper"
hopLabel.TextXAlignment = Enum.TextXAlignment.Left
hopLabel.Parent = pages[4]

local hopNowBtn = Instance.new("TextButton")
hopNowBtn.Size = UDim2.new(1, 0, 0, 50)
hopNowBtn.Position = UDim2.new(0, 0, 0, 60)
hopNowBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
hopNowBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
hopNowBtn.TextSize = 14
hopNowBtn.Font = Enum.Font.GothamBold
hopNowBtn.Text = "🔄 HOP NOW"
hopNowBtn.BorderSizePixel = 0
hopNowBtn.Parent = pages[4]

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 8)
hopCorner.Parent = hopNowBtn

hopNowBtn.MouseButton1Click:Connect(function()
    hopNowBtn.Text = "⏳ HOPPING..."
    hopNowBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    hopNowBtn.Enabled = false
    stats.hops = stats.hops + 1
    task.wait(2)
    hopNowBtn.Text = "🔄 HOP NOW"
    hopNowBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    hopNowBtn.Enabled = true
end)

hopNowBtn.MouseEnter:Connect(function()
    hopNowBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
end)

hopNowBtn.MouseLeave:Connect(function()
    hopNowBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Navigation button handlers
local function showPage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
    end
    currentPage = index
end

finderBtn.MouseButton1Click:Connect(function()
    showPage(1)
    finderBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    finderBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    settingsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    statsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    statsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    hopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    hopBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
end)

settingsBtn.MouseButton1Click:Connect(function()
    showPage(2)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    settingsBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    finderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    finderBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    statsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    statsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    hopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    hopBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
end)

statsBtn.MouseButton1Click:Connect(function()
    showPage(3)
    statsBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    statsBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    finderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    finderBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    settingsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    hopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    hopBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
end)

hopBtn.MouseButton1Click:Connect(function()
    showPage(4)
    hopBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    hopBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    finderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    finderBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    settingsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
    statsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    statsBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
end)

-- Set initial button state
finderBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
finderBtn.TextColor3 = Color3.fromRGB(20, 20, 20)

-- Toggle UI with 'P' key
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
        "🤖 ACTIVE BOTS\n%d\n\n🔄 TOTAL HOPS\n%d\n\n🖥️ CURRENT SERVER\n%s",
        stats.activeBots,
        stats.hops,
        string.sub(stats.currentServer, 1, 8) .. "..."
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
print("📌 Press 'P' to toggle the UI")
