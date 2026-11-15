-- GemWalker (LocalScript)
-- Put in StarterPlayer > StarterPlayerScripts
-- Collects gems in Workspace.LocalGemVisuals:
--   1. Gems inside RADIUS studs of you are collected highest value first (6, 5, 4 and Magnet, 3, 2, 1),
--      nearest first when two have the same value.
--   2. If nothing is inside the radius, it walks to the nearest gem anywhere.
--   The radius is re-checked from your new position every frame.
-- Use the ON/OFF button in the top right to toggle.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local gemFolder = Workspace:WaitForChild("LocalGemVisuals")

local RADIUS = 50 -- studs around you to check for high-value gems

-- Higher number = collected first inside the radius. Change the order here if you like.
local GEM_PRIORITY = {
	["Magnet"] = 4,
	["6"] = 6,
	["5"] = 5,
	["4"] = 4,
	["3"] = 3,
	["2"] = 2,
	["1"] = 1,
}

local enabled = false
local antiAfk = true

-- Anti-AFK: stops Roblox from kicking you for being idle after 20 minutes
player.Idled:Connect(function()
	if not antiAfk then return end
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

local function getGemPosition(gem)
	if gem:IsA("BasePart") then
		return gem.Position
	elseif gem:IsA("Model") then
		return gem:GetPivot().Position
	end
	return nil
end

-- Picks the gem to go for from rootPos
local function findTargetGem(rootPos)
	local bestInRadius, bestPriority, bestInRadiusDist = nil, -1, math.huge
	local nearest, nearestDist = nil, math.huge

	for _, gem in ipairs(gemFolder:GetChildren()) do
		local priority = GEM_PRIORITY[gem.Name]
		if priority then
			local pos = getGemPosition(gem)
			if pos then
				local dist = (pos - rootPos).Magnitude

				-- Track nearest overall (fallback)
				if dist < nearestDist then
					nearest, nearestDist = gem, dist
				end

				-- Track best gem inside the radius: highest priority, then closest
				if dist <= RADIUS then
					if priority > bestPriority or (priority == bestPriority and dist < bestInRadiusDist) then
						bestInRadius, bestPriority, bestInRadiusDist = gem, priority, dist
					end
				end
			end
		end
	end

	return bestInRadius or nearest
end

-- Toggle UI (top right)
local gui = Instance.new("ScreenGui")
gui.Name = "GemWalkerUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local function makeButton(yOffset)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(170, 44)
	btn.AnchorPoint = Vector2.new(1, 0)
	btn.Position = UDim2.new(1, -16, 0, yOffset)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.AutoButtonColor = true
	btn.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = btn
	return btn
end

local function paint(btn, label, on)
	btn.Text = label .. (on and ": ON" or ": OFF")
	btn.BackgroundColor3 = on and Color3.fromRGB(46, 160, 67) or Color3.fromRGB(190, 55, 55)
end

local gemButton = makeButton(16)
local afkButton = makeButton(68)

gemButton.Activated:Connect(function()
	enabled = not enabled
	paint(gemButton, "Gems", enabled)
end)

afkButton.Activated:Connect(function()
	antiAfk = not antiAfk
	paint(afkButton, "Anti-AFK", antiAfk)
end)

paint(gemButton, "Gems", enabled)
paint(afkButton, "Anti-AFK", antiAfk)

-- Main loop: every frame, re-pick the target from your current position
task.spawn(function()
	while true do
		task.wait() -- one frame

		if not enabled then continue end

		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if hum and root and hum.Health > 0 then
			local gem = findTargetGem(root.Position)
			if gem then
				hum:MoveTo(getGemPosition(gem))
			end
		end
	end
end)
