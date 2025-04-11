-- Roblox ESP Cheat with white outlines and green filling
-- This script creates an outline around player characters

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ESP Configuration
local ESP = {
    Enabled = true,
    OutlineColor = Color3.new(1, 1, 1), -- White outline
    FillColor = Color3.new(0, 1, 0), -- Green fill
    Transparency = 0.5,
    OutlineThickness = 2,
    TeamCheck = false -- Set to true if you want to exclude teammates
}

-- Create ESP container
local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPContainer"
ESPContainer.Parent = game.CoreGui

-- Function to create ESP for a player
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = ESPContainer
    
    -- Create highlight effect (outline around character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = ESP.FillColor
    highlight.OutlineColor = ESP.OutlineColor
    highlight.FillTransparency = ESP.Transparency
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder
    
    -- Update ESP
    local function UpdateESP()
        if not ESP.Enabled then
            highlight.Enabled = false
            return
        end
        
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            highlight.Enabled = false
            return
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            highlight.Enabled = false
            return
        end
        
        -- Team check
        if ESP.TeamCheck and player.Team == LocalPlayer.Team then
            highlight.Enabled = false
            return
        end
        
        -- Update the highlight's parent to the character
        highlight.Enabled = true
        highlight.Adornee = character
    end
    
    -- Connect update function
    local connection = RunService.RenderStepped:Connect(UpdateESP)
    
    -- Clean up when player leaves
    player.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            espFolder:Destroy()
            connection:Disconnect()
        end
    end)
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Set up ESP for players who join later
Players.PlayerAdded:Connect(CreateESP)

-- Toggle ESP function (you can bind this to a key)
local function ToggleESP()
    ESP.Enabled = not ESP.Enabled
end

-- Example keybind (uncomment to use)
-- local UserInputService = game:GetService("UserInputService")
-- UserInputService.InputBegan:Connect(function(input, gameProcessed)
--     if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
--         ToggleESP()
--     end
-- end)

print("ESP Cheat loaded successfully!")

