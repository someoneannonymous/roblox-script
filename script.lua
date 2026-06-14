local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- =========================
-- STATE
-- =========================
local correctEnabled = false
local wrongEnabled = false

local original = {}

-- =========================
-- HELPERS
-- =========================
local function isTarget(part)
	return part:IsA("BasePart") and (
		part.Name == "glass_panel" or part.Name == "glass_panel_weak"
	)
end

local function store(part)
	if original[part] then return end
	original[part] = {
		Color = part.Color,
		Transparency = part.Transparency
	}
end

local function restore(part)
	local data = original[part]
	if data then
		part.Color = data.Color
		part.Transparency = data.Transparency
	end
end

local function apply(part)
	if not isTarget(part) then return end

	store(part)

	if part.Name == "glass_panel" then
		if correctEnabled then
			part.Color = Color3.fromRGB(0, 255, 0)
			part.Transparency = 0
		else
			restore(part)
		end

	elseif part.Name == "glass_panel_weak" then
		if wrongEnabled then
			part.Color = Color3.fromRGB(255, 0, 0)
			part.Transparency = 0
		else
			restore(part)
		end
	end
end

-- =========================
-- SAFE HOOK SYSTEM (NO BREAK ON RESPAWN)
-- =========================
local function hookObject(obj)
	if isTarget(obj) then
		apply(obj)
	end
end

workspace.DescendantAdded:Connect(hookObject)

-- initial load (chunked to avoid lag spike)
task.spawn(function()
	local count = 0

	for _, obj in ipairs(workspace:GetDescendants()) do
		hookObject(obj)

		count += 1
		if count % 60 == 0 then
			task.wait()
		end
	end
end)

-- safety re-sync (catches map resets / respawns)
task.spawn(function()
	while true do
		task.wait(2)

		for _, obj in ipairs(workspace:GetDescendants()) do
			if isTarget(obj) then
				apply(obj)
			end
		end
	end
end)

-- =========================
-- UI SETUP
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "GlassUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0.5, -100, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.25
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- top bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 25)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Glass Control"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = topBar

-- button creator
local function makeButton(text, y, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.85, 0, 0, 30)
	btn.Position = UDim2.new(0.075, 0, 0, y)
	btn.BackgroundColor3 = color
	btn.BackgroundTransparency = 0.2
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local correctBtn = makeButton("Correct: OFF", 35, Color3.fromRGB(0, 170, 0))
local wrongBtn = makeButton("Wrong: OFF", 75, Color3.fromRGB(170, 0, 0))

-- =========================
-- BUTTON LOGIC
-- =========================
correctBtn.MouseButton1Click:Connect(function()
	correctEnabled = not correctEnabled
	correctBtn.Text = correctEnabled and "Correct: ON" or "Correct: OFF"

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "glass_panel" then
			apply(obj)
		end
	end
end)

wrongBtn.MouseButton1Click:Connect(function()
	wrongEnabled = not wrongEnabled
	wrongBtn.Text = wrongEnabled and "Wrong: ON" or "Wrong: OFF"

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "glass_panel_weak" then
			apply(obj)
		end
	end
end)

-- =========================
-- DRAG SYSTEM
-- =========================
local dragging = false
local dragStart
local startPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
