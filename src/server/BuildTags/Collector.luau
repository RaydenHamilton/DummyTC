local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Observers = require(ReplicatedStorage.Packages.Observers)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local collector = {}
collector.__index = collector

local function canNotDamage(bodyPart)
	return not bodyPart:IsA("BasePart") or typeof(bodyPart:GetAttribute("Damage")) ~= typeof(0)
end

function collector.new(collectorPart: BasePart)
	local player = Players:GetPlayerByUserId(collectorPart:GetAttribute("Owner"))
	local self = setmetatable({}, collector)
	self.TouchEvent = collectorPart.Touched:Connect(function(otherPart)
		if canNotDamage(otherPart) then
			return
		end
		PlayerDataServerService.add(player, "Money", otherPart:GetAttribute("Damage"))
		otherPart:Destroy()
	end)
	return function()
		self.TouchEvent:Disconnect()
	end
end

function collector.init()
	Observers.observeTag("collector", collector.new, { Workspace })
end

return collector
