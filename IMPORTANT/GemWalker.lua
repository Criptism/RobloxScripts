-- GemWalker (LocalScript)
-- Put in StarterPlayer > StarterPlayerScripts
-- Walks your character to the closest gem (within RADIUS studs) in Workspace.LocalGemVisuals.
-- Use the ON/OFF button in the top right to toggle.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local gemFolder = Workspace:WaitForChild("LocalGemVisuals")

local RADIUS = 50 -- only go for gems within this many studs

local GEM_NAMES = {
	["1"] = true, ["2"] = true, ["3"] = true,
	["4"] = true, ["5"] = true, ["6"] = true,
	["Magnet"] = true,
}

local enabled = false

local function getGemPosition(gem)
	if gem:IsA("BasePart") then
		return gem.Position
	elseif gem:IsA("Model") then
		return gem:GetPivot().Position
	end
	return nil
end

-- Closest gem to rootPos that is inside the radius
local function findNearestGem(rootPos)
	local nearest, nearestDist = nil, RADIUS
	for _, gem in ipairs(gemFolder:GetChildren()) do
		if GEM_NAMES[gem.Name] then
			local pos = getGemPosition(gem)
			if pos then
				local dist = (pos - rootPos).Magnitude
				if dist <= nearestDist then
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

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(140, 44)
button.AnchorPoint = Vector2.new(1, 0)
button.Position = UDim2.new(1, -16, 0, 16)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.new(1, 1, 1)
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local function refreshButton()
	if enabled then
		button.Text = "Gems: ON"
		button.BackgroundColor3 = Color3.fromRGB(46, 160, 67)
	else
		button.Text = "Gems: OFF"
		button.BackgroundColor3 = Color3.fromRGB(190, 55, 55)
	end
end

button.Activated:Connect(function()
	enabled = not enabled
	refreshButton()
end)

refreshButton()

-- Main loop: every frame, walk toward the closest gem in range
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
