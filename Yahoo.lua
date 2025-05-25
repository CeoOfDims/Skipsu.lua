local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Daftar nama bot yang mau di-blacklist dari ESP
local blacklistNames = {
    "Brown", "Spectator", "Blonde", "Barber", "1", "2", "3",
    "Pianist", "Bartender", "Unlucky Guy", "Lazy Man", "Prop.corse", "Ballon"
}

-- Cek apakah nama diblacklist
local function isBlacklisted(name)
    for _, v in ipairs(blacklistNames) do
        if string.lower(name) == string.lower(v) then
            return true
        end
    end
    return false
end

-- Buat ESP dan Highlight
local function createESP(part, model)
    if part:FindFirstChild("ESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0.4
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard

    billboard.Parent = part

    -- Tambah Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Adornee = model
    highlight.Parent = model

    -- Update jarak
    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and model and model:FindFirstChild("HumanoidRootPart") then
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude)
            label.Text = "ENEMY [" .. distance .. "]"
        end
    end)
end

-- Loop scan HumanoidRootPart AI
local function scanESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "HumanoidRootPart" then
            local model = obj:FindFirstAncestorOfClass("Model")
            if model and not obj:FindFirstChild("ESP") and not isBlacklisted(model.Name) and model ~= LocalPlayer.Character then
                if model:FindFirstChild("Humanoid") then
                    createESP(obj, model)
                end
            end
        end
    end
end

-- Loop jalan tiap frame
RunService.RenderStepped:Connect(function()
    -- Scan ESP
    scanESP()

    -- Set WalkSpeed ke 35 & anti-reset
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 35
    end

    -- Anti Lag + Daylight + Anti Fog
    Lighting.FogEnd = 1e10
    Lighting.FogStart = 0
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.Ambient = Color3.new(1, 1, 1)
end)

-- Tulisan Kanan Bawah
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "MadeByCeoOfDims"

local label = Instance.new("TextLabel", screenGui)
label.AnchorPoint = Vector2.new(1, 1)
label.Position = UDim2.new(1, -10, 1, -10)
label.Size = UDim2.new(0, 200, 0, 30)
label.BackgroundTransparency = 1
label.Text = "Made by CeoOfDims"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
