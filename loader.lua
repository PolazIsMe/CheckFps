-- Polaz FPS | CheckFps (FULL FIX - Stable)

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

-- ================= ANTI AFK =================
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= SERVER MEMORY (SESSION) =================
local visitedServers = {}
visitedServers[game.JobId] = true

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "PolazFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 150)
frame.Position = UDim2.new(1, -245, 0, 30)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
local stroke = Instance.new("UIStroke", frame)
stroke.Transparency = 0.35

-- ================= APPEAR =================
local scale = Instance.new("UIScale", frame)
scale.Scale = 0.7
TweenService:Create(
	scale,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()

-- ================= TEXT =================
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(1, -60, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 8)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 13
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Enum.TextXAlignment.Left

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 78)
info.Position = UDim2.new(0, 8, 0, 30)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ================= BUTTONS =================
local minimized = false
local dark = false
local teleporting = false

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -30, 0, 4)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn)

local darkBtn = Instance.new("TextButton", frame)
darkBtn.Size = UDim2.new(0, 26, 0, 26)
darkBtn.Position = UDim2.new(1, -60, 0, 4)
darkBtn.Text = "☾"
darkBtn.Font = Enum.Font.GothamBold
darkBtn.TextSize = 14
darkBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
darkBtn.BorderSizePixel = 0
Instance.new("UICorner", darkBtn)

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0, 90, 0, 28)
hopBtn.Position = UDim2.new(0, 10, 1, -36)
hopBtn.Text = "Hop Server"
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 12
hopBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
hopBtn.BorderSizePixel = 0
Instance.new("UICorner", hopBtn)

local smallBtn = Instance.new("TextButton", frame)
smallBtn.Size = UDim2.new(0, 90, 0, 28)
smallBtn.Position = UDim2.new(1, -100, 1, -36)
smallBtn.Text = "Small Server"
smallBtn.Font = Enum.Font.GothamBold
smallBtn.TextSize = 12
smallBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
smallBtn.BorderSizePixel = 0
Instance.new("UICorner", smallBtn)

-- ================= MINIMIZE =================
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	minBtn.Text = minimized and "+" or "—"

	wm.Visible = not minimized
	info.Visible = not minimized
	hopBtn.Visible = not minimized
	smallBtn.Visible = not minimized
	darkBtn.Visible = not minimized

	frame.Size = minimized and UDim2.new(0, 55, 0, 45) or UDim2.new(0, 230, 0, 150)
end)

-- ================= DARK MODE =================
darkBtn.MouseButton1Click:Connect(function()
	if minimized then return end
	dark = not dark
	darkBtn.Text = dark and "☀" or "☾"

	frame.BackgroundColor3 = dark and Color3.fromRGB(30,30,30) or Color3.fromRGB(255,255,255)
	info.TextColor3 = dark and Color3.fromRGB(235,235,235) or Color3.fromRGB(20,20,20)
	wm.TextColor3 = dark and Color3.fromRGB(160,160,160) or Color3.fromRGB(120,120,120)
end)

-- ================= FPS / PLAYED TIME =================
local startTime = os.clock()
local fps, frames, last = 0, 0, tick()

local function safePing()
	local ok, ping = pcall(function()
		return math.floor(player:GetNetworkPing() * 1000)
	end)
	return ok and ping or 0
end

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
		"FPS: "..fps.." | Ping: "..safePing().." ms\n"..
		"Players: "..#Players:GetPlayers().."\n"..
		"Played Time: "..format(os.clock() - startTime)
end)

-- ================= TELEPORT =================
local function unlock()
	task.delay(3, function()
		teleporting = false
	end)
end

hopBtn.MouseButton1Click:Connect(function()
	if teleporting then return end
	teleporting = true
	unlock()
	TeleportService:Teleport(placeId, player)
end)

smallBtn.MouseButton1Click:Connect(function()
	if teleporting then return end
	teleporting = true
	unlock()

	local bestServer
	local lowest = math.huge
	local cursor = ""

	for _ = 1, 3 do
		local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100&sortOrder=Asc"..(cursor ~= "" and "&cursor="..cursor or "")
		local ok, res = pcall(function() return game:HttpGet(url) end)
		if not ok then break end

		local data = HttpService:JSONDecode(res)
		for _,s in ipairs(data.data) do
			if s.playing < s.maxPlayers and not visitedServers[s.id] then
				if s.playing < lowest then
					lowest = s.playing
					bestServer = s.id
				end
			end
		end
		cursor = data.nextPageCursor or ""
	end

	if bestServer then
		visitedServers[bestServer] = true
		TeleportService:TeleportToPlaceInstance(placeId, bestServer, player)
	else
		TeleportService:Teleport(placeId, player)
	end
end)
