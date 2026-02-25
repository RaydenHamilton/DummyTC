local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = ReplicatedStorage.Utilities.Observers

local DamageDummy = {}
DamageDummy.__index = DamageDummy


function DamageDummy.new()
	local self = setmetatable({}, DamageDummy)

    self stop = Observers.observeTag("")

end

return DamageDummy
