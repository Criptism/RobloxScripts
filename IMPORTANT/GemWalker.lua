-- GemWalker (LocalScript)
-- Put in StarterPlayer > StarterPlayerScripts
-- Walks your character to the closest gem in Workspace.LocalGemVisuals.
-- Use the ON/OFF button in the top right to toggle.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local gemFolder = Workspace:WaitForChild("LocalGemVisuals")

local GEM_NAMES = {
	["1"] = true, ["2"] = true, ["3"] = true,
	["4"] = true, ["5"] = true, ["6"] = true,
	["Magnet"] = true,
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

-- Closest gem to rootPos
local function findNearestGem(rootPos)
	local nearest, nearestDist = nil, math.huge
	for _, gem in ipairs(gemFolder:GetChildren()) do
		if GEM_NAMES[gem.Name] then
			local pos = getGemPosition(gem)
			if pos then
				local dist = (pos - rootPos).Magnitude
				if dist < nearestDist then
					nearest, nearestDist = gem, dist
				end
			end
		end
	end
	return nearest
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

-- Main loop: every frame, walk toward the closest gem
task.spawn(function()
	while true do
		task.wait() -- one frame

		if not enabled then continue end

		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if hum and root and hum.Health > 0 then
			local gem = findNearestGem(root.Position)
			if gem then
				hum:MoveTo(getGemPosition(gem))
			end
		end
	end
end)
