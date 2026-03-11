local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local playerData = require(script.Parent.Parent.Parent.PlayerDataHanlder.SystemPackage.PlayerDataServerService)
local serverEvents = require(ReplicatedStorage.Blink.server)

local BuildServer = {}

local function changePlayerData(player: Player, name: string, cframe: CFrame)
	local offset = Workspace:WaitForChild("Map"):WaitForChild("Baseplate").Position
	local newCFrame = cframe - offset + Vector3.new(0, offset.Y, 0)
	local newBuild: BasePart = ReplicatedStorage.Assets.Builds[name]
	local playerBuilds = playerData.get(player, "Builds")
	local gridString = newCFrame.X .. "." .. (newCFrame.Y - newBuild.Size.Y / 2) .. "." .. newCFrame.Z
	playerBuilds[gridString] = { name, { newCFrame:GetComponents() } }

	playerData.set(player, "Builds", playerBuilds)
end

local function placeBuild(player: Player, objectName: string, objectCFrame: CFrame)
	local NewBuild: BasePart = ReplicatedStorage.Assets.Builds[objectName]:Clone()
	NewBuild.Parent = Workspace[player.UserId]
	NewBuild.CFrame = objectCFrame
	NewBuild:SetAttribute("Owner", player.UserId)
end

function BuildServer.new(player: Player, objectCFrame: CFrame, objectName: string)
	-- local offset = Workspace[player.UserId]..CFrame

	placeBuild(player, objectName, objectCFrame)
	changePlayerData(player, objectName, objectCFrame)
end

function BuildServer.init()
	serverEvents.PlaceBuild.On(BuildServer.new)
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
		placeBuild(player, name, cframe)
	end
end

function BuildServer.playerRemoved(player: Player)
	if Workspace[player.UserId].Parent then
		Workspace[player.UserId]:Destory()
	end
end

return BuildServer
