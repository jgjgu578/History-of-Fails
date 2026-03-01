-- =========================================================================
-- [[ PROJECT: HISTORY OF FAILS (ULTIMATE) ]]
-- [[ FIX: ANTI-OVERLAP & CLEANUP SYSTEM ]]
-- =========================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- 1. DEEP CLEANUP (Remove everything: UI and world objects)
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
ClearAllESP() -- Clean on startup

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =========================================================================
-- // [ 1. CONFIGURATION ] //
-- =========================================================================
getgenv().Config = {
    Visuals = {
        Master = false,
        Boxes = false,
        Tracers = false,
        Names = true,
        Distance = true,
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
        Aura = { Enabled = false, Range = 25 },
        Hitbox = { Enabled = false, Size = 15, Transparency = 0.7, Part = "HumanoidRootPart" }
    },
    Move = {
        Speed = { Enabled = false, Value = 16, Smoothness = 1 }, -- 1/16 Logic
        Fly = { Enabled = false, Value = 50 },
        InfJump = false,
        Noclip = false,
        SpinBot = { Enabled = false, Speed = 20 },
        AntiJumpDelay = false
    },
    World = { FullBright = false, NoFog = false, FOV = 70 },
    Bypass = { AntiRagdoll = false, NoSlowdown = false }
}

local Lighting = game:GetService("Lighting")
local Backup = { Ambient = Lighting.Ambient, FogEnd = Lighting.FogEnd, Brightness = Lighting.Brightness }

-- =========================================================================
-- // [ 2. INTERFACE ] //
-- =========================================================================
local Window = Rayfield:CreateWindow({
   Name = "History of Fails | ULTIMATE",
   LoadingTitle = "Cleaning Environment...",
   ConfigurationSaving = { Enabled = true, FolderName = "HistoryOfFails_Ultimate" }
})

local TabCombat = Window:CreateTab("⚔️ Combat")
local TabMove   = Window:CreateTab("🚀 Movement")
local TabVis    = Window:CreateTab("👁️ Visuals")
local TabWorld  = Window:CreateTab("🌎 World")
local TabShield = Window:CreateTab("🛡️ Bypass")

-- [ ⚔️ COMBAT ]
TabCombat:CreateToggle({Name = "Enable Kill Aura", CurrentValue = false, Callback = function(v) Config.Combat.Aura.Enabled = v end})
TabCombat:CreateSlider({Name = "Aura Range", Range = {5, 50}, Increment = 1, CurrentValue = 25, Callback = function(v) Config.Combat.Aura.Range = v end})
TabCombat:CreateToggle({Name = "Enable Expanded Hitboxes", CurrentValue = false, Callback = function(v) Config.Combat.Hitbox.Enabled = v end})
TabCombat:CreateSlider({Name = "Hitbox Size", Range = {2, 60}, Increment = 1, CurrentValue = 15, Callback = function(v) Config.Combat.Hitbox.Size = v end})

-- [ 🚀 MOVEMENT ]
TabMove:CreateToggle({Name = "Speed (Legit)", CurrentValue = false, Callback = function(v) Config.Move.Speed.Enabled = v end})
TabMove:CreateSlider({Name = "Power", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.Move.Speed.Value = v end})
TabMove:CreateSlider({Name = "Smoothness", Range = {1, 100}, Increment = 1, CurrentValue = 1, Callback = function(v) Config.Move.Speed.Smoothness = v end})
TabMove:CreateToggle({Name = "Flight", CurrentValue = false, Callback = function(v) Config.Move.Fly.Enabled = v end})
TabMove:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Config.Move.Noclip = v end})

-- [ 👁️ VISUALS ]
TabVis:CreateSection("--- [ ESP CONTROLS ] ---")
TabVis:CreateToggle({Name = "Master Switch", CurrentValue = false, Callback = function(v) Config.Visuals.Master = v end})
TabVis:CreateToggle({Name = "Draw Boxes", CurrentValue = false, Callback = function(v) Config.Visuals.Boxes = v end})

TabVis:CreateSection("--- [ TRANSPARENCY ] ---")
TabVis:CreateSlider({Name = "Fill Transparency %", Range = {0, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) Config.Visuals.FillTransparency = v/100 end})
TabVis:CreateSlider({Name = "Outline Transparency %", Range = {0, 100}, Increment = 1, CurrentValue = 0, Callback = function(v) Config.Visuals.OutlineTransparency = v/100 end})

TabVis:CreateSection("--- [ COLORS ] ---")
TabVis:CreateColorPicker({Name = "Students", Color = Config.Visuals.Colors.Students, Callback = function(v) Config.Visuals.Colors.Students = v end})
TabVis:CreateColorPicker({Name = "Teachers", Color = Config.Visuals.Colors.Teachers, Callback = function(v) Config.Visuals.Colors.Teachers = v end})
TabVis:CreateColorPicker({Name = "Alice", Color = Config.Visuals.Colors.Alice, Callback = function(v) Config.Visuals.Colors.Alice = v end})

-- [ 🌎 WORLD & 🛡️ BYPASS ]
TabWorld:CreateToggle({Name = "FullBright", CurrentValue = false, Callback = function(v) Config.World.FullBright = v if not v then Lighting.Ambient = Backup.Ambient end end})
TabWorld:CreateToggle({Name = "Remove Fog", CurrentValue = false, Callback = function(v) Config.World.NoFog = v if not v then Lighting.FogEnd = Backup.FogEnd end end})
TabShield:CreateToggle({Name = "No Slowdown", CurrentValue = false, Callback = function(v) Config.Bypass.NoSlowdown = v end})
TabShield:CreateToggle({Name = "Anti-Ragdoll", CurrentValue = false, Callback = function(v) Config.Bypass.AntiRagdoll = v end})

-- =========================================================================
-- // [ 🔥 CORE ENGINE ] //
-- =========================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function SetupESP(p)
    local box = Drawing.new("Square")
    local boxOutline = Drawing.new("Square")
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        -- If player leaves - remove drawings and disconnect loop
        if not p.Parent then
            box:Remove(); boxOutline:Remove(); connection:Disconnect(); return 
        end

        local char = p.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not Config.Visuals.Master or p == LocalPlayer then
            box.Visible = false; boxOutline.Visible = false
            if char then
                if char:FindFirstChild("UltHL") then char.UltHL.Enabled = false end
                if char:FindFirstChild("UltBB") then char.UltBB.Enabled = false end
            end
            return
        end

        local root = char.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        
        -- Color selection
        local color = Config.Visuals.Colors.Students
        if p.Team then
            if p.Team.Name == "АЛИСА" or p.Team.Name == "Alice" then color = Config.Visuals.Colors.Alice
            elseif string.find(string.lower(p.Team.Name), "teach") then color = Config.Visuals.Colors.Teachers end
        end

        -- STRICT CHECK TO PREVENT OVERLAPPING
        local hl = char:FindFirstChild("UltHL") or Instance.new("Highlight", char)
        hl.Name = "UltHL"; hl.Enabled = true; hl.FillColor = color
        hl.FillTransparency = Config.Visuals.FillTransparency
        hl.OutlineTransparency = Config.Visuals.OutlineTransparency

        local bb = char:FindFirstChild("UltBB") or Instance.new("BillboardGui", char)
        bb.Name = "UltBB"; bb.AlwaysOnTop = true; bb.Enabled = true; bb.Size = UDim2.new(0,100,0,40); bb.StudsOffset = Vector3.new(0,3.5,0)
        
        local lbl = bb:FindFirstChild("L") or Instance.new("TextLabel", bb)
        lbl.Name = "L"; lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,0,1,0); lbl.TextColor3 = color; lbl.TextSize = 12; lbl.Font = Enum.Font.GothamBold
        lbl.Text = p.Name .. " [" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) .. "m]"

        -- 2D Boxes
        if onScreen and Config.Visuals.Boxes then
            local sx, sy = 2000/pos.Z, 2500/pos.Z
            boxOutline.Visible = true; boxOutline.Color = Color3.fromRGB(0,0,0); boxOutline.Thickness = 3
            boxOutline.Transparency = 1 - Config.Visuals.OutlineTransparency
            boxOutline.Size = Vector2.new(sx, sy); boxOutline.Position = Vector2.new(pos.X - sx/2, pos.Y - sy/2)
            
            box.Visible = true; box.Color = color; box.Size = boxOutline.Size; box.Position = boxOutline.Position
        else box.Visible = false; boxOutline.Visible = false end
    end)
end

-- HEARTBEAT CYCLE
RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char.Humanoid
        local root = char.HumanoidRootPart

        -- SPEED (1/16)
        if Config.Move.Speed.Enabled and hum.MoveDirection.Magnitude > 0 then
            local addedSpeed = (Config.Move.Speed.Value - 16) * ((Config.Move.Speed.Smoothness - 1) / 100)
            root.CFrame = root.CFrame + (hum.MoveDirection * addedSpeed * dt * 10)
        end

        -- COMBAT & WORLD
        if Config.World.FullBright then Lighting.Ambient = Color3.fromRGB(255,255,255) end
        if Config.World.NoFog then Lighting.FogEnd = 1e5 end
        if Config.Move.Noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        
        if Config.Combat.Aura.Enabled then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for _, o in pairs(Players:GetPlayers()) do
                    if o ~= LocalPlayer and o.Character and (root.Position - o.Character.HumanoidRootPart.Position).Magnitude <= Config.Combat.Aura.Range then
                        firetouchinterest(o.Character.HumanoidRootPart, tool.Handle, 0)
                        firetouchinterest(o.Character.HumanoidRootPart, tool.Handle, 1)
                    end
                end
            end
        end
        
        if Config.Combat.Hitbox.Enabled then
            for _, o in pairs(Players:GetPlayers()) do
                if o ~= LocalPlayer and o.Character and o.Character:FindFirstChild(Config.Combat.Hitbox.Part) then
                    local part = o.Character[Config.Combat.Hitbox.Part]
                    part.Size = Vector3.new(Config.Combat.Hitbox.Size, Config.Combat.Hitbox.Size, Config.Combat.Hitbox.Size)
                    part.Transparency = Config.Combat.Hitbox.Transparency; part.CanCollide = false
                end
            end
        end
    end)
end)

-- Initialization
for _, p in pairs(Players:GetPlayers()) do SetupESP(p) end
Players.PlayerAdded:Connect(SetupESP)

Rayfield:Notify({Title = "History of Fails", Content = "Cleanup complete. Overlap fixed!", Duration = 5})
