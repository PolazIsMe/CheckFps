-- Polaz Depchai | CheckFps (FIXED)
-- Stable for DeltaX

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

pcall(function()
	guiParent:FindFirstChild("PolazFPS"):Destroy()
end)

-- ===== Anti AFK =====
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ===== Honey (Bee Swarm) =====
local honeyValue
pcall(function()
	honeyValue = player:WaitForChild("PlayerStats"):WaitForChild("Honey")
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(220,120)
frame.Position = UDim2.new(1,-235,0,20)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- ===== Appear Animation =====
frame.Size = UDim2.fromOffset(0,0)
TweenService:Create(
	frame,
	TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
	{Size = UDim2.fromOffset(220,120)}
):Play()

-- ===== Drag System (SAFE) =====
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- ===== Watermark =====
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(1,-16,0,18)
wm.Position = UDim2.new(0,8,0,6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.SourceSansBold
wm.TextSize = 14
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

-- ===== Info =====
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,-16,1,-36)
info.Position = UDim2.new(0,8,0,28)
info.BackgroundTransparency = 1
info.Font = Enum.Font.SourceSans
info.TextSize = 14
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.TextWrapped = true
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ===== Minimize =====
local minimized = false
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.fromOffset(26,26)
btn.Position = UDim2.new(1,-30,0,6)
btn.Text = "-"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.BackgroundColor3 = Color3.fromRGB(245,245,245)
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

btn.MouseButton1Click:Connect(function()
	minimized = not minimized
	btn.Text = minimized and "+" or "-"
	if minimized then
		info.Visible = false
		wm.Visible = false
		frame:TweenSize(UDim2.fromOffset(50,40),"Out","Quad",0.25,true)
	else
		frame:TweenSize(UDim2.fromOffset(220,120),"Out","Quad",0.25,true)
		task.delay(0.15,function()
			info.Visible = true
			wm.Visible = true
		end)
	end
end)

-- ===== FPS / DATA =====
local fps, frames, last = 0, 0, tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end

	local honey = "N/A"
	if honeyValue then
		honey = string.format("%.2fB", honeyValue.Value / 1e9)
	end

	info.Text =
		"FPS: "..fps..
		"\nPing: "..math.floor(player:GetNetworkPing()*1000).." ms"..
		"\nPlayers: "..#Players:GetPlayers()..
		"\nHoney: "..honey
end)
