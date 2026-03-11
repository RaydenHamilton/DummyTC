local Players = game:GetService("Players")
local buildClientService = require(script.Parent.Parent.SystemPackage.BuildClientService)

local buildClient = {}

function buildClient.init()
	local player = Players.LocalPlayer
	local playerGui = player.PlayerGui
	local builds = playerGui:WaitForChild("Menu")

	for _, buildButton: GuiButton in builds:GetChildren() do
		buildButton.Activated:Connect(function()
			buildClientService.new(buildButton.Name)
		end)
	end

	builds:WaitForChild("Remove").Activated:Connect(function()
		print("remove")
		buildClientService.remove()
	end)
end

return buildClient
