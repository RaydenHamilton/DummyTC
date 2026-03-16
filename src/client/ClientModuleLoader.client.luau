local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage:WaitForChild("Shared").ModuleUniversal

local buildClient = require(modules.BuildHandler.Implementation._BuildClient)
local dummyBuilderClient = require(modules.DummyBuilderHanlder.Implementation._DummyBuilderClientSetup)

buildClient.init()
dummyBuilderClient.init()
