-- Polaz FPS | Drawing HUD | DeltaX Safe

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
	task.wait(0.5)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= DRAWING =================
local bg = Drawing.new("Square")
bg.Size = Vector2.new(260, 120)
bg.Position = Vector2.new(20, 60)
bg.Color = Color3.fromRGB(255,255,255)
bg.Transparency = 0
bg.Filled = true

local stroke = Drawing.new("Square")
stroke.Size = bg.Size
stroke.Position = bg.Position
stroke.Color = Color3.fromRGB(200,200,200)
stroke.Thickness = 1
stroke.Filled = false

local text = Drawing.new("Text")
text.Position = bg.Position + Vector2.new(10, 30)
text.Size = 14
text.Color = Color3.fromRGB(0,0,0)
text.Font = 2
text.Text = "Loading..."
text.Outline = false

local title = Drawing.new("Text")
title.Position = bg.Position + Vector2.new(10, 8)
title.Size = 13
title.Color = Color3.fromRGB(120,120,120)
title.Font = 2
title.Text = "Polaz FPS"

-- ================= APPEAR ANIMATION =================
task.spawn(function()
	for i = 0, 1, 0.08 do
		bg.Transparency = i
		stroke.Transparency = i
		text.Transparency = i
		title.Transparency = i
		task.wait()
	end
end)

-- ================= FPS =================
local fps, frames = 0, 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
	frames += 1
	if os.clock() - last >= 1 then
		fps = frames
		frames = 0
		last = os.clock()
	end

	text.Text =
		"FPS: "..fps..
		"\nPing: "..math.floor(player:GetNetworkPing()*1000).." ms"..
		"\nPlayers: "..#Players:GetPlayers()..
		"\nServer Time: "..string.format(
			"%02d:%02d:%02d",
			math.floor(workspace.DistributedGameTime/3600),
			math.floor(workspace.DistributedGameTime%3600/60),
			math.floor(workspace.DistributedGameTime%60)
		)
end)
