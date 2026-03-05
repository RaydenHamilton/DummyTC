local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local serverEvents = require(ReplicatedStorage.Blink.server)

local BuildServer = {}

local function placeBuild(owner: Player, objectName: BasePart, objectCFrame: CFrame)
	local NewBuild: BasePart = ReplicatedStorage.Assets.Builds[objectName]:Clone()
	NewBuild.Parent = Workspace
	NewBuild.CFrame = objectCFrame
	NewBuild:SetAttribute("Owner", owner.UserId)
end

function BuildServer.new(owner, objectName, objectCFrame)
	placeBuild(owner, objectName, objectCFrame)
end

function BuildServer.init()
	serverEvents.PlaceBuild.On(function(player, Cframe, objectName)
		BuildServer.new(player, objectName, Cframe)
	end)
end

return BuildServer
