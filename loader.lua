-- Polaz FPS | CheckFps
-- FPS | Ping | Players | Honey (B)
-- Minimize + Appear Animation
-- Anti-AFK (Hidden)
-- Stable for DeltaX

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ===== ANTI AFK (NGẦM) =====
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ===== BEE SWARM HONEY =====
local honeyValue = nil
pcall(function()
	honeyValue = player:WaitForChild("PlayerStats"):WaitForChild("Honey")
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(1, -235, 0, 20)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- ===== APPEAR ANIMATION =====
frame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(
	frame,
	TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	{
		Size = UDim2.new(0, 220, 0, 120),
		BackgroundTransparency = 0.25
	}
):Play()

-- ===== WATERMARK =====
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(0, 120, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 12
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

-- ===== INFO =====
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 70)
info.Position = UDim2.new(0, 8, 0, 30)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ===== MINIMIZE BUTTON =====
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
		wm.Visible = false
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
			wm.Visible = true
		end)
	end
end)

-- ===== FPS / PING / HONEY =====
local fps, frames, last = 0, 0, tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end

	local honeyText = "N/A"
	if honeyValue then
		honeyText = string.format("%.2fB", honeyValue.Value / 1e9)
	end

	info.Text =
		"FPS: "..fps..
		"\nPing: "..math.floor(player:GetNetworkPing()*1000).." ms"..
		"\nPlayers: "..#Players:GetPlayers()..
		"\n🍯 Honey: "..honeyText
end)
