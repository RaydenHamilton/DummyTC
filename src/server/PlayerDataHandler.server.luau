local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataSetup =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.Implementation._PlayerDataServerSetup)

PlayerDataSetup.init()


