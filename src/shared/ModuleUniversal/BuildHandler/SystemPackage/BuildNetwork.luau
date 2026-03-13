local ReplicatedStorage = game:GetService("ReplicatedStorage")

local serverEvents = require(ReplicatedStorage.Blink.server)

local network = {}

function network.fireSetClientData(player, playerBuilds)
	local indexs = ""
	for index in playerBuilds do
		indexs = indexs .. index .. " "
	end

	serverEvents.SetClientData.Fire(player, indexs)
end

return network
