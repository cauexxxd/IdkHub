-- ⚔️ Blade Ball Hub (REAL)
-- by cauezin (adaptado para "KatanaMesh")
-- 🔓 Versão REAL: chama RemoteEvent do servidor

-- Carrega Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Blade Ball Hub (REAL)",
    LoadingTitle = "Blade Ball Hub",
    LoadingSubtitle = "by cauezin",
    ToggleUIKeybind = "K",
})
local mainTab = Window:CreateTab("🏡 Home", 4483362458)

-- Configurações iniciais
local autoParry, autoAbility, autoSpam = false, false, false
local spamSpeed = 0.2
local detectionInterval, minProjectileSpeed = 0.06, 3
local maxLeadTime, globalParryCooldown, perProjectileCooldown = 1.2, 0.6, 1.2

local defaultWalk, defaultJump = 16, 50
local walkSpeed, jumpPower = defaultWalk, defaultJump

local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local player = Players.LocalPlayer

-- 📜 UI Log
local LogText = ""
local LogBox = mainTab:CreateInput({
    Name = "📜 Log de Ações",
    PlaceholderText = "As ações aparecerão aqui...",
    RemoveTextAfterFocusLost = false,
    OnEnter = function() end
})
local function AddLog(msg)
    LogText = os.date("[%H:%M:%S] ") .. msg .. "\n" .. LogText
    LogBox:Set(LogText)
end

-- 🔥 Eventos reais do servidor
_G.PerformParry = _G.PerformParry or function(ctx)
    local ev = game.ReplicatedStorage:FindFirstChild("ParryEvent")
    if ev then
        ev:FireServer(ctx)
        AddLog("⚔️ [REAL] Parry enviado: " .. tostring(ctx.source))
    else
        AddLog("⚠️ ParryEvent não encontrado no ReplicatedStorage")
    end
end

_G.PerformAbility = _G.PerformAbility or function(ctx)
    local ev = game.ReplicatedStorage:FindFirstChild("AbilityEvent")
    if ev then
        ev:FireServer(ctx)
        AddLog("⭐ [REAL] Ability enviada: " .. tostring(ctx.source))
    else
        AddLog("⚠️ AbilityEvent não encontrado no ReplicatedStorage")
    end
end

-- Tracking
local tracked, lastGlobalParry = {}, 0

-- Utils
local function getVelocity(part)
    local ok, v = pcall(function() return part.AssemblyLinearVelocity end)
    if ok and v then return v end
    return part.Velocity
end

-- AutoCalibrador dinâmico de distância
local function autoCalibratedDistance(speed)
    return 12 + (speed * 0.9) -- base cresce conforme a velocidade
end

-- Reconhece a bola
local function isProjectilePart(p)
    if not p or not p:IsA("BasePart") then return false end
    if p.Name == "KatanaMesh" then return true end
    if p.Parent and p.Parent.Name == "Balls" then return true end
    local name = p.Name:lower()
    return (name:find("ball") or name:find("projectile") or name:find("katana")) and true or false
end

local function shouldTriggerForPart(part, hrpPos)
    local v, speed = getVelocity(part), getVelocity(part).Magnitude
    if speed < minProjectileSpeed then return false end

    local last = tracked[part]
    if last and tick() - last < perProjectileCooldown then return false end

    local rel, vv, vv2 = part.Position - hrpPos, v, v:Dot(v)
    if vv2 <= 0 then return false end

    local tClosest = -rel:Dot(vv) / vv2
    if tClosest < 0 or tClosest > maxLeadTime then return false end

    local closestPos = part.Position + vv * tClosest
    local distClosest = (closestPos - hrpPos).Magnitude

    local dynamicDist = autoCalibratedDistance(speed)
    if distClosest > dynamicDist then return false end
    if vv:Dot((hrpPos - part.Position)) <= 0 then return false end

    return true, tClosest, distClosest, speed, dynamicDist
end

-- Loop principal inteligente
do
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        acc += dt
        if acc < detectionInterval then return end
        acc = 0

        if not autoParry and not autoAbility then return end
        local char, hrp = player.Character, player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if isProjectilePart(obj) then
                local ok, should, t, d, s, dyn = pcall(function()
                    return shouldTriggerForPart(obj, hrp.Position)
                end)
                if ok and should then
                    tracked[obj] = tick()
                    if autoParry and tick() - lastGlobalParry >= globalParryCooldown then
                        lastGlobalParry = tick()
                        _G.PerformParry({ source = "KatanaMesh", predictTime = t, dist = d, speed = s })
                        AddLog(("⚔️ AutoParry KatanaMesh (%.2fs dist=%.1f/%.1f speed=%.1f)"):format(t, d, dyn, s))
                    elseif autoAbility then
                        _G.PerformAbility({ source = "KatanaMesh", predictTime = t, dist = d, speed = s })
                        AddLog(("⭐ AutoAbility KatanaMesh (%.2fs dist=%.1f/%.1f speed=%.1f)"):format(t, d, dyn, s))
                    end
                end
            end
        end

        for part in pairs(tracked) do
            if not part or not part.Parent then tracked[part] = nil end
        end
    end)
end

-- AutoSpam
task.spawn(function()
    while true do
        if autoSpam then
            _G.PerformParry({ source = "KatanaMesh" })
            AddLog("⚔️ AutoSpam KatanaMesh")
            task.wait(spamSpeed)
        else
            task.wait(0.2)
        end
    end
end)

-- ⚡ Speed & Jump
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character:FindFirstChild("Humanoid")
        hum.WalkSpeed = walkSpeed
        hum.JumpPower = jumpPower
    end
end)

-- 🖥️ UI
mainTab:CreateToggle({ Name = "AutoParry Inteligente (REAL)", CurrentValue = false, Callback = function(v) autoParry=v AddLog("AutoParry "..(v and "✅" or "❌")) end })
mainTab:CreateToggle({ Name = "Auto Ability (REAL)", CurrentValue = false, Callback = function(v) autoAbility=v AddLog("AutoAbility "..(v and "✅" or "❌")) end })
mainTab:CreateToggle({ Name = "Auto Spam (REAL)", CurrentValue = false, Callback = function(v) autoSpam=v AddLog("AutoSpam "..(v and "✅" or "❌")) end })

mainTab:CreateSlider({ Name = "Spam Speed", Range = {0.05,1}, Increment = 0.05, CurrentValue = spamSpeed, Callback = function(v) spamSpeed=v AddLog("SpamSpeed="..v) end })
mainTab:CreateSlider({ Name = "⚡ Speed", Range = {16,200}, Increment = 1, CurrentValue = defaultWalk, Callback = function(v) walkSpeed=v AddLog("⚡ Speed="..v) end })
mainTab:CreateSlider({ Name = "🦘 Jump", Range = {50,300}, Increment = 5, CurrentValue = defaultJump, Callback = function(v) jumpPower=v AddLog("🦘 Jump="..v) end })

mainTab:CreateToggle({ Name = "Auto Golden Ball (REAL)", CurrentValue = false, Callback = function(v) AddLog("AutoGoldenBall "..(v and "✅" or "❌")) end })
mainTab:CreateButton({ Name = "Spam Manual (REAL)", Callback = function() _G.PerformParry({ source = "KatanaMesh" }) AddLog("⚔️ Spam Manual KatanaMesh") end })
