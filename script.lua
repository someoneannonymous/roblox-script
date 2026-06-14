local function apply(part)
	part.Transparency = 0
	part.Color = Color3.fromRGB(0, 255, 0)
end

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and obj.Name == "glass_panel" then
		apply(obj)
	end
end)

-- optional initial scan once
for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") and obj.Name == "glass_panel" then
		apply(obj)
	end
end
