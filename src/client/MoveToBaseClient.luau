local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

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
	goingToBase = not goingToBase
end

function MoveToClient.init()
	Players.LocalPlayer.PlayerGui:WaitForChild("HUD").GoToBase.Activated:Connect(movePlayer)
end

return MoveToClient
