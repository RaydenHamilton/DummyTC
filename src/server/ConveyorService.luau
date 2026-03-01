local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Observers = require(ReplicatedStorage.Packages.Observers)

local Conveyor = {}
Conveyor.__index = Conveyor

local function startConveyor(conveyor: BasePart)
	conveyor.AssemblyLinearVelocity = conveyor.CFrame.LookVector * -10
	return function()
		if conveyor.Parent then
			conveyor.AssemblyLinearVelocity = Vector3.zero
		end
	end
end

function Conveyor.new()
	local self = setmetatable({}, Conveyor)
	self.Event = Observers.observeTag("Conveyor", startConveyor, { Workspace })
	return self
end

return Conveyor
