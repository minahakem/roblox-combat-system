local RunService = game:GetService("RunService")

-- RenderStepped fires every frame on the client, right before the screen is rendered.
-- The 'deltaTime' parameter gives you the time (in seconds) since the last frame.

RunService.RenderStepped:Connect(function(deltaTime)
	-- Add your per-frame logic here
	-- Example: print("Frame rendered! Delta time: " .. deltaTime)
end)
