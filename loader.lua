--[[ 
    Polaz FPS | CheckFps
    FPS | Ping | Players | Played Time
    Hop Server | Small Server (Anti-loop)
    Minimize + Appear Animation
    Anti AFK (Hidden)
    Stable for DeltaX
--]]

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

-- ================= SERVER MEMORY =================
local visitedServers = {}
visitedServers[game.JobId] = true

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
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(1, -235, 0, 20)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Transparency = 0.3

-- ================= APPEAR ANIMATION =================
local scale = Instance.new("UIScale", frame)
scale.Scale = 0.7
TweenService:Create(
	scale,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()

-- ================= WATERMARK =================
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(1, -60, 0, 18)
wm.Position = UDim2.new(0, 8, 0, 6)
wm.BackgroundTransparency = 1
wm.Text = "Polaz FPS"
wm.Font = Enum.Font.GothamBold
wm.TextSize = 13
wm.TextColor3 = Color3.fromRGB(120,120,120)
wm.TextXAlignment = Left

-- ================= INFO =================
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -16, 0, 70)
info.Position = UDim2.new(0, 8, 0, 28)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 14
info.TextWrapped = true
info.TextXAlignment = Left
info.TextColor3 = Color3.fromRGB(20,20,20)

-- ================= BUTTONS =================
local minimized = false

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -30, 0, 6)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BackgroundColor3 = Color3.fromRGB(245,245,245)
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 4
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0, 90, 0, 28)
hopBtn.Position = UDim2.new(0, 10, 1, -36)
hopBtn.Text = "Hop Server"
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 12
hopBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
hopBtn.BorderSizePixel = 0
hopBtn.ZIndex = 3
Instance.new("UICorner", hopBtn)

local smallBtn = Instance.new("TextButton", frame)
smallBtn.Size = UDim2.new(0, 90, 0, 28)
smallBtn.Position = UDim2.new(1, -100, 1, -36)
smallBtn.Text = "Small Server"
smallBtn.Font = Enum.Font.GothamBold
smallBtn.TextSize = 12
smallBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
smallBtn.BorderSizePixel = 0
smallBtn.ZIndex = 3
Instance.new("UICorner", smallBtn)

-- ================= MINIMIZE =================
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	minBtn.Text = minimized and "+" or "—"

	wm.Visible = not minimized
	info.Visible = not minimized
	hopBtn.Visible = not minimized
	smallBtn.Visible = not minimized

	TweenService:Create(
		frame,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = minimized and UDim2.new(0, 50, 0, 40) or UDim2.new(0, 220, 0, 140)}
	):Play()
end)

-- ================= FPS / PLAYED TIME =================
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

-- ================= TELEPORT LOGIC =================
local teleporting = false

hopBtn.MouseButton1Click:Connect(function()
	if teleporting then return end
	teleporting = true
	TeleportService:Teleport(placeId, player)
end)

smallBtn.MouseButton1Click:Connect(function()
	if teleporting then return end
	teleporting = true

	local cursor = ""
	local foundServer
	local page = 0

	repeat
		page += 1
		local url = "https://games.roblox.com/v1/games/"..placeId..
			"/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")

		local success, response = pcall(function()
			return game:HttpGet(url)
		end)

		if not success then break end

		local data = HttpService:JSONDecode(response)

		for _,server in ipairs(data.data) do
			if server.playing < server.maxPlayers and not visitedServers[server.id] then
				foundServer = server.id
				break
			end
		end

		cursor = data.nextPageCursor or ""
	until foundServer or cursor == "" or page >= 3

	if foundServer then
		visitedServers[foundServer] = true
		TeleportService:TeleportToPlaceInstance(placeId, foundServer, player)
	else
		TeleportService:Teleport(placeId, player)
	end
end)
