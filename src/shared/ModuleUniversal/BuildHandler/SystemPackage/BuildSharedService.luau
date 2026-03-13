local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local buildShared = {}

function buildShared.getIndexString(buildCFrame: CFrame, buildName: string)
	local offset = Workspace:WaitForChild("Map"):WaitForChild("Baseplate").Position
	local newCFrame = buildCFrame - offset + Vector3.new(0, offset.Y, 0)
	local build = ReplicatedStorage.Assets.Builds[buildName]
	local gridString = newCFrame.X .. "." .. (newCFrame.Y - build.Size.Y / 2) .. "." .. newCFrame.Z
	return gridString
end

return buildShared
