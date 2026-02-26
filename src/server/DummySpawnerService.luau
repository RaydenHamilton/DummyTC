--// TODO connect to player data do it can remove what the player does not own
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local DummySpawner = {}

DummySpawner.__index = DummySpawner

function DummySpawner.new(...): Object
	local self = setmetatable({}, DummySpawner)
	self.Dummy = ReplicatedStorage.NormalDummy
	self.Delta = 0
    local x,y,z = ...
	self.HeartBeat = RunService.Heartbeat:Connect(function(tb)
		self.Delta += tb
		if self.Delta >= 5 then
			self.Delta = 0
			self:SetUpDummyClone():PivotTo(CFrame.new(Vector3.new(x,y,z)))
		end
	end)

	return self
end

function DummySpawner:SetUpDummyClone(): Model
	local ClonedDummy = self.Dummy:Clone()
	for _, basePart: BasePart in ClonedDummy:GetChildren() do
		if basePart:IsA("BasePart") then
			basePart:SetAttribute("Damage", 0)
		end
	end
	ClonedDummy.Parent = Workspace
	return ClonedDummy
end

return DummySpawner
