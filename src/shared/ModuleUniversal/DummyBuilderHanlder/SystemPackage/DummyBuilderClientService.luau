local DummyBuilderClient = {}

local dummyData: {}

local function getDummyData()
	return {}
end

function DummyBuilderClient.init()
	dummyData = getDummyData()
end

return DummyBuilderClient
