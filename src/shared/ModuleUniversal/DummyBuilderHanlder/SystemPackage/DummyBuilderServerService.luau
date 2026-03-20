local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DummyBuilderSharedService = require(script.Parent.DummyBuilderSharedService)
local server = require(ReplicatedStorage.Blink.server)
local _PlayerDataServerSetup =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.Implementation._PlayerDataServerSetup)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)
local playerData = require(script.Parent.Parent.Parent.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local DummyBuilderServer = {}

local function makeDummyDataToBuffer(data)
	local dummyBuffer = buffer.create(#DummyBuilderSharedService.DummyLimbs)

	for index, partName in DummyBuilderSharedService.DummyLimbs do
		local partEnabled = data[partName]
		buffer.writei8(dummyBuffer, index, partEnabled and 1 or 0)
		print(`{partName}: {partEnabled and 1 or 0}`)
	end

	return dummyBuffer
end

local function sendPlayerDataBackToClient(player: Player, dummyName)
	local dummysData = PlayerDataServerService.get(player, "Dummys")
	local dummyData = dummysData[dummyName]
	makeDummyDataToBuffer(dummyData)

	-- server.RespondRequestToClientRequestForDummyData.Fire(dummyName, DummyData)
end

local function setClientPlayerData(player: Player, partName)
	local newdata = playerData.get(player, "Dummys")

	if not newdata["NormalDummy"] then
		newdata["NormalDummy"] = {}
	end
	newdata["NormalDummy"][partName] = true

	playerData.set(player, "Dummys", newdata)
end

local function buyDummyPart(player, partName)
	setClientPlayerData(player, partName)
end

function DummyBuilderServer.init()
	server.BuyDummyPart.On(buyDummyPart)
	server.SendRequestForDummyData.On(sendPlayerDataBackToClient)
end

return DummyBuilderServer
