local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Shared.ModuleUniversal
local playerData = require(Modules.PlayerDataHanlder.Implementation._PlayerDataServerSetup)
local builds = require(Modules.BuildHandler.Implementation._BuildServer)
local dummyBuilder = require(Modules.DummyBuilderHanlder.Implementation._DummyBuilderServerSetup)
local PlotHandler = require(script.Parent.PlotHandler)

PlotHandler.init()
builds.init()
playerData.init()
dummyBuilder.init()

-- this is a TEST Script
game:IsLoaded()

local damagePart = require(script.Parent.DamageDummyService)
local conveyor = require(script.Parent.ConveyorService)
local dummySpawner = require(script.Parent.DummySpawnerService)
local collecter = require(script.Parent.Collecter)
damagePart.new()
conveyor.new()

Players.PlayerAdded:Connect(function(player)
	collecter.new(player, Workspace.Bases.Builds.killpart)
	dummySpawner.init(player, -346, 0.25, 34)
end)
