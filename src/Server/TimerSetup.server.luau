-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Shared timer value, owned and counted down by the server
local timeLeft = Instance.new("NumberValue")
timeLeft.Name = "TimeLeft"
timeLeft.Value = 60
timeLeft.Parent = ReplicatedStorage

-- Shared flag: true once the golden key has been collected
local keyCollected = Instance.new("BoolValue")
keyCollected.Name = "KeyCollected"
keyCollected.Value = false
keyCollected.Parent = ReplicatedStorage

-- Server-authoritative countdown — stops permanently once the key is collected
task.spawn(function()
	while timeLeft.Value > 0 do
		task.wait(1)
		if keyCollected.Value then
			break -- timer frozen for the rest of the round
		end
		timeLeft.Value = math.max(0, timeLeft.Value - 1)
	end
end)