local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local Signal = require(ReplicatedStorage.Packages.Signal)

local Collecter = {}
Collecter.__index = Collecter

local function canNotDamage(bodyPart)
	return not bodyPart:IsA("BasePart") or typeof(bodyPart:GetAttribute("Damage")) ~= typeof(0)
end

function Collecter.new(player: Player, collecterPart: BasePart)
	local self = setmetatable({}, Collecter)
	self.addMoney = Signal.new()
	self.TouchEvent = collecterPart.Touched:Connect(function(otherPart)
		if canNotDamage(otherPart) then
			return
		end
		PlayerDataServerService.add(player, "Money", otherPart:GetAttribute("Damage"))
		otherPart:Destroy()
	end)
end

return Collecter
