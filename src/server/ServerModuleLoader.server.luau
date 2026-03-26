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

local damagePart = require(script.Parent.BuildTags.DamageDummyService)
local conveyor = require(script.Parent.BuildTags.ConveyorService)
local dummySpawner = require(script.Parent.BuildTags.DummySpawnerService)
local collector = require(script.Parent.BuildTags.Collector)
damagePart.init()
conveyor.init()
dummySpawner.init()
collector.init()
