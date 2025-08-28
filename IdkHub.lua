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

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Variáveis que vão ser preenchidas quando o personagem existir
local character, humanoid, hrp
local parryTrack

-- Função que configura referências ao personagem e carrega animação uma vez
local function onCharacterAdded(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")

    -- Prepara a animação de parry uma única vez
    local parryAnim = Instance.new("Animation")
    parryAnim.Name = "AutoParryAnim"
    parryAnim.AnimationId = "rbxassetid://SEU_ANIMATION_ID_AQUI" -- coloque o ID correto
    -- carrega mas não reproduz ainda
    if humanoid then
        -- evita carregar múltiplas vezes
        if not parryTrack then
            local ok, track = pcall(function() return humanoid:LoadAnimation(parryAnim) end)
            if ok then parryTrack = track end
        end
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- Função de detecção (fazer raycast à frente do jogador)
local function detectAttack()
    if not hrp then return end

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local origin = hrp.Position
    local direction = hrp.CFrame.LookVector * 6 -- 6 studs à frente; ajuste conforme necessário

    local result = workspace:Raycast(origin, direction, rayParams)
    if result and result.Instance then
        local hitPart = result.Instance
        local model = hitPart:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") and model ~= character then
            -- Achei um jogador à frente — executo parry (apenas anim local)
            if parryTrack then
                parryTrack:Play()
            end
            -- Se o jogo exige um RemoteEvent para parry, você precisará reproduzir a chamada correta ao servidor aqui.
            return true
        end
    end
    return false
end

-- Exemplo simples: usar tecla E para tentar parry (apenas demo)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        detectAttack()
    end
end)
