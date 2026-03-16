local DummyBuilderServer = {}

function DummyBuilderServer.init()
	local serverBulder = require(script.Parent.Parent.SystemPackage.DummyBuilderServerService)
	serverBulder.init()
end

return DummyBuilderServer
