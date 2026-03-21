local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DummyBuilderSharedService = require(script.Parent.DummyBuilderSharedService)
local server = require(ReplicatedStorage.Blink.server)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local DummyBuilderServer = {}

local function makeDummyDataToBuffer(data)
	local dummyBuffer = buffer.create(#DummyBuilderSharedService.DummyLimbs)

	for index, partName in DummyBuilderSharedService.DummyLimbs do
		local partEnabled = data[partName]
		buffer.writei8(dummyBuffer, index - 1, partEnabled and 1 or 0)
		print(`{partName}: {partEnabled and 1 or 0}`)
	end

	return dummyBuffer
end

local function sendPlayerDataBackToClient(player: Player, dummyName)
	local dummysData = PlayerDataServerService.get(player, "Dummys")
	local dummyData = dummysData[dummyName]
	local dataForPlayer = makeDummyDataToBuffer(dummyData)

	server.RespondRequestToClientRequestForDummyData.Fire(player, dummyName, dataForPlayer)
end

local function setClientPlayerData(player: Player, partName)
	local newdata = PlayerDataServerService.get(player, "Dummys")

	if not newdata["NormalDummy"] then
		newdata["NormalDummy"] = {}
	end
	newdata["NormalDummy"][partName] = true

	PlayerDataServerService.set(player, "Dummys", newdata)
end

local function buyDummyPart(player, partName)
	setClientPlayerData(player, partName)
end

function DummyBuilderServer.init()
	server.BuyDummyPart.On(buyDummyPart)
	server.SendRequestForDummyData.On(sendPlayerDataBackToClient)
end

return DummyBuilderServer
