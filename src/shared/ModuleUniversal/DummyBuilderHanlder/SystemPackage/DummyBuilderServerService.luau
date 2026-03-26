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
	end

	return dummyBuffer
end

local function sendPlayerDataBackToClient(player: Player, dummyName)
	local allDummyData

	repeat
		allDummyData = PlayerDataServerService.get(player, "Dummys")
	until allDummyData

	local dummyData = allDummyData[dummyName]
	if not dummyData then
		dummyData = {}
	end
	local dataForPlayer = makeDummyDataToBuffer(dummyData)

	server.RespondRequestToClientRequestForDummyData.Fire(player, dummyName, dataForPlayer)
end

local function setClientPlayerData(player: Player, dummyName, partName)
	local newdate = PlayerDataServerService.get(player, "Dummys")

	if not newdate[dummyName] then
		newdate[dummyName] = {}
	end
	newdate[dummyName][partName] = true

	PlayerDataServerService.set(player, "Dummys", newdate)
end

local function buyDummyPart(player, dummyName, partName)
	setClientPlayerData(player, dummyName, partName)
end

function DummyBuilderServer.init()
	server.BuyDummyPart.On(buyDummyPart)
	server.SendRequestForDummyData.On(sendPlayerDataBackToClient)
end

return DummyBuilderServer
