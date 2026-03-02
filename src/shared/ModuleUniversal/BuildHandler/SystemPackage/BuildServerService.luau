local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local BuildServer = {}

local function placeBuild(owner: Player, objectName: BasePart, objectCFrame: CFrame)
	local NewBuild: BasePart = ReplicatedStorage.Assets.Builds[objectName]:Clone()
	NewBuild.Parent = Workspace
	NewBuild.CFrame = objectCFrame
	NewBuild:SetAttribute("Owner", owner    )
end

function BuildServer.new(owner, objectName, objectCFrame)
	placeBuild(owner, objectName, objectCFrame)
end

return BuildServer
