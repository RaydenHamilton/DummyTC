--// Services
local CreationDBService = game:GetService("CreationDBService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

--// Modueles
local client = require(ReplicatedStorage.Blink.client)

--// Module
local DummyBuilderClient = {}

--// Varuibles
local dummyData: {} = {}
local shop = Workspace.DummyShop
local player = Players.LocalPlayer

local dummyBuildOrder = {
	["Neck"] = { "Head" },

	["Head"] = {},

	["Torso 1"] = { "Neck", "Arm L1", "Arm R1" },
	["Torso 2"] = { "Torso 1", "Torso 3" },
	["Torso 3"] = { "Waist 1" },

	["Waist 1"] = { "Waist 2" },
	["Waist 2"] = { "Thigh L1", "Thigh R1" },

	["Elbow L"] = { "Arm L3" },
	["Elbow R"] = { "Arm R3" },

	["Arm L1"] = { "Arm L2" },
	["Arm L2"] = { "Elbow L" },
	["Arm L3"] = { "Arm L4" },
	["Arm L4"] = { "Wrist L" },
	["Arm R1"] = { "Arm R2" },
	["Arm R2"] = { "Elbow R" },
	["Arm R3"] = { "Arm R4" },
	["Arm R4"] = { "Wrist R" },

	["Wrist L"] = { "Fist L" },
	["Wrist R"] = { "Fist R" },

	["Cheek L"] = {},
	["Cheek R"] = {},

	["Fist L"] = {},
	["Fist R"] = {},

	["Foot L"] = {},
	["Foot R"] = {},

	["Ankle L"] = { "Foot L" },
	["Ankle R"] = { "Foot R" },

	["Knee L"] = { "Shin L1" },
	["Knee R"] = { "Shin R1" },

	["Thigh L1"] = { "Cheek L", "Thigh L2" },
	["Thigh L2"] = { "Knee L" },
	["Thigh R1"] = { "Cheek R", "Thigh R2" },
	["Thigh R2"] = { "Knee R" },

	["Shin L1"] = { "Shin L2" },
	["Shin L2"] = { "Shin L3" },
	["Shin L3"] = { "Ankle L" },
	["Shin R1"] = { "Shin R2" },
	["Shin R2"] = { "Shin R3" },
	["Shin R3"] = { "Ankle R" },
}

--// Functions
local function getDummyData(...)
	local tempData = { ... }
	for i in tempData do
		if i % 2 == 0 then
			continue
		end
		dummyData[tempData[i]] = tempData[i + 1]
	end
end

local function createBuyButton(partName: string)
	local Part: BasePart = shop["dummy parts"][partName]
	local buyPart = Instance.new("Part")

	print()
	local first = partName:sub(partName:len() - 1, partName:len() - 1)
	local second = partName:sub(partName:len(), partName:len())

	local yOffset = 0.4

	local offset = Vector3.new(-0, yOffset, 0)
	if first == "R" or second == "R" then
		offset = Vector3.new(-0, yOffset, -1)
	elseif first == "L" or second == "L" then
		offset = Vector3.new(-0, yOffset, 1)
	end

	buyPart.Anchored = true
	buyPart.Parent = Part
	buyPart.Position = Part.Position + offset
	buyPart.Transparency = 1

	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Parent = buyPart
	surfaceGui.Face = "Left"
	surfaceGui.ClipsDescendants = false

	local buyButton = Instance.new("TextButton")
	buyButton.AnchorPoint = Vector2.new(0.5, 0.5)
	buyButton.Position = UDim2.fromScale(0.5, 0.5)
	buyButton.Size = UDim2.fromScale(1, 1)
	buyButton.Parent = surfaceGui
	buyButton.Font = Enum.Font.IndieFlower
	buyButton.TextStrokeTransparency = 1
	buyButton.TextXAlignment = Enum.TextXAlignment.Center
	buyButton.TextYAlignment = Enum.TextYAlignment.Bottom
	buyButton.TextScaled = true
	buyButton.RichText = true
	buyButton.BackgroundTransparency = 1
	buyButton.TextColor3 = Color3.new(1, 1, 1)

	buyButton.Text = `{partName}\n(-)`

	local tweenInfo = TweenInfo.new(
		0.1, -- time
		Enum.EasingStyle.Bounce,
		Enum.EasingDirection.Out
	)

	local CHANGE = 0.7

	local normalSize = buyPart.Size
	local largeSize = buyPart.Size + Vector3.new(0, CHANGE, CHANGE)
	local normalPosition = buyPart.Position
	local largePosition = buyPart.Position - Vector3.new(0, -CHANGE / 4, 0)

	local enterTween = TweenService:Create(buyPart, tweenInfo, { Size = largeSize, Position = largePosition })
	local leaveTween = TweenService:Create(buyPart, tweenInfo, { Size = normalSize, Position = normalPosition })

	buyButton.MouseEnter:Connect(function()
		buyButton.Text = `{partName}\n(+)`
		enterTween:Play()
	end)
	buyButton.MouseLeave:Connect(function()
		buyButton.Text = `{partName}\n(-)`
		leaveTween:Play()
	end)
	buyButton.MouseButton1Click:Connect(function()
		makeNextPartBuyable(Part, buyPart)
		Part.Transparency = 0
		Part.Color = Part:GetAttribute("Color") :: Color3
		buyPart:Destroy()
	end)
end

function makeNextPartBuyable(Part: BasePart, UI: BasePart)
	for _, limb in dummyBuildOrder[Part.Name] do
		createBuyButton(limb)
	end
end

local function makeDummyBuyable()
	if not dummyData["NormalDummy"] then
		createBuyButton("Torso 2")
	end
end

local function buildDummy()
	for _, part: BasePart in shop["dummy parts"]:GetChildren() do
		part:SetAttribute("Color", part.Color)
		part.Transparency = 0.4
		part.Color = Color3.new(0, 0, 1)
	end

	makeDummyBuyable()
end

local function moveCameraToShop()
	local PlayerCamera = Workspace.CurrentCamera

	PlayerCamera.CameraType = Enum.CameraType.Scriptable
	PlayerCamera.CFrame = shop.Cam.CFrame
	PlayerCamera.FieldOfView = 60
end

local function moveCameraToPlayer()
	local PlayerCamera = Workspace.CurrentCamera

	PlayerCamera.CameraType = Enum.CameraType.Custom
	PlayerCamera.CameraSubject = player.Character.Humanoid
	PlayerCamera.FieldOfView = 70
end

function DummyBuilderClient.init()
	client.GetDummyData.On(getDummyData)
	moveCameraToShop()
	buildDummy()
end

return DummyBuilderClient
