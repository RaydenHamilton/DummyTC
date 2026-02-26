--// Services
local FeatureRestrictionManager = game:GetService("FeatureRestrictionManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

--// Packages
local packages = ReplicatedStorage.Packages

local Observers = require(packages:WaitForChild("Observers"))

local DamageDummy = {}
DamageDummy.__index = DamageDummy

function DamageDummy.damagePartOnTouch(damagePart: BasePart)
	local damagedParts = {}

	local function damagedPartCooldown(bodyPart)
		table.insert(damagedParts, bodyPart)
		task.delay(1, function()
			table.remove(damagedParts, table.find(damagedParts, bodyPart))
		end)
	end

	local function canDamage(bodyPart)
		return not bodyPart:IsA("BasePart")
			or typeof(bodyPart:GetAttribute("Damage")) ~= typeof(0)
			or table.find(damagedParts, bodyPart)
	end

	local function SetDamagedPart(bodyPart: BasePart)
		if canDamage(bodyPart) then
			return
		end
		bodyPart:SetAttribute("Damage", bodyPart:GetAttribute("Damage") :: number + 1)
		damagedPartCooldown(bodyPart)
	end

	local touched = damagePart.Touched:Connect(SetDamagedPart)

	-- clean up function
	return function()
		table.clear(damagedParts)
		touched:Disconnect()
	end
end

function DamageDummy.new()
	local self = setmetatable({}, DamageDummy)
	self.Stop = Observers.observeTag("Damage", DamageDummy.damagePartOnTouch, { Workspace })

	return self
end

return DamageDummy
