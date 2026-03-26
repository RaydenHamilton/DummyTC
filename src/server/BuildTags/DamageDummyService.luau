--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

--// Packages
local packages = ReplicatedStorage.Packages

local Observers = require(packages:WaitForChild("Observers"))

local DamageDummy = {}
DamageDummy.__index = DamageDummy

local function burn(damagePart: BasePart, bodyPart: BasePart)
	local burns, maxBurns = bodyPart:GetAttribute("Burns") :: number, bodyPart:GetAttribute("MaxBurns")
	local originalColor = bodyPart:GetAttribute("Color")

	if damagePart:GetAttribute("Burn") and burns < maxBurns then
		bodyPart:SetAttribute("Burns", burns :: number + 1)
		local percentage = (burns / maxBurns)
		bodyPart.Color = originalColor:Lerp(Color3.new(), percentage)
	end
end

function DamageDummy.damagePartOnTouch(damagePart: BasePart)
	local damagedParts = {}

	local function damagedPartCoolDown(bodyPart)
		table.insert(damagedParts, bodyPart)
		task.delay(1, function()
			table.remove(damagedParts, table.find(damagedParts, bodyPart))
		end)
	end

	local function canNotDamage(bodyPart)
		return not bodyPart:IsA("BasePart")
			or typeof(bodyPart:GetAttribute("Damage")) ~= typeof(0)
			or table.find(damagedParts, bodyPart)
	end

	local function SetDamagedPart(bodyPart: BasePart)
		if canNotDamage(bodyPart) then
			return
		end
		local damage, maxDamage =
			bodyPart:GetAttribute("Damage") :: number, bodyPart:GetAttribute("MaxDamage") :: number
		if damage < maxDamage then
			bodyPart:SetAttribute("Damage", damage + 1)
		end
		burn(damagePart, bodyPart)
		damagedPartCoolDown(bodyPart)
	end

	local touched = damagePart.Touched:Connect(SetDamagedPart)

	-- clean up function
	return function()
		table.clear(damagedParts)
		touched:Disconnect()
	end
end

function DamageDummy.init()
	local self = setmetatable({}, DamageDummy)
	self.Stop = Observers.observeTag("Damage", DamageDummy.damagePartOnTouch, { Workspace })

	return self
end

return DamageDummy
