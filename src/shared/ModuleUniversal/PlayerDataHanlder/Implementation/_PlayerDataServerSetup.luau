local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataServerService =
	require(ReplicatedStorage.Shared.ModuleUniversal.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local playerDataServerSetup = {}
playerDataServerSetup.__index = playerDataServerSetup

local profileTemplate = {
	Money = 0,
	Damage = 0,
	MaxDamage = 0,
	Experience = 0,
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
