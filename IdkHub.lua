-- Carrega Rayfield UI
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

-- VARIÁVEIS
local autoParry = false
local autoSpam = false
local spamSpeed = 0.2
local parryDist = 30
local autoAbility = false

-- FUNÇÃO AUTOPARRY (detecta múltiplos PixelKillEvent)
function AutoParryFunc()
    while autoParry do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, ball in ipairs(workspace:GetChildren()) do
                    if ball.Name == "PixelKillEvent" and ball:IsA("BasePart") then
                        local dist = (char.HumanoidRootPart.Position - ball.Position).Magnitude
                        if dist < parryDist then
                            game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
                        end
                    end
                end
            end
        end)
        task.wait(0.05)
    end
end

-- FUNÇÃO AUTOSPAM
function AutoSpamFunc()
    while autoSpam do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
        end)
        task.wait(spamSpeed)
    end
end

-- FUNÇÃO SPAM MANUAL
function ManualSpamFunc()
    game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
end

-- FUNÇÃO AUTOABILITY
function AutoAbilityFunc()
    while autoAbility do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Ability:FireServer()
        end)
        task.wait(1)
    end
end

-- UI Rayfield

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
