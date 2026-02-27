local Players = game:GetService("Players")

local PlayerDataServerService = require(script.parent.parent.SystemPackage.PlayerDataServerService)

local playerDataServerSetup = {}
local profileTemplate = {
	Money = 0,
	Builds = {},
	Dummys = {},
	Settings = {},
}

function playerDataServerSetup.new()
    local playerDataServer= PlayerDataServerService.new(profileTemplate)

    Players.PlayerAdded:Connect(function(player)
        playerDataServer:playerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        playerDataServer:playerRemoving(player)
    end)

end


return playerDataServerSetup