local Players = game:GetService("Players")

local DummyBuilderClient = {}

local moveCameraToShop = true

function DummyBuilderClient.init()
	local clientBulder = require(script.Parent.Parent.SystemPackage.DummyBuilderClientService)
	clientBulder.init()
	Players.LocalPlayer.PlayerGui.HUD.DummyShop.Activated:Connect(function()
		if moveCameraToShop then
			clientBulder.moveCameraToShop()
		else
			clientBulder.moveCameraToPlayer()
		end

		moveCameraToShop = not moveCameraToShop
	end)
end

return DummyBuilderClient
