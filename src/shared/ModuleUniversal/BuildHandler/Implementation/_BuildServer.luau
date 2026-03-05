local buildServer = {}

function buildServer.init()
	require(script.Parent.Parent.SystemPackage.BuildServerService).init()
end

return buildServer
