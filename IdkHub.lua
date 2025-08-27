-- 🔥 Carrega Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blade Ball Hub",
   Icon = 0,
   LoadingTitle = "Blade Ball Hub",
   LoadingSubtitle = "by cauezin",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
})

local mainTab = Window:CreateTab("🏡 Home", 4483362458)

-- 📌 VARIÁVEIS
local autoParry = false
local autoSpam = false
local spamSpeed = 0.2
local parryDist = 30
local autoAbility = false
local autoGoldenBall = false

-- ✅ Remote fixo para Parry
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ParryRemote = Remotes:WaitForChild("ParryAttempt")

-- ✅ Remote opcional para Ability (filtragem melhorada)
local AbilityRemote = nil
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local lowerName = string.lower(obj.Name)
        if lowerName == "ability" or lowerName == "useability" or lowerName == "abilityused" then
            warn("✅ AbilityRemote encontrado:", obj:GetFullName())
            AbilityRemote = obj
            break
        end
    end
end

-- ⚔️ FUNÇÃO AUTOPARRY
function AutoParryFunc()
    while autoParry do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and ParryRemote then
                for _, ball in ipairs(workspace:GetChildren()) do
                    if ball:IsA("BasePart") and string.find(string.lower(ball.Name), "ball") then
                        local dist = (char.HumanoidRootPart.Position - ball.Position).Magnitude
                        if dist < parryDist then
                            ParryRemote:FireServer()
                        end
                    end
                end
            end
        end)
        task.wait(0.05)
    end
end

-- 🔁 FUNÇÃO AUTOSPAM
function AutoSpamFunc()
    while autoSpam do
        pcall(function()
            if ParryRemote then
                ParryRemote:FireServer()
            end
        end)
        task.wait(spamSpeed)
    end
end

-- 🔘 FUNÇÃO SPAM MANUAL
function ManualSpamFunc()
    if ParryRemote then
        ParryRemote:FireServer()
    end
end

-- ⭐ FUNÇÃO AUTOABILITY
function AutoAbilityFunc()
    while autoAbility do
        pcall(function()
            if AbilityRemote then
                AbilityRemote:FireServer()
            end
        end)
        task.wait(1)
    end
end

-- 🟡 FUNÇÃO AUTO GOLDEN BALL
function AutoGoldenBallFunc()
    while autoGoldenBall do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("Abilities") and AbilityRemote then
                local goldenBall = char.Abilities:FindFirstChild("Golden Ball")
                if goldenBall then
                    AbilityRemote:FireServer()
                end
            end
        end)
        task.wait(2)
    end
end

-- 🟡 FUNÇÃO USAR GOLDEN BALL MANUAL
function UseGoldenBall()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Abilities") and AbilityRemote then
        local goldenBall = char.Abilities:FindFirstChild("Golden Ball")
        if goldenBall then
            AbilityRemote:FireServer()
        end
    end
end

-- 📂 UI Rayfield
mainTab:CreateToggle({
    Name = "AutoParry",
    CurrentValue = false,
    Callback = function(Value)
        autoParry = Value
        if Value then
            spawn(AutoParryFunc)
        end
    end
})

mainTab:CreateToggle({
    Name = "Auto Spam",
    CurrentValue = false,
    Callback = function(Value)
        autoSpam = Value
        if Value then
            spawn(AutoSpamFunc)
        end
    end
})

mainTab:CreateSlider({
    Name = "Spam Speed (menor = mais rápido)",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = spamSpeed,
    Callback = function(Value)
        spamSpeed = Value
    end
})

mainTab:CreateButton({
    Name = "Spam Manual",
    Callback = ManualSpamFunc
})

mainTab:CreateSlider({
    Name = "Parry Accuracy (distância)",
    Range = {10, 50},
    Increment = 1,
    CurrentValue = parryDist,
    Callback = function(Value)
        parryDist = Value
    end
})

mainTab:CreateToggle({
    Name = "Auto Ability",
    CurrentValue = false,
    Callback = function(Value)
        autoAbility = Value
        if Value then
            spawn(AutoAbilityFunc)
        end
    end
})

mainTab:CreateToggle({
    Name = "Auto Golden Ball",
    CurrentValue = false,
    Callback = function(Value)
        autoGoldenBall = Value
        if Value then
            spawn(AutoGoldenBallFunc)
        end
    end
})

mainTab:CreateButton({
    Name = "Usar Golden Ball (Manual)",
    Callback = UseGoldenBall
})
