local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Observers = require(ReplicatedStorage.Packages.Observers)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local Collecter = {}
Collecter.__index = Collecter

local function canNotDamage(bodyPart)
	return not bodyPart:IsA("BasePart") or typeof(bodyPart:GetAttribute("Damage")) ~= typeof(0)
end

function Collecter.new(collecterPart: BasePart)
	local player = Players:GetPlayerByUserId(collecterPart:GetAttribute("Owner"))
	local self = setmetatable({}, Collecter)
	self.TouchEvent = collecterPart.Touched:Connect(function(otherPart)
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

function Collecter.init()
	Observers.observeTag("Collecter", Collecter.new, { Workspace })
end

return Collecter
