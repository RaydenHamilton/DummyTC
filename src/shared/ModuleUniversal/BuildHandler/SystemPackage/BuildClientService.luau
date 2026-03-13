--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// Modules
local clientEvents = require(ReplicatedStorage.Blink.client)
local buildSharedService = require(script.Parent.BuildSharedService)

--// Const
local GRID = 12

--// Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local removeHighLight: Highlight = Instance.new("Highlight")
local inputs = ReplicatedStorage.Inputs.InputContext

local builds = {}

--// Defaults
local newBuild: BasePart
local renderStepped: RBXScriptConnection
local XOffSet: number = 0
local ZOffSet: number = 0
local Rotation: number = 0
local lastSnapped: CFrame
local placementState = "Idle"

--// Module
local buildClient = {}

local function setClientBuildData(playerBuildData)
	local str = string.split(playerBuildData, " ")
	for _, ChangeIndex in str do
		if ChangeIndex == "" then
			break
		end
		builds[ChangeIndex] = true
	end
end

function buildClient.init()
	clientEvents.SetClientData.On(setClientBuildData)
end

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
	local offSet = newBuild.Size.Y / 2

	local snapped = CFrame.new(
		math.round(mousePos.X / GRID) * GRID + XOffSet,
		math.floor((mousePos.Y + 1) / GRID) * GRID + offSet,
		math.round(mousePos.Z / GRID) * GRID + ZOffSet
	) * CFrame.Angles(0, -math.rad(Rotation), 0)
	return snapped
end

local function canMoveThere(snap: CFrame)
	local index = buildSharedService.getIndexString(snap, newBuild.Name)
	if builds[index] then
		return false
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

inputs.RemoveBuild.Pressed:Connect(function()
	if placementState ~= "Removing" then
		return
	end
	local targetPart = mouse.Target
	if canRemove(targetPart) then
		removeHighLight.Parent = nil
		clientEvents.RemoveBuild.Fire(targetPart)
		local index = buildSharedService.getIndexString(targetPart.CFrame, mouse.Target.Name)
		builds[index] = nil
	end
end)

inputs.PlaceBuild.Pressed:Connect(function()
	if not newBuild or placementState ~= "Enabled" then
		return
	end
	if canMoveThere(lastSnapped) then
		clientEvents.PlaceBuild.Fire(lastSnapped, newBuild.Name)
	end

	local index = buildSharedService.getIndexString(lastSnapped, newBuild.Name)
	builds[index] = true
end)

inputs.ClearBuild.Pressed:Connect(function()
	clearOldFunction()
	placementState = "Idle"
end)

inputs.RotateBuild.Pressed:Connect(function()
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
