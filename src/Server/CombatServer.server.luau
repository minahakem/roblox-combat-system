-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService") -- Used for smooth visual effects later

-- VARIABLES
local PunchEvent = ReplicatedStorage:WaitForChild("PunchEvent")

-- CONFIGURATION
local DAMAGE = 15
local HITBOX_SIZE = Vector3.new(4, 5, 4) -- Width, Height, Depth of the attack box

-- FUNCTION: Creates the spatial hitbox
local function createHitbox(attackerCharacter)
	local hrp = attackerCharacter:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Create a physical part in the world to represent our hitbox zone
	local hitbox = Instance.new("Part")
	hitbox.Size = HITBOX_SIZE
	hitbox.Transparency = 0.5 -- 0 is fully visible, 1 is invisible. 0.5 lets us test it!
	hitbox.Color = Color3.fromRGB(255, 0, 0) -- Bright Red
	hitbox.CanCollide = false -- Ensures it passes through objects seamlessly
	hitbox.Anchored = true

	-- Position the hitbox slightly in front of the player's chest
	hitbox.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
	hitbox.Parent = workspace

	-- Create a list of things the hitbox has already hit so we don't damage them twice in one swing
	local alreadyHit = {}

	-- GetPartsInPart checks what objects are physically overlapping with our hitbox
	local overlappingParts = workspace:GetPartsInPart(hitbox)

	for _, part in ipairs(overlappingParts) do
		-- Look for a Humanoid in the model we touched
		local model = part.Parent
		local humanoid = model:FindFirstChildOfClass("Humanoid")

		-- Ensure we found a humanoid, it's not the attacker themselves, and we haven't hit them yet
		if humanoid and model ~= attackerCharacter and not alreadyHit[model] then
			alreadyHit[model] = true -- Mark them as hit

			-- Deal the damage securely on the server
			humanoid:TakeDamage(DAMAGE)
			print("Server: Hit successfully registered on " .. model.Name .. " for " .. DAMAGE .. " damage!")
		end
	end

	-- Automatically clean up the visual hitbox part after 0.2 seconds
	task.delay(0.2, function()
		hitbox:Destroy()
	end)
end

-- LISTENERS
-- When the client fires the remote event, this function triggers automatically
PunchEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	-- Security check: make sure the player isn't already dead/downed when attacking
	if humanoid and humanoid.Health > 0 then
		createHitbox(character)
	end
end)

-- Inside your Server game-state controller when 15s passes:
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		_G.RewardSurvival(player) -- Securely moves coins from session to persistent savings
	end
end