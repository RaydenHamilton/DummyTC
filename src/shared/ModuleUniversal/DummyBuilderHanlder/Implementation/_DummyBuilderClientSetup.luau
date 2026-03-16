local DummyBuilderClient = {}

function DummyBuilderClient.init()
	local clientBulder = require(script.Parent.Parent.SystemPackage.DummyBuilderClientService)
	clientBulder.init()
end

return DummyBuilderClient
