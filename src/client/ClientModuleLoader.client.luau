local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage:WaitForChild("Shared").ModuleUniversal

local MoveToBaseClient = require(script.Parent.MoveToBaseClient)
local buildClient = require(modules.BuildHandler.Implementation._BuildClient)
local dummyBuilderClient = require(modules.DummyBuilderHanlder.Implementation._DummyBuilderClientSetup)

MoveToBaseClient.init()
buildClient.init()
dummyBuilderClient.init()
