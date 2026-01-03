-- Polaz FPS | CheckFps (Stable + Dark + Hop + Small)

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- ================= ANTI AFK =================
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 155)
frame.Position = UDim2.new(1, -245, 0, 30)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
local stroke = Instance.new("UIStroke", frame)
stroke.Transparency = 0.35

-- ================= APPEAR ANIMATION =================
local scale = Instance.new("UIScale", frame)
scale.Scale = 0.6
TweenService:Create(
	scale,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()

-- ================= TITLE =================
local title = Instance.new("TextLabel", frame)
title.Text = "Polaz FPS"
title.Size = UDim2.new(1, -80, 0, 20)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Left
title.TextColor3 = Color3.fromRGB(120,120,120)

-- ================= INFO =================
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -20, 0, 80)
info.Position = UDim2.new(0, 10, 0, 30)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Left
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ================= BUTTONS =================
local darkMode = false
local minimized = false

-- Dark Mode
local darkBtn = Instance.new("TextButton", frame)
darkBtn.Size = UDim2.new(0, 26, 0, 26)
darkBtn.Position = UDim2.new(1, -60, 0, 4)
darkBtn.Text = "☾"
darkBtn.Font = Enum.Font.GothamBold
darkBtn.TextSize = 14
darkBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
darkBtn.BorderSizePixel = 0
Instance.new("UICorner", darkBtn)

darkBtn.MouseButton1Click:Connect(function()
	darkMode = not darkMode
	darkBtn.Text = darkMode and "☀" or "☾"

	frame.BackgroundColor3 = darkMode and Color3.fromRGB(30,30,30) or Color3.fromRGB(255,255,255)
	info.TextColor3 = darkMode and Color3.fromRGB(235,235,235) or Color3.fromRGB(20,20,20)
	title.TextColor3 = darkMode and Color3.fromRGB(160,160,160) or Color3.fromRGB(120,120,120)
end)

-- Minimize
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -30, 0, 4)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	minBtn.Text = minimized and "+" or "—"
	info.Visible = not minimized
	title.Visible = not minimized
	hopBtn.Visible = not minimized
	smallBtn.Visible = not minimized
	darkBtn.Visible = not minimized
	frame.Size = minimized and UDim2.new(0, 55, 0, 45) or UDim2.new(0, 230, 0, 155)
end)

-- Hop Server
hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0, 90, 0, 28)
hopBtn.Position = UDim2.new(0, 10, 1, -36)
hopBtn.Text = "Hop Server"
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 12
hopBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
hopBtn.BorderSizePixel = 0
Instance.new("UICorner", hopBtn)

hopBtn.MouseButton1Click:Connect(function()
	TeleportService:Teleport(placeId, player)
end)

-- Small Server
smallBtn = Instance.new("TextButton", frame)
smallBtn.Size = UDim2.new(0, 90, 0, 28)
smallBtn.Position = UDim2.new(1, -100, 1, -36)
smallBtn.Text = "Small Server"
smallBtn.Font = Enum.Font.GothamBold
smallBtn.TextSize = 12
smallBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
smallBtn.BorderSizePixel = 0
Instance.new("UICorner", smallBtn)

smallBtn.MouseButton1Click:Connect(function()
	local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100&sortOrder=Asc"
	local data = HttpService:JSONDecode(game:HttpGet(url))
	for _,s in ipairs(data.data) do
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(placeId, s.id, player)
			break
		end
	end
end)

-- ================= FPS / TIME =================
local startTime = os.clock()
local fps, frames, last = 0, 0, tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end

	info.Text =
		"FPS: "..fps..
		"\nPlayers: "..#Players:GetPlayers()..
		"\nPlayed Time: "..math.floor(os.clock()-startTime).."s"
end)
