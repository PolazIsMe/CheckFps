-- Polaz FPS | CheckFps (STABLE FIX)

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- ANTI AFK
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GUI SAFE CREATE
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(1, -235, 0, 20)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- APPEAR ANIMATION
local scale = Instance.new("UIScale", frame)
scale.Scale = 0.6
TweenService:Create(
	scale,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()

-- WATERMARK
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(1, -40, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 13
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

-- INFO
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 70)
info.Position = UDim2.new(0, 8, 0, 28)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextColor3 = Color3.fromRGB(20,20,20)

-- MINIMIZE
local minimized = false
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -30, 0, 6)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	wm.Visible = not minimized
	info.Visible = not minimized
	minBtn.Text = minimized and "+" or "—"

	TweenService:Create(
		frame,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = minimized and UDim2.new(0, 50, 0, 40) or UDim2.new(0, 220, 0, 130)}
	):Play()
end)

-- FPS + PLAYED TIME
local startTime = os.clock()
local fps, frames, last = 0, 0, tick()

local function format(sec)
	return string.format("%02d:%02d:%02d",
		math.floor(sec/3600),
		math.floor(sec%3600/60),
		math.floor(sec%60)
	)
end

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end

	info.Text =
		"FPS: "..fps.." | Ping: "..math.floor(player:GetNetworkPing()*1000).." ms\n"..
		"Players: "..#Players:GetPlayers().."\n"..
		"Played Time: "..format(os.clock() - startTime)
end)
