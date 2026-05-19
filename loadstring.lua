-- Server Hopper Loadstring
-- Execute with: loadstring(game:HttpGet("https://raw.githubusercontent.com/ominomin946-a11y/Hsush/main/loadstring.lua"))()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

local targets = {
    ["Garama"] = true,
    ["Madundung"] = true,
    ["Dragon Cannelloni"] = true
}

local function containsTarget()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if targets[obj.Name] then
            print("FOUND:", obj.Name)
            return true
        end
    end
    return false
end

task.wait(10)

if containsTarget() then
    print("Rare brainrot found.")
else
    print("No target found. Server hopping...")

    local response = game:HttpGet(
        "https://games.roblox.com/v1/games/" ..
        placeId ..
        "/servers/Public?sortOrder=Asc&limit=100"
    )

    local servers = HttpService:JSONDecode(response)

    for _, server in ipairs(servers.data) do
        if server.playing < server.maxPlayers
            and server.id ~= game.JobId then

            TeleportService:TeleportToPlaceInstance(
                placeId,
                server.id,
                player
            )

            break
        end
    end
end
