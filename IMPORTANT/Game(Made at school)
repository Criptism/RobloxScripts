-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RNGGui"
screenGui.Parent = playerGui

-- Create a TextLabel
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 400, 0, 100)  -- Width: 400, Height: 100
label.Position = UDim2.new(0.5, -200, 0.5, -50)  -- Centered
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = screenGui
label.Text = ""  -- Empty initially

-- The table of strings
local str = {
    "tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttg",
    "tttttttttttttg",  -- target string
    "No!",
    "Yes!",
    "Yesn't",
    "Maybe...",
    "Probably not",
    "Absolutely!",
    "Hmm...",
    "Try again later",
    "Error: undefined",
    "Success!",
    "Loading...",
    "Done!",
    "Wait—what?"
}

-- RNG logic
math.randomseed(tick())
local randomIndex = math.random(1, #str)
local pickedString = str[randomIndex]

-- Target string
local target = "tttttttttttttg"

if pickedString == target then
    label.Text = "🎯 RNG hit! The target string was picked!"
else
    label.Text = "❌ RNG missed. Nothing happens."
end
