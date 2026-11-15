-- GemWalker (LocalScript)
-- Put in StarterPlayer > StarterPlayerScripts
-- Walks your character to the exact position of each gem in LocalGemVisuals.
-- Use the ON/OFF button in the top right to toggle.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- LocalGemVisuals folder is in Workspace
local gemFolder = Workspace:WaitForChild("LocalGemVisuals")

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

-- Walks to the gem's exact position (re-targets each step in case it moves)
local function walkToGem(gem, hum, root)
	local lastPos = root.Position
	local stuckTime = 0

	while enabled and gem.Parent and hum.Health > 0 do
		local pos = getGemPosition(gem)
		if not pos then return end

		-- Arrived at the exact position
		if (pos - root.Position).Magnitude <= 1.5 then
			return
		end

		hum:MoveTo(pos)
		task.wait(0.1)

		-- Jump if we stop making progress (blocked by a small obstacle)
		if (root.Position - lastPos).Magnitude < 0.2 then
			stuckTime += 0.1
			if stuckTime > 0.5 then
				hum.Jump = true
			end
			if stuckTime > 4 then
				return -- give up on this gem, pick another
			end
		else
			stuckTime = 0
		end
		lastPos = root.Position
	end
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

task.spawn(function()
	while true do
		task.wait(0.1)
		if not enabled then continue end

		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if hum and root and hum.Health > 0 then
			local gem = findNearestGem(root.Position)
			if gem then
				walkToGem(gem, hum, root)
			end
		end
	end
end)
