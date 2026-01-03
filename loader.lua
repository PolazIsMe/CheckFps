-- Polaz FPS | CheckFps
-- FPS | Ping | Players | REAL Server Time
-- Minimize + Appear Animation
-- DeltaX Stable

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- ================= ANTI AFK (NGẦM) =================
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(1, -235, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(1,0)

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- ================= APPEAR ANIMATION =================
frame.Size = UDim2.new(0, 0, 0, 0)
frame.BackgroundTransparency = 1

TweenService:Create(
	frame,
	TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{
		Size = UDim2.new(0, 220, 0, 120),
		BackgroundTransparency = 0.25
	}
):Play()

-- ================= WATERMARK =================
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(0, 100, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 12
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

-- ================= INFO =================
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 66)
info.Position = UDim2.new(0, 8, 0, 28)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ================= MINIMIZE BUTTON =================
local minimized = false
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -30, 0, 6)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BackgroundColor3 = Color3.fromRGB(245,245,245)
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	minBtn.Text = minimized and "+" or "—"

	if minimized then
		info.Visible = false
		TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 50, 0, 40)}
		):Play()
	else
		TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 220, 0, 120)}
		):Play()
		task.delay(0.15, function()
			info.Visible = true
		end)
	end
end)

-- ================= FPS / SERVER TIME =================
local fps, frames, last = 0, 0, tick()

local function format(sec)
	return string.format(
		"%02d:%02d:%02d",
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
		"Server Time: "..format(workspace.DistributedGameTime)
end)
