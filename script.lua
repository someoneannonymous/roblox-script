local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local enabled = true -- global toggle

-- =========================
-- GLASS SYSTEM
-- =========================
local function apply(part)
	if not enabled then return end

	if part.Name == "glass_panel_weak" then
		part.Transparency = 0
		part.Color = Color3.fromRGB(255, 0, 0)
	elseif part.Name == "glass_panel" then
		part.Transparency = 0
		part.Color = Color3.fromRGB(0, 255, 0)
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") then
		if obj.Name == "glass_panel" or obj.Name == "glass_panel_weak" then
			apply(obj)
		end
	end
end)

task.spawn(function()
	local count = 0

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			if obj.Name == "glass_panel" or obj.Name == "glass_panel_weak" then
				apply(obj)
			end
		end

		count += 1
		if count % 60 == 0 then
			task.wait()
		end
	end
end)

-- =========================
-- UI CREATION
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "GlassControlUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 130)
frame.Position = UDim2.new(0.5, -90, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Top bar (drag)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 25)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BackgroundTransparency = 0.1
topBar.Parent = frame

Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Glass Panel Control"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = topBar

-- Button creator
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

local correctBtn = makeButton("Toggle Correct (ON)", 35, Color3.fromRGB(0, 170, 0))
local wrongBtn = makeButton("Toggle Wrong (OFF)", 70, Color3.fromRGB(170, 0, 0))

-- =========================
-- BUTTON LOGIC
-- =========================
correctBtn.MouseButton1Click:Connect(function()
	enabled = true
	correctBtn.Text = "Toggle Correct (ON)"
	wrongBtn.Text = "Toggle Wrong (OFF)"
end)

wrongBtn.MouseButton1Click:Connect(function()
	enabled = false
	correctBtn.Text = "Toggle Correct (OFF)"
	wrongBtn.Text = "Toggle Wrong (ON)"
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
