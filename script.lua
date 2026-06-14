while true do
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "glass_panel" then
			obj.Transparency = 0
			obj.Color = Color3.fromRGB(0, 255, 0) -- Green
		end
	end

	task.wait(1)
end