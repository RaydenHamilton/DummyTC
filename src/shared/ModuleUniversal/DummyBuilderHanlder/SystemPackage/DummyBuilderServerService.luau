local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local server = require(ReplicatedStorage.Blink.server)
local playerData = require(script.Parent.Parent.Parent.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local DummyBuilderServer = {}

local function getPlayerData(player: Player)
	-- local playerDummyData = playerData.get(player, "Dummys")

	-- local DummyName
	-- local DummyBuffer
	-- for i,v in playerDummyData do
	--     DummyName = i
	--     DummyBuffer = v
	-- end
	-- server.GetDummyData.Fire(player, DummyName, DummyBuffer,DummyName, DummyBuffer,DummyName, DummyBuffer)
end

function DummyBuilderServer.init()
	Players.PlayerAdded:Connect(function(player)
		getPlayerData(player)
	end)
end

return DummyBuilderServer
