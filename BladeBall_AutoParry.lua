local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local delayParry = 0.05 -- tempo antes de parry (em segundos)
local toggleKey = Enum.KeyCode.P -- tecla para ligar/desligar
local ativo = true

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

-- Função para dar parry
local function darParry()
    rs:WaitForChild("Remotes"):WaitForChild("ParryButtonPress"):FireServer()
end

-- Alternar AutoParry
uis.InputBegan:Connect(function(input, isTyping)
    if not isTyping and input.KeyCode == toggleKey then
        ativo = not ativo
        warn("AutoParry:", ativo and "Ativado" or "Desativado")
    end
end)

-- Detectar bola e calcular parry
game:GetService("RunService").RenderStepped:Connect(function()
    if ativo then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Ball" and obj:IsA("BasePart") then
                local dist = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 then -- distância para acionar
                    task.delay(delayParry, darParry)
                end
            end
        end
    end
end)
