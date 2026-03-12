--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// Modules
local clientEvents = require(ReplicatedStorage.Blink.client)

--// Const
local GRID = 12
local inputs = ReplicatedStorage.Inputs.InputContext

--// variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local removeHighLight: Highlight = Instance.new("Highlight")

local floors = {}
local walls = {}

--// Varaibles
local newBuild: BasePart
local renderStepped: RBXScriptConnection
local XOffSet: number = 0
local ZOffSet: number = 0
local Rotation: number = 0
local lastSnapped: CFrame
local placementState = "Idle"

--// Module
local buildClient = {}

local function buildTransparency(number)
	newBuild.Transparency = number
	for _, child in newBuild:GetDescendants() do
		if child:IsA("Decal") or child:IsA("BasePart") then
			child.Transparency = number
			placementState = number == 1 and "Disabled" or "Enabled"
		end
	end
end

local function clearOldFunction()
	if renderStepped then
		renderStepped:Disconnect()
	end
	if newBuild then
		newBuild:Destroy()
		newBuild = nil
	end
end

local function setFloorOffset()
	XOffSet = 0
	ZOffSet = 0
	Rotation = 0
end

local function setWallOffset()
	XOffSet = 6
	ZOffSet = 0
	Rotation = 0
end

local function getSnapPosition()
	mouse.TargetFilter = newBuild

	local mousePos = mouse.Hit.Position
	local OffSet = newBuild.Size.Y / 2

	local snapped = CFrame.new(
		math.round(mousePos.X / GRID) * GRID + XOffSet,
		math.floor((mousePos.Y + 1) / GRID) * GRID + OffSet,
		math.round(mousePos.Z / GRID) * GRID + ZOffSet
	) * CFrame.Angles(0, -math.rad(Rotation), 0)
	return snapped
end

local function canMoveThere(snap)
	local gridType = newBuild:GetAttribute("GridType")
	local gridString = snap.X .. "." .. (snap.Y - newBuild.Size.Y / 2) .. "." .. snap.Z
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
		warn(`{objectName} does not exist in builds`)
		return
	end

	newBuild = build:Clone()
	newBuild.CanCollide = false
	newBuild.Parent = Workspace
	buildTransparency(0.7)
	--// Varaibles
	local gridType = newBuild:GetAttribute("GridType")

	--// Offesets
	if gridType == "Floor" then
		setFloorOffset()
	elseif gridType == "Wall" then
		setWallOffset()
	end

	--// Reder Mouse
	renderStepped = RunService.RenderStepped:Connect(function()
		local newSnapped = getSnapPosition()
		--TODO find next posible spot
		if canMoveThere(newSnapped) then
			buildTransparency(0.7)
			movePart(newSnapped)
			lastSnapped = getSnapPosition()
		else
			buildTransparency(1)
			movePart(newSnapped)
		end
	end)
end

local function canRemove(part: BasePart?)
	return part
		and part.Parent
		and part:GetAttribute("Owner")
		and part:GetAttribute("Owner") == player.UserId
		and placementState == "Removing"
end

function buildClient.remove()
	clearOldFunction()
	placementState = "Removing"
	RunService.RenderStepped:Connect(function()
		local removeAblePart = mouse.Target

		if not canRemove(removeAblePart) then
			removeHighLight.Parent = nil
			return
		end

		removeHighLight.Parent = removeAblePart
	end)
end

inputs.PlaceBuild.StateChanged:Connect(function(boolean)
	if not boolean and placementState ~= "Removing" then
		return
	end
	local targetPart = mouse.Target
	if canRemove(targetPart) then
		removeHighLight.Parent = nil
		clientEvents.RemoveBuild.Fire(targetPart)
	end
end)

inputs.PlaceBuild.StateChanged:Connect(function(boolean)
	if not boolean or not newBuild or placementState ~= "Enabled" then
		return
	end
	if canMoveThere(lastSnapped) then
		clientEvents.PlaceBuild.Fire(lastSnapped, newBuild.Name)
	end

	local gridType = newBuild:GetAttribute("GridType")
	local gridString = lastSnapped.X .. "." .. (lastSnapped.Y - newBuild.Size.Y / 2) .. "." .. lastSnapped.Z
	if gridType == "Wall" then
		walls[gridString] = true
	elseif gridType == "Floor" then
		floors[gridString] = true
	end
end)

inputs.ClearBuild.StateChanged:Connect(function(boolean)
	if not boolean then
		return
	end
	clearOldFunction()
	placementState = "Idle"
end)

inputs.RotateBuild.StateChanged:Connect(function(boolean)
	if not boolean then
		return
	end
	Rotation += 90
	if newBuild and newBuild:GetAttribute("GridType") == "Wall" then
		if Rotation % 360 == 0 then
			XOffSet = 6
			ZOffSet = 0
			Rotation = 0
		elseif Rotation % 270 == 0 then
			XOffSet = 0
			ZOffSet = -6
		elseif Rotation % 180 == 0 then
			XOffSet = -6
			ZOffSet = 0
		elseif Rotation % 90 == 0 then
			XOffSet = 0
			ZOffSet = 6
		end
	end
end)

return buildClient
