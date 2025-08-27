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

local mainTab = Window:CreateTab("🏡Home", 4483362458)

-- Variáveis
local autoParry = false
local autoSpam = false
local spamSpeed = 0.5
local parryDist = 30
local autoAbility = false

-- Função AutoParry
function AutoParryFunc()
    while autoParry do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, ball in pairs(workspace:GetChildren()) do
                    if ball.Name == "Ball" and ball:FindFirstChild("Velocity") then
                        local dist = (char.HumanoidRootPart.Position - ball.Position).Magnitude
                        if dist < parryDist then
                            -- Parry remoto do Blade Ball
                            game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
                        end
                    end
                end
            end
        end)
        task.wait(0.05)
    end
end

-- Função AutoSpam
function AutoSpamFunc()
    while autoSpam do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
        end)
        task.wait(spamSpeed)
    end
end

-- Função Manual Spam
function ManualSpamFunc()
    game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
end

-- Função AutoAbility
function AutoAbilityFunc()
    while autoAbility do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Ability:FireServer()
        end)
        task.wait(1)
    end
end

-- UI Rayfield Toggles/Sliders/Buttons

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
    Range = {0.05, 2},
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
    Range = {5, 50},
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
