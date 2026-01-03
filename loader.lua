-- Polaz FPS | Simple & Stable
-- DeltaX compatible

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(1, -215, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(220,220,220)
stroke.Thickness = 1
stroke.Transparency = 0.3

-- Watermark
local watermark = Instance.new("TextLabel")
watermark.Parent = frame
watermark.Size = UDim2.new(0, 70, 0, 20)
watermark.Position = UDim2.new(0, 8, 0, 6)
watermark.BackgroundTransparency = 1
watermark.Text = "Polaz FPS"
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 12
watermark.TextColor3 = Color3.fromRGB(120,120,120)
watermark.TextXAlignment = Enum.TextXAlignment.Left

-- Info text
local info = Instance.new("TextLabel")
info.Parent = frame
info.Size = UDim2.new(1, -16, 1, -30)
info.Position = UDim2.new(0, 8, 0, 26)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(20,20,20)
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Center
info.TextWrapped = true

-- FPS logic
local fps = 0
local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	local now = tick()
	if now - lastTime >= 1 then
		fps = frames
		frames = 0
		lastTime = now
	end

	local ping = math.floor(player:GetNetworkPing() * 1000)
	local count = #Players:GetPlayers()

	info.Text =
		"FPS: "..fps.." | Ping: "..ping.." ms\n"..
		"Players: "..count
end)
