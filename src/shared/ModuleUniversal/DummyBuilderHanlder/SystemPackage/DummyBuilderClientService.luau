local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = require(ReplicatedStorage.Blink.client)

local DummyBuilderClient = {}

local dummyData: {}

local function getDummyData(...)
	dummyData = {}

	local tempData = { ... }
	for i in tempData do
		if i % 2 == 0 then
			continue
		end
		dummyData[tempData[i]] = tempData[i + 1]
	end
end

function DummyBuilderClient.init()
	client.GetDummyData.On(getDummyData)
end

return DummyBuilderClient
