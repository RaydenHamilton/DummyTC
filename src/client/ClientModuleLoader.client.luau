local ReplicatedStorage = game:GetService("ReplicatedStorage")

local buildClient =
	require(ReplicatedStorage:WaitForChild("Shared").ModuleUniversal.BuildHandler.Implementation._BuildClient)
buildClient.init()
