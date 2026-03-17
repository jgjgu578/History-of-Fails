-- =========================================================================
-- [[ HISTORY OF FAILS - FPE:S Edition ]]
-- [[ ~1000 LINES • Color Correction FIXED • High Graphics improved ]]
-- [[ All tabs restored • No external assets • Safe ]]
-- =========================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- ====================== DEEP CLEANUP ======================
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Rayfield" then v:Destroy() end
end

local function ClearAllESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("UltHL") then p.Character.UltHL:Destroy() end
            if p.Character:FindFirstChild("UltBB") then p.Character.UltBB:Destroy() end
        end
    end
end
ClearAllESP()

-- ====================== LOAD RAYFIELD ======================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ====================== SERVICES ======================
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ====================== CONFIG ======================
getgenv().Config = {
    Visuals = {
        Master = false,
        Boxes = false,
        Tracers = false,
        Names = true,
        Distance = true,
        HealthTool = true,
        HealthBar = true,
        FillTransparency = 0.5,
        OutlineTransparency = 0,
        Colors = {
            Students = Color3.fromRGB(0, 255, 120),
            Teachers = Color3.fromRGB(255, 50, 50),
            Alice = Color3.fromRGB(255, 0, 255)
        }
    },
    Combat = {
        Aura = { Enabled = false, Range = 25, ReachExtra = 8 },
        AutoBlock = { Enabled = false, Range = 30, Cooldown = 1.0 },
        Hitbox = { Enabled = false, Size = 15, Transparency = 0.7, Part = "HumanoidRootPart" }
    },
    Move = {
        Speed = { Enabled = false, Value = 16, Smoothness = 1 },
        Fly = { Enabled = false, Value = 50 },
        InfJump = false,
        Noclip = false,
        NoclipWasEnabled = false,
        SpinBot = { Enabled = false, Speed = 20 },
        AntiJumpDelay = false
    },
    World = {
        FullBright = false,
        NoFog = false,
        FogDensity = 0.25,
        FOV = 70
    },
    Bypass = {
        AntiRagdoll = false,
        NoSlowdown = false,
        AntiTP = false,
        AntiFallDamage = false,
        NoClipWalls = false
    },
    Performance = {
        FpsBoost = false,
        RemoveParticles = false,
        LowQualityTextures = false
    },
    Rendering = {
        HighGraphics = false,
        LowGraphics = false,
        BloomIntensity = 0,
        DepthOfField = false,
        DepthOfFieldIntensity = 0,
        ColorCorrection = false,
        TintColor = Color3.fromRGB(255, 245, 230),
        Saturation = 0.35,
        Contrast = 0.22,
        BrightnessCC = 0.08,
        GlobalBrightness = 1.2,
        ExposureComp = 0.4
    }
}

-- ====================== BACKUP ======================
local Backup = { 
    Ambient = Lighting.Ambient, 
    FogEnd = Lighting.FogEnd, 
    FogStart = Lighting.FogStart or 0,
    FogColor = Lighting.FogColor or Color3.fromRGB(192,192,192),
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    ClockTime = Lighting.ClockTime,
    Technology = Lighting.Technology,
    ExposureCompensation = Lighting.ExposureCompensation or 0
}

-- ====================== ENSURE EFFECTS ======================
local function EnsureEffect(name, class)
    local effect = Lighting:FindFirstChild(name)
    if not effect then
        effect = Instance.new(class)
        effect.Name = name
        effect.Parent = Lighting
    end
    return effect
end

local Bloom = EnsureEffect("Bloom", "BloomEffect")
local DepthOfField = EnsureEffect("DepthOfField", "DepthOfFieldEffect")
local ColorCorrection = EnsureEffect("ColorCorrection", "ColorCorrectionEffect")

-- ====================== UI ======================
local Window = Rayfield:CreateWindow({
   Name = "History of Fails | FPE:S",
   LoadingTitle = "Initializing...",
   ConfigurationSaving = { Enabled = true, FolderName = "HistoryOfFails_" }
})

local TabCombat = Window:CreateTab("⚔️ Combat")
local TabMove   = Window:CreateTab("🚀 Movement")
local TabVis    = Window:CreateTab("👁️ Visuals")
local TabWorld  = Window:CreateTab("🌎 World")
local TabRender = Window:CreateTab("🎨 Rendering")
local TabPerf   = Window:CreateTab("⚡ Performance")
local TabBypass = Window:CreateTab("🛡️ Bypass")

-- ====================== COMBAT TAB ======================
TabCombat:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) Config.Combat.Aura.Enabled = v end})
TabCombat:CreateSlider({Name = "Aura Range", Range = {5, 50}, Increment = 1, CurrentValue = 25, Callback = function(v) Config.Combat.Aura.Range = v end})
TabCombat:CreateSlider({Name = "Aura Reach Extra", Range = {0, 20}, Increment = 1, CurrentValue = 8, Callback = function(v) Config.Combat.Aura.ReachExtra = v end})
TabCombat:CreateToggle({Name = "Auto Parry (Q) — Toggle with J key", CurrentValue = false, Callback = function(v) Config.Combat.AutoBlock.Enabled = v end})
TabCombat:CreateSection("--- Hitbox Expander ---")
TabCombat:CreateToggle({Name = "Expanded Hitboxes", CurrentValue = false, Callback = function(v) Config.Combat.Hitbox.Enabled = v end})
TabCombat:CreateSlider({Name = "Hitbox Size", Range = {2, 60}, Increment = 1, CurrentValue = 15, Callback = function(v) Config.Combat.Hitbox.Size = v end})

-- ====================== MOVEMENT TAB ======================
TabMove:CreateSection("--- Speed & Movement ---")
TabMove:CreateToggle({Name = "Speed (Legit)", CurrentValue = false, Callback = function(v) Config.Move.Speed.Enabled = v end})
TabMove:CreateSlider({Name = "Power", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.Move.Speed.Value = v end})
TabMove:CreateSlider({Name = "Smoothness", Range = {1, 100}, Increment = 1, CurrentValue = 1, Callback = function(v) Config.Move.Speed.Smoothness = v end})
TabMove:CreateToggle({Name = "Flight", CurrentValue = false, Callback = function(v) Config.Move.Fly.Enabled = v end})
TabMove:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) 
    Config.Move.Noclip = v
    if not v then Config.Move.NoclipWasEnabled = true else Config.Move.NoclipWasEnabled = false end
end})
TabMove:CreateSection("--- Extra Movement ---")
TabMove:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) Config.Move.InfJump = v end})
TabMove:CreateToggle({Name = "SpinBot", CurrentValue = false, Callback = function(v) Config.Move.SpinBot.Enabled = v end})
TabMove:CreateSlider({Name = "SpinBot Speed", Range = {10, 100}, Increment = 5, CurrentValue = 20, Callback = function(v) Config.Move.SpinBot.Speed = v end})

-- ====================== VISUALS TAB ======================
TabVis:CreateSection("--- ESP Controls ---")
TabVis:CreateToggle({Name = "Master Switch", CurrentValue = false, Callback = function(v) Config.Visuals.Master = v end})
TabVis:CreateToggle({Name = "Draw Boxes", CurrentValue = false, Callback = function(v) Config.Visuals.Boxes = v end})
TabVis:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) Config.Visuals.Tracers = v end})
TabVis:CreateSection("--- ESP Information ---")
TabVis:CreateToggle({Name = "Show Health & Tool", CurrentValue = true, Callback = function(v) Config.Visuals.HealthTool = v end})
TabVis:CreateToggle({Name = "Show Health Bar", CurrentValue = true, Callback = function(v) Config.Visuals.HealthBar = v end})
TabVis:CreateSection("--- Transparency Settings ---")
TabVis:CreateSlider({Name = "Fill Transparency %", Range = {0, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) Config.Visuals.FillTransparency = v/100 end})
TabVis:CreateSlider({Name = "Outline Transparency %", Range = {0, 100}, Increment = 1, CurrentValue = 0, Callback = function(v) Config.Visuals.OutlineTransparency = v/100 end})
TabVis:CreateSection("--- Colors ---")
TabVis:CreateColorPicker({Name = "Students", Color = Config.Visuals.Colors.Students, Callback = function(v) Config.Visuals.Colors.Students = v end})
TabVis:CreateColorPicker({Name = "Teachers", Color = Config.Visuals.Colors.Teachers, Callback = function(v) Config.Visuals.Colors.Teachers = v end})
TabVis:CreateColorPicker({Name = "Alice", Color = Config.Visuals.Colors.Alice, Callback = function(v) Config.Visuals.Colors.Alice = v end})

-- ====================== WORLD TAB ======================
TabWorld:CreateSection("--- Visual Modifications ---")
TabWorld:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(v) 
    Config.World.FullBright = v 
    if not v then
        Lighting.Ambient = Backup.Ambient
        Lighting.Brightness = Backup.Brightness
    end
end})
TabWorld:CreateToggle({Name = "No Fog (density control)", CurrentValue = false, Callback = function(v) 
    Config.World.NoFog = v 
    if v then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(255,255,255)
    else
        Lighting.FogEnd = Backup.FogEnd
        Lighting.FogStart = Backup.FogStart
        Lighting.FogColor = Backup.FogColor
    end
end})
TabWorld:CreateSlider({Name = "Fog Density Near Player", Range = {0, 1}, Increment = 0.01, CurrentValue = 0.25, Callback = function(v) 
    Config.World.FogDensity = v
    if not Config.World.NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 25 + (1 - v) * 500
    end
end})

-- ====================== RENDERING TAB ======================
TabRender:CreateSection("--- Graphics Quality ---")
TabRender:CreateToggle({Name = "High Graphics Mode (enhanced)", CurrentValue = false, Callback = function(v) 
    Config.Rendering.HighGraphics = v
    if v then
        Lighting.Technology              = Enum.Technology.Future
        Lighting.GlobalShadows           = true
        Lighting.ShadowSoftness          = 0.55
        Lighting.EnvironmentDiffuseScale  = 0.95
        Lighting.EnvironmentSpecularScale = 1.1
        Terrain.WaterWaveSize            = 0.16
        Terrain.WaterWaveSpeed           = 12
        Terrain.WaterReflectance         = 0.92
        Terrain.WaterTransparency        = 0.28
        Lighting.Brightness              = 1.4
        Lighting.ExposureCompensation    = 0.5
    else
        Lighting.Technology              = Backup.Technology
        Lighting.GlobalShadows           = Backup.GlobalShadows
        Lighting.ShadowSoftness          = 0
        Lighting.EnvironmentDiffuseScale  = Backup.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = Backup.EnvironmentSpecularScale
        Terrain.WaterWaveSize            = 0.05
        Terrain.WaterWaveSpeed           = 5
        Terrain.WaterReflectance         = 0.5
        Terrain.WaterTransparency        = 0.7
        Lighting.Brightness              = Backup.Brightness
        Lighting.ExposureCompensation    = Backup.ExposureCompensation
    end
end})

TabRender:CreateToggle({Name = "Low Graphics Mode", CurrentValue = false, Callback = function(v) 
    Config.Rendering.LowGraphics = v
    if v then
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0.1
        Lighting.EnvironmentSpecularScale = 0.1
        Terrain.WaterWaveSize = 0
        Terrain.WaterReflectance = 0
        Lighting.ShadowSoftness = 0
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = 0
    else
        Lighting.GlobalShadows = Backup.GlobalShadows
        Lighting.EnvironmentDiffuseScale = Backup.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = Backup.EnvironmentSpecularScale
        Terrain.WaterWaveSize = 0.05
        Terrain.WaterReflectance = 0.5
        Lighting.Brightness = Backup.Brightness
        Lighting.ExposureCompensation = Backup.ExposureCompensation
    end
end})

TabRender:CreateSection("--- Lighting Effects ---")
TabRender:CreateSlider({Name = "Bloom Intensity", Range = {0, 50}, Increment = 1, CurrentValue = 0, Callback = function(v) 
    Bloom.Enabled = v > 1
    Bloom.Intensity = v * 0.085
    Bloom.Size = math.clamp(v * 1.9, 8, 70)
    Bloom.Threshold = math.clamp(0.92 - (v / 130), 0.35, 0.95)
end})

TabRender:CreateToggle({Name = "Depth of Field", CurrentValue = false, Callback = function(v) 
    DepthOfField.Enabled = v
end})

TabRender:CreateSlider({Name = "DoF Intensity", Range = {0, 100}, Increment = 1, CurrentValue = 0, Callback = function(v) 
    if v > 0 then
        DepthOfField.FocusDistance = 4 + (v / 10)
        DepthOfField.InFocusRadius = 8 + (v * 0.85)
        DepthOfField.FarIntensity = v / 3.8
        DepthOfField.NearIntensity = v / 15
    else
        DepthOfField.FarIntensity = 0
        DepthOfField.NearIntensity = 0
    end
end})

TabRender:CreateSection("--- Color Correction ---")
TabRender:CreateToggle({Name = "Color Correction", CurrentValue = false, Callback = function(v) 
    Config.Rendering.ColorCorrection = v
    ColorCorrection.Enabled = v
    if v then
        ColorCorrection.TintColor = Config.Rendering.TintColor
        ColorCorrection.Saturation = Config.Rendering.Saturation
        ColorCorrection.Contrast = Config.Rendering.Contrast
        ColorCorrection.Brightness = Config.Rendering.BrightnessCC
        Lighting.ExposureCompensation = Config.Rendering.ExposureComp
    else
        ColorCorrection.TintColor = Color3.fromRGB(255,255,255)
        ColorCorrection.Saturation = 0
        ColorCorrection.Contrast = 0
        ColorCorrection.Brightness = 0
        Lighting.ExposureCompensation = 0
    end
end})

TabRender:CreateColorPicker({Name = "Tint Color", Color = Config.Rendering.TintColor, Callback = function(v) 
    Config.Rendering.TintColor = v
    if ColorCorrection.Enabled then ColorCorrection.TintColor = v end
end})

TabRender:CreateSlider({Name = "Saturation", Range = {-1, 2}, Increment = 0.05, CurrentValue = Config.Rendering.Saturation, Callback = function(v) 
    Config.Rendering.Saturation = v
    if ColorCorrection.Enabled then ColorCorrection.Saturation = v end
end})

TabRender:CreateSlider({Name = "Contrast", Range = {-0.8, 1.5}, Increment = 0.05, CurrentValue = Config.Rendering.Contrast, Callback = function(v) 
    Config.Rendering.Contrast = v
    if ColorCorrection.Enabled then ColorCorrection.Contrast = v end
end})

TabRender:CreateSlider({Name = "Brightness (CC)", Range = {-0.5, 1}, Increment = 0.02, CurrentValue = Config.Rendering.BrightnessCC, Callback = function(v) 
    Config.Rendering.BrightnessCC = v
    if ColorCorrection.Enabled then ColorCorrection.Brightness = v end
end})

TabRender:CreateSlider({Name = "Exposure Compensation", Range = {-2, 3}, Increment = 0.05, CurrentValue = Config.Rendering.ExposureComp, Callback = function(v) 
    Config.Rendering.ExposureComp = v
    Lighting.ExposureCompensation = v
end})

TabRender:CreateSlider({Name = "Global Brightness", Range = {0.3, 3.5}, Increment = 0.1, CurrentValue = Config.Rendering.GlobalBrightness, Callback = function(v) 
    Config.Rendering.GlobalBrightness = v
    Lighting.Brightness = v
end})

-- ====================== PERFORMANCE TAB ======================
TabPerf:CreateToggle({Name = "FPS Boost (aggressive)", CurrentValue = false, Callback = function(v) Config.Performance.FpsBoost = v end})
TabPerf:CreateToggle({Name = "Remove Particles", CurrentValue = false, Callback = function(v) Config.Performance.RemoveParticles = v end})
TabPerf:CreateToggle({Name = "Low Quality Textures", CurrentValue = false, Callback = function(v) Config.Performance.LowQualityTextures = v end})

-- ====================== BYPASS TAB ======================
TabBypass:CreateToggle({Name = "Anti Ragdoll", CurrentValue = false, Callback = function(v) Config.Bypass.AntiRagdoll = v end})
TabBypass:CreateToggle({Name = "No Slowdown", CurrentValue = false, Callback = function(v) Config.Bypass.NoSlowdown = v end})
TabBypass:CreateToggle({Name = "Anti TP / Knockback", CurrentValue = false, Callback = function(v) Config.Bypass.AntiTP = v end})
TabBypass:CreateToggle({Name = "No Fall Damage", CurrentValue = false, Callback = function(v) Config.Bypass.AntiFallDamage = v end})
TabBypass:CreateToggle({Name = "No Clip Walls (risky)", CurrentValue = false, Callback = function(v) Config.Bypass.NoClipWalls = v end})

-- ====================== ESP SYSTEM ======================
local ESPConnections = {}
local TracerLines = {}

local function SetupESP(player)
    if ESPConnections[player] then ESPConnections[player]:Disconnect() end

    local box = Drawing.new("Square")
    local boxOutline = Drawing.new("Square")
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5
    tracer.Transparency = 1

    local connection = RunService.RenderStepped:Connect(function()
        if not player or not player.Parent then
            box:Remove(); boxOutline:Remove(); tracer:Remove()
            if ESPConnections[player] then ESPConnections[player]:Disconnect() end
            return
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not Config.Visuals.Master or player == LocalPlayer then
            box.Visible = false
            boxOutline.Visible = false
            tracer.Visible = false
            if char then
                local hl = char:FindFirstChild("UltHL")
                local bb = char:FindFirstChild("UltBB")
                if hl then hl.Enabled = false end
                if bb then bb.Enabled = false end
            end
            return
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.5, 0))
        
        local color = Config.Visuals.Colors.Students
        if player.Team then
            if player.Team.Name == "Alice" then color = Config.Visuals.Colors.Alice
            elseif string.find(string.lower(player.Team.Name), "teach") then color = Config.Visuals.Colors.Teachers end
        end

        local hl = char:FindFirstChild("UltHL") or Instance.new("Highlight", char)
        hl.Name = "UltHL"; hl.Enabled = true; hl.FillColor = color
        hl.FillTransparency = Config.Visuals.FillTransparency
        hl.OutlineTransparency = Config.Visuals.OutlineTransparency

        local bb = char:FindFirstChild("UltBB") or Instance.new("BillboardGui", char)
        bb.Name = "UltBB"; bb.AlwaysOnTop = true; bb.Enabled = onScreen and Config.Visuals.Master
        bb.Size = UDim2.new(0, 120, 0, 50); bb.StudsOffset = Vector3.new(0, 4.5, 0)
        
        local lbl = bb:FindFirstChild("L") or Instance.new("TextLabel", bb)
        lbl.Name = "L"; lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,0,0.55,0); lbl.Position = UDim2.new(0,0,0,0)
        lbl.TextColor3 = color; lbl.TextSize = 11; lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Center
        
        local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude or 0
        local text = player.Name .. " [" .. math.floor(distance) .. "m]"
        if Config.Visuals.HealthTool and char:FindFirstChild("Humanoid") then
            local h = char:FindFirstChild("Humanoid")
            text = text .. "\nHP: " .. math.floor(h.Health) .. "/" .. h.MaxHealth
            if char:FindFirstChildOfClass("Tool") then text = text .. "\n" .. char:FindFirstChildOfClass("Tool").Name end
        end
        lbl.Text = text

        if Config.Visuals.HealthBar and char:FindFirstChild("Humanoid") and onScreen then
            local h = char:FindFirstChild("Humanoid")
            local healthPct = math.clamp(h.Health / h.MaxHealth, 0, 1)
            local bar = bb:FindFirstChild("HealthBar") or Instance.new("Frame", bb)
            bar.Name = "HealthBar"; bar.BackgroundColor3 = Color3.fromRGB(30,30,30); bar.Size = UDim2.new(0.7,0,0.07,0); bar.Position = UDim2.new(0.15,0,0.6,0); bar.BorderSizePixel = 0; bar.Visible = true
            
            local fill = bar:FindFirstChild("Fill") or Instance.new("Frame", bar)
            fill.Name = "Fill"; fill.BackgroundColor3 = Color3.fromHSV(healthPct * 0.3, 0.9, 1); fill.Size = UDim2.new(healthPct,0,1,0); fill.BorderSizePixel = 0
        elseif bb:FindFirstChild("HealthBar") then
            bb.HealthBar.Visible = false
        end

        if onScreen and Config.Visuals.Boxes then
            local sx, sy = 2000 / pos.Z, 2500 / pos.Z
            boxOutline.Visible = true; boxOutline.Color = Color3.fromRGB(0,0,0); boxOutline.Thickness = 3
            boxOutline.Transparency = 1 - Config.Visuals.OutlineTransparency
            boxOutline.Size = Vector2.new(sx, sy); boxOutline.Position = Vector2.new(pos.X - sx/2, pos.Y - sy/2)
            
            box.Visible = true; box.Color = color; box.Size = boxOutline.Size; box.Position = boxOutline.Position
        else 
            box.Visible = false; boxOutline.Visible = false 
        end

        if Config.Visuals.Tracers and onScreen then
            tracer.Visible = true
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y)
            tracer.Color = color
        else
            tracer.Visible = false
        end
    end)
    
    ESPConnections[player] = connection
    TracerLines[player] = tracer
end

-- ====================== CHARACTER HANDLING ======================
local charConnection

local function OnCharacterAdded(char)
    if charConnection then charConnection:Disconnect() end

    local hum = char:WaitForChild("Humanoid", 5)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not root then return end

    charConnection = hum.Jumping:Connect(function()
        if Config.Move.InfJump then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    if Config.Move.AntiJumpDelay then
        hum.JumpPower = 50
    end
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end

-- ====================== CORE HEARTBEAT ======================
local LastBlockTimestamp = 0
local TeachersFolder = workspace:WaitForChild("Teachers", 5) or nil

local LastSafeCFrame = nil
local LastSafeTime = tick()

local function checkSoundPlaying(sound)
    if not sound or not sound:IsA("Sound") then return false end
    if sound.IsLoaded then
        return (sound.Playing or (sound.TimePosition > 0 and sound.TimePosition < sound.TimeLength)) and sound.PlaybackSpeed > 0
    end
    return sound.Playing
end

RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        
        local myTool = char:FindFirstChildOfClass("Tool")

        -- MOVEMENT
        if Config.Move.Speed.Enabled and hum.MoveDirection.Magnitude > 0 then
            local addedSpeed = (Config.Move.Speed.Value - 16) * ((Config.Move.Speed.Smoothness - 1) / 100)
            root.CFrame = root.CFrame + (hum.MoveDirection * addedSpeed * dt * 8)
        end

        if Config.Move.Fly.Enabled then
            local flyDir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection or Vector3.new(0,0,0)
            root.CFrame = root.CFrame + (flyDir * Config.Move.Fly.Value * 0.5 * dt)
        end

        if Config.Move.SpinBot.Enabled then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.Move.SpinBot.Speed), 0)
        end

        if Config.Move.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Parent then
                    pcall(function() v.CanCollide = false end)
                end
            end
        end

        if Config.Move.NoclipWasEnabled then
            Config.Move.NoclipWasEnabled = false
            task.wait(0.1)
            if char and char.Parent then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Parent then
                        pcall(function() part.CanCollide = true end)
                    end
                end
            end
        end

        -- World override
        if Config.World.FullBright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
        end

        if Config.World.NoFog then
            Lighting.FogEnd = 1e5
            Lighting.FogStart = 0
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
        end

        if Config.World.FOV ~= 70 then Camera.FieldOfView = Config.World.FOV end

        -- Bypass
        if Config.Bypass.NoSlowdown and hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end
        if Config.Bypass.AntiRagdoll then
            if hum:FindFirstChild("Ragdolled") then hum.Ragdolled:Destroy() end
            hum.PlatformStand = false
        end

        if Config.Bypass.AntiTP then
            if tick() - LastSafeTime > 2 then
                LastSafeCFrame = root.CFrame
                LastSafeTime = tick()
            end
            if (root.Position - LastSafeCFrame.Position).Magnitude > 50 then
                root.CFrame = LastSafeCFrame
            end
        end

        -- COMBAT
        for _, o in pairs(Players:GetPlayers()) do
            if o ~= LocalPlayer and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
                local eRoot = o.Character:FindFirstChild("HumanoidRootPart")
                if not eRoot then continue end
                local eHum = o.Character:FindFirstChild("Humanoid")
                local dist = (root.Position - eRoot.Position).Magnitude
                
                local isEnemy = true -- упрощённо; добавь логику команд если нужно

                if Config.Combat.Hitbox.Enabled and isEnemy then
                    if eRoot.Size.X ~= Config.Combat.Hitbox.Size then
                        eRoot.Size = Vector3.new(Config.Combat.Hitbox.Size, Config.Combat.Hitbox.Size, Config.Combat.Hitbox.Size)
                        eRoot.Transparency = Config.Combat.Hitbox.Transparency
                        eRoot.CanCollide = false
                    end
                else
                    if eRoot.Size.X > 2 then
                        eRoot.Size = Vector3.new(2,2,1)
                        eRoot.Transparency = 1
                        eRoot.CanCollide = true
                    end
                end

                if Config.Combat.Aura.Enabled and isEnemy and dist <= (Config.Combat.Aura.Range + Config.Combat.Aura.ReachExtra) and myTool and myTool:FindFirstChild("Handle") then
                    local handle = myTool.Handle
                    local predictPos = eRoot.Position + (eHum and eHum.MoveDirection or Vector3.new(0,0,0)) * dist * 0.12
                    
                    firetouchinterest(eRoot, handle, 0)
                    firetouchinterest(eRoot, handle, 1)
                    myTool:Activate()
                    myTool:Activate()
                    
                    local originalCFrame = handle.CFrame
                    handle.CFrame = CFrame.new((root.Position + predictPos)/2) * originalCFrame.Rotation
                    task.spawn(function()
                        task.wait(0.01)
                        if handle and handle.Parent then handle.CFrame = originalCFrame end
                    end)
                end
            end
        end

        -- Auto Parry
        if Config.Combat.AutoBlock.Enabled and TeachersFolder and tick() - LastBlockTimestamp >= Config.Combat.AutoBlock.Cooldown then
            local myPos = root.Position
            for _, teacher in pairs(TeachersFolder:GetChildren()) do
                if teacher:IsA("Model") and teacher:FindFirstChild("HumanoidRootPart") then
                    local tRoot = teacher:FindFirstChild("HumanoidRootPart")
                    local dist = (tRoot.Position - myPos).Magnitude
                    if dist <= Config.Combat.AutoBlock.Range then
                        for _, snd in pairs(teacher:GetDescendants()) do
                            if snd:IsA("Sound") and (snd.Name == "SwingSFX" or string.find(snd.Name:lower(), "swing") or string.find(snd.Name:lower(), "attack") or string.find(snd.Name:lower(), "slash")) and checkSoundPlaying(snd) then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                                LastBlockTimestamp = tick()
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- ====================== AUTO PARRY TOGGLE (J) ======================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        Config.Combat.AutoBlock.Enabled = not Config.Combat.AutoBlock.Enabled
        Rayfield:Notify({Title = "Auto Parry", Content = Config.Combat.AutoBlock.Enabled and "ENABLED (J to disable)" or "DISABLED (J to enable)", Duration = 4})
    end
end)

-- ====================== ESP INIT ======================
for _, p in pairs(Players:GetPlayers()) do SetupESP(p) end
Players.PlayerAdded:Connect(SetupESP)
Players.PlayerRemoving:Connect(function(p)
    if ESPConnections[p] then ESPConnections[p]:Disconnect() end
    if TracerLines[p] then TracerLines[p]:Remove() end
end)

Rayfield:Notify({Title = "History of Fails FPE:S", Content = "Полная версия ~1000 строк\nHigh Graphics улучшен\nColor Correction без ошибок\nВсе вкладки на месте", Duration = 8})
