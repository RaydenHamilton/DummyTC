--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// Const
local GRID = 12
local inputs = ReplicatedStorage.Inputs.InputContext

local floors = {}
local walls = {}

--// Varaibles
local newBuild: BasePart
local renderStepped: RBXScriptConnection
local XOffSet: number = 0
local ZOffSet: number = 0
local Rotation: number = 0
local lastSnapped: CFrame

--// Module
local buildClient = {}

local function clearOldFunction()
	if renderStepped then
		renderStepped:Disconnect()
	end
	if newBuild then
		newBuild:Destroy()
	end
end

local function placeFloor()
	XOffSet = 0
	ZOffSet = 0
	Rotation = 0
end

local function placeWall()
	XOffSet = 6
	ZOffSet = 0
	Rotation = 0
end

local function getSnapPosition()
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.TargetFilter = newBuild

	local mousePos = mouse.Hit.Position
	local OffSet = newBuild.Size.Y / 2

	local snapped = CFrame.new(
		math.round(mousePos.X / GRID) * GRID + XOffSet,
		math.round(mousePos.Y / GRID) * GRID + OffSet,
		math.round(mousePos.Z / GRID) * GRID + ZOffSet
	) * CFrame.Angles(0, math.rad(Rotation), 0)
	return snapped
end

local function canMoveThere(snap)
	local gridType = newBuild:GetAttribute("GridType")
	local gridString = snap.X .. "." .. snap.Z
	if gridType == "Wall" then
		if walls[gridString] then
			return false
		end
	elseif gridType == "Floor" then
		if floors[gridString] then
			return false
		end
	end
	return true
end

local function movePart(snapped)
	newBuild.CFrame = newBuild.CFrame:Lerp(snapped, 0.4)
end

function buildClient.new(objectName: string)
	local build = ReplicatedStorage.Assets.Builds:FindFirstChild(objectName)

	clearOldFunction()
	if not build then
		warn("Button does not match Build Name")
		return
	end

	newBuild = build:Clone()
	newBuild.CanCollide = false
	newBuild.Parent = Workspace
	newBuild.Transparency = 0.7
	--// Varaibles
	local gridType = newBuild:GetAttribute("GridType")

	--// Offesets
	if gridType == "Floor" then
		placeFloor()
	elseif gridType == "Wall" then
		placeWall()
	end

	--// Reder Mouse
	renderStepped = RunService.RenderStepped:Connect(function()
		local newSnapped = getSnapPosition()
		--TODO find next posible spot
		if canMoveThere(newSnapped) then
			movePart(newSnapped)
			lastSnapped = getSnapPosition()
		end
	end)
end

inputs.PlaceBuild.StateChanged:Connect(function(boolean)
	if not boolean or not newBuild then
		return
	end
	local gridType = newBuild:GetAttribute("GridType")

	local gridString = lastSnapped.X .. "." .. lastSnapped.Z
	if gridType == "Wall" then
		walls[gridString] = true
	elseif gridType == "Floor" then
		floors[gridString] = true
	end
	-- clearOldFunction()
	-- fire server
end)

inputs.RotateBuild.StateChanged:Connect(function(boolean)
	if not boolean then
		return
	end
	Rotation += 90
	if newBuild and newBuild:GetAttribute("GridType") == "Wall" then
		if Rotation % 360 == 0 then
			print(0)
			XOffSet = 6
			ZOffSet = 0
			Rotation = 0
		elseif Rotation % 270 == 0 then
			print(1)
			XOffSet = 0
			ZOffSet = -6
		elseif Rotation % 180 == 0 then
			print(2)
			XOffSet = -6
			ZOffSet = 0
		elseif Rotation % 90 == 0 then
			print(3)
			XOffSet = 0
			ZOffSet = 6
		end
	end
end)

return buildClient
