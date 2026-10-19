-- SERVICES
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local gems = Instance.new("IntValue")
	gems.Name = "Gems"`
	gems.Value = 0
	gems.Parent = leaderstats
end)