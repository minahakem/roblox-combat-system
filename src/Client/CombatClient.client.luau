local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game.Players.LocalPlayer
local debounce = false
local ATTACK_COOLDOWN = 0.5

local PunchEvent = ReplicatedStorage:WaitForChild("PunchEvent")

local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	-- Check for Left Mouse Click (Basic Attack)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not debounce then
			debounce = true
			print("Client: Left Click detected!")
			PunchEvent:FireServer()
			task.wait(ATTACK_COOLDOWN)
			debounce = false
		end

		-- Check for the 'E' Keyboard Key (Special/Heavy Attack)
	elseif input.KeyCode == Enum.Enum.KeyCode.E then
		if not debounce then
			debounce = true
			print("Client: E Key pressed! Executing heavy action...")
			-- Right now it runs the same punch event, but we can separate this later!
			PunchEvent:FireServer() 
			task.wait(1.5) -- Heavy attacks get a longer cooldown
			debounce = false
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)