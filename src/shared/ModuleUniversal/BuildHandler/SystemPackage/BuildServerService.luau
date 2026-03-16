--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local playerData = require(script.Parent.Parent.Parent.PlayerDataHanlder.SystemPackage.PlayerDataServerService)
local serverEvents = require(ReplicatedStorage.Blink.server)
local buildSharedService = require(script.Parent.BuildSharedService)
local network = require(script.Parent.BuildNetwork)

local BuildServer = {}

function BuildServer.init()
	serverEvents.PlaceBuild.On(BuildServer.new)
	serverEvents.RemoveBuild.On(BuildServer.remove)
end

local function addBuildToPlayerData(player: Player, name: string, cframe: CFrame)
	local offset = Workspace:WaitForChild("Map"):WaitForChild("Baseplate").Position
	local newCFrame = cframe - offset + Vector3.new(0, offset.Y, 0)

	local playerBuilds = playerData.get(player, "Builds")
	local index = buildSharedService.getIndexString(cframe, name)
	playerBuilds[index] = { name, { newCFrame:GetComponents() } }

	playerData.set(player, "Builds", playerBuilds)
end

local function addBuild(player: Player, objectName: string, objectCFrame: CFrame)
	local NewBuild: BasePart = ReplicatedStorage.Assets.Builds[objectName]:Clone()
	NewBuild.Parent = Workspace[player.UserId]
	NewBuild.CFrame = objectCFrame
	NewBuild:SetAttribute("Owner", player.UserId)
end

function BuildServer.new(player: Player, objectCFrame: CFrame, objectName: string)
	local playerBuilds = playerData.get(player, "Builds")
	local index = buildSharedService.getIndexString(objectCFrame, objectName)

	if not playerBuilds[index] then
		addBuild(player, objectName, objectCFrame)
		addBuildToPlayerData(player, objectName, objectCFrame)
	end
end

local function removeBuild(build: BasePart)
	build:Destroy()
end

local function removeBuildFromData(player, build: BasePart)
	local playerBuilds = playerData.get(player, "Builds")
	local index = buildSharedService.getIndexString(build.CFrame, build.Name)

	if not playerBuilds[index] then
		warn("Build data not found")
	end

	playerBuilds[index] = nil

	playerData.set(player, "Builds", playerBuilds)
end

local function playerOwnsBuild(player: Player, build: BasePart)
	local buildOwner = build:GetAttribute("Owner")
	return buildOwner and buildOwner == player.UserId
end

function BuildServer.remove(player: Player, build: BasePart)
	if playerOwnsBuild(player, build) then
		removeBuildFromData(player, build)
		removeBuild(build)
	end
end

function BuildServer.playerAdded(player: Player)
	local buildFolder = Instance.new("Folder")
	buildFolder.Name = player.UserId
	buildFolder.Parent = Workspace
	repeat
		task.wait()
	until playerData.get(player, "Builds")
	local playerBuilds = playerData.get(player, "Builds")

	local offset = Workspace:WaitForChild("Map"):WaitForChild("Baseplate").Position

	for _, buildData in playerBuilds do
		local name = buildData[1]
		local cframe = CFrame.new(table.unpack(buildData[2])) + offset - Vector3.new(0, offset.Y, 0)
		addBuild(player, name, cframe)
	end

	network.fireSetClientData(player, playerBuilds)
end

function BuildServer.playerRemoved(player: Player)
	local playerFolder: Folder = Workspace[player.UserId]
	if playerFolder.Parent then
		playerFolder:Destroy()
	end
end

return BuildServer
