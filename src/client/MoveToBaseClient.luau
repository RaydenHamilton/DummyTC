local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local BuildClientService =
	require(ReplicatedStorage.Shared.ModuleUniversal.BuildHandler.SystemPackage.BuildClientService)
local DummyBuilderClientService =
	require(ReplicatedStorage.Shared.ModuleUniversal.DummyBuilderHanlder.SystemPackage.DummyBuilderClientService)

local MoveToClient = {}

local goingToBase = true

--TODO move player on server not client

local function movePlayer()
	local player = Players.LocalPlayer
	local base: Model = Workspace.Bases[player.UserId]
	local rootPart: BasePart = player.Character

	if goingToBase then
		rootPart:PivotTo(CFrame.new(base.Spawn.Position))
	else
		rootPart:PivotTo(CFrame.new(0, 10, 0))
	end

	player.PlayerGui.Menu.Enabled = goingToBase

	if not goingToBase then
		BuildClientService.clearOldFunction()
	end
	goingToBase = not goingToBase
end

function MoveToClient.init()
	Players.LocalPlayer.PlayerGui:WaitForChild("HUD").GoToBase.Activated:Connect(movePlayer)
end

return MoveToClient
