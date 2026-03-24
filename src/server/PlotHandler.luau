local PlayerEmulatorService = game:GetService("PlayerEmulatorService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local plotHandler = {}

local plots = {}

local function loadPlot(player: Player)
	local count = 1

	while plots[count] do
		count += 1
	end

	local plot = ReplicatedStorage.Assets.Plots.Plot:Clone()
	plot.Parent = Workspace.Bases
	plot:PivotTo(CFrame.new(0, -120 * count - 0.5, 0))
	plot.Name = player.UserId

	plots[count] = player
end

local function removePlayerFromPlot(player: Player)
	for index, plotData in plots do
		if player == plotData then
			plots[index] = nil

			Workspace.Bases[player.UserId]:Destroy()
		end
	end
end

function plotHandler.init()
	Players.PlayerAdded:Connect(loadPlot)
	Players.PlayerRemoving:Connect(removePlayerFromPlot)
end

return plotHandler
