-- this is a TEST Script
game:IsLoaded()
local damagePart = require(script.DamageDummyService)
local conveyor = require(script.ConveyorService)
local dummySpawner = require(script.DummySpawnerService)
local collecter = require(script.Collecter)

dummySpawner.new(-346, 0.25, 34)
damagePart.new()
conveyor.new()
collecter.new()

