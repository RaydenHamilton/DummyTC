--// TODO connect to player data do it can remove what the player does not own
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local DummySpawner = {}

DummySpawner.__index = DummySpawner

function DummySpawner.init(player, ...): Object
	local self = setmetatable({}, DummySpawner)
	self.Dummy = ReplicatedStorage.NormalDummy
	self.Delta = 0
	local x, y, z = ...
	self.HeartBeat = RunService.Heartbeat:Connect(function(tb)
		self.Delta += tb
		if self.Delta >= 5 then
			self.Delta = 0
			self:SetUpDummyClone(player):PivotTo(CFrame.new(Vector3.new(x, y, z)))
		end
	end)

	return self
end

function DummySpawner:SetUpDummyClone(player): Model
	local ClonedDummy = self.Dummy:Clone()

	local allowedParts = PlayerDataServerService.get(player, "Dummys")[ClonedDummy.Name] or {}

	for _, basePart: BasePart in ClonedDummy:GetChildren() do
		if basePart:IsA("BasePart") then
			if allowedParts[basePart.Name] then
				basePart:SetAttribute("Damage", 0)
				basePart:SetAttribute("MaxDamage", 10)
				basePart:SetAttribute("Color", basePart.Color)
				basePart:SetAttribute("Burns", 0)
				basePart:SetAttribute("MaxBurns", 10)
			else
				basePart:Destroy()
			end
		end
	end

	ClonedDummy.Parent = Workspace
	task.delay(60, function()
		ClonedDummy:Destroy()
	end)
	return ClonedDummy
end

return DummySpawner
