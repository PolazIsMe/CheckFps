-- Polaz FPS | FIXED & STABLE
-- DeltaX Compatible

pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("PolazFPS"):Destroy()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

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
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(1, -235, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- Watermark
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(0, 100, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 12
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

-- Info
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 66)
info.Position = UDim2.new(0, 8, 0, 28)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0.45,0,0,28)
hopBtn.Position = UDim2.new(0.05,0,1,-32)
hopBtn.Text = "Hop"
hopBtn.Font = Enum.Font.GothamMedium
hopBtn.TextSize = 13
hopBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
hopBtn.BorderSizePixel = 0
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0,10)

local smallBtn = Instance.new("TextButton", frame)
smallBtn.Size = UDim2.new(0.45,0,0,28)
smallBtn.Position = UDim2.new(0.5,0,1,-32)
smallBtn.Text = "Small"
smallBtn.Font = Enum.Font.GothamMedium
smallBtn.TextSize = 13
smallBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
smallBtn.BorderSizePixel = 0
Instance.new("UICorner", smallBtn).CornerRadius = UDim.new(0,10)

-- ================= TIME + FPS =================
local serverStart = tick()
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
		"Server Time: "..format(tick() - serverStart)
end)

-- ================= SERVER HOP =================
hopBtn.MouseButton1Click:Connect(function()
	TeleportService:Teleport(placeId, player)
end)

smallBtn.MouseButton1Click:Connect(function()
	pcall(function()
		local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
		local raw = game:HttpGetAsync(url)
		local data = HttpService:JSONDecode(raw)
		local best

		for _, v in pairs(data.data) do
			if v.playing < v.maxPlayers then
				if not best or v.playing < best.playing then
					best = v
				end
			end
		end

		if best then
			TeleportService:TeleportToPlaceInstance(placeId, best.id, player)
		else
			TeleportService:Teleport(placeId, player)
		end
	end)
end)
