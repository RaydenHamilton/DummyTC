local Players = game:GetService("Players")

local PlayerDataServerService = require(script.parent.parent.SystemPackage.PlayerDataServerService)

local playerDataServerSetup = {}
playerDataServerSetup.__index = playerDataServerSetup

local profileTemplate = {
	Money = 0,
	Builds = {},
	Dummys = {},
	Settings = {},
}

function playerDataServerSetup.init()
	PlayerDataServerService.init(profileTemplate)

	Players.PlayerAdded:Connect(PlayerDataServerService.playerAdded)

	Players.PlayerRemoving:Connect(PlayerDataServerService.playerRemoving)
end

return playerDataServerSetup
