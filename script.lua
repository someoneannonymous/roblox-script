local function apply(part)
	if part.Name == "glass_panel_weak" then
		part.Transparency = 0
		part.Color = Color3.fromRGB(255, 0, 0) -- Red
	elseif part.Name == "glass_panel" then
		part.Transparency = 0
		part.Color = Color3.fromRGB(0, 255, 0) -- Green
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") then
		if obj.Name == "glass_panel" or obj.Name == "glass_panel_weak" then
			apply(obj)
		end
	end
end)

-- initial scan once
for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		if obj.Name == "glass_panel" or obj.Name == "glass_panel_weak" then
			apply(obj)
		end
	end
end
