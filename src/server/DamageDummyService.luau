--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

--// Packages
local packages = ReplicatedStorage.Packages

local Observers = require(packages:WaitForChild("Observers"))
-- local Trove = require(packages:WaitForChild("Trove"))

local DamageDummy = {}
DamageDummy.__index = DamageDummy

function DamageDummy.new()
	local self = setmetatable({}, DamageDummy)
	print("init")
	self.Stop = Observers.observeTag("Damage", function(Part)
		print(Part)
	end, { Workspace })
end

return DamageDummy
