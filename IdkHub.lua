local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "idk Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by cauezin",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
}) 
local mainTab = Window:CreateTab("🏡Home", 4483362458) -- Title, Image


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FilmHub"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FilmHub - Auto Parry"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Botão Auto Parry
local AutoParryBtn = Instance.new("TextButton")
AutoParryBtn.Size = UDim2.new(0, 200, 0, 50)
AutoParryBtn.Position = UDim2.new(0.5, -100, 0, 50)
AutoParryBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoParryBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoParryBtn.Text = "Auto Parry: Desativado"
AutoParryBtn.Font = Enum.Font.GothamBold
AutoParryBtn.TextSize = 16
AutoParryBtn.Parent = MainFrame

-- Label de status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 200, 0, 40)
StatusLabel.Position = UDim2.new(0.5, -100, 0, 110)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(0,255,0)
StatusLabel.Text = ""
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- Variável de controle
local AutoParryAtivo = false

-- Função de clique
AutoParryBtn.MouseButton1Click:Connect(function()
    AutoParryAtivo = not AutoParryAtivo
    if AutoParryAtivo then
        AutoParryBtn.Text = "Auto Parry: Ativado"
        StatusLabel.Text = "Auto Parry ligado! 🔰"
    else
        AutoParryBtn.Text = "Auto Parry: Desativado"
        StatusLabel.Text = "Auto Parry desligado!"
    end
end)

-- Loop de simulação de parry
spawn(function()
    while true do
        wait(1)
        if AutoParryAtivo then
            StatusLabel.Text = "Parry detectado! ⚔️"
            wait(0.5)
            StatusLabel.Text = "Auto Parry ligado! 🔰"
        end
    end
end)
