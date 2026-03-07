local Players = game:GetService("Players")
local buildServer = {}

function buildServer.init()
	local buildServerService = require(script.Parent.Parent.SystemPackage.BuildServerService)
	buildServerService.init()
	Players.PlayerAdded:Connect(function(player)
		buildServerService.playerAdded(player)
	end)
	Players.PlayerRemoving:Connect(buildServerService.playerRemoved)
end

return buildServer
