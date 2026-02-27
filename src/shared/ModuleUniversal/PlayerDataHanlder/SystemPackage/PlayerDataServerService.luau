--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Packages
local ProfileStore = require(ReplicatedStorage.Packages.Profilestore)

--// Module
local PlayerDataServer = {}
PlayerDataServer.__index = PlayerDataServer

function PlayerDataServer.new(newTemplate: { any })
	local self = setmetatable({}, PlayerDataServer)
	self.PlayerStore = ProfileStore.New("PlayerStore", newTemplate)
	self.Profiles = {} :: { [Player]: typeof(self.PlayerStore:StartSessionAsync()) }
	self.Signals = {}

	for _, player in Players:GetPlayers() do
		task.spawn(self:playerAdded(player))
	end

	return self
end

function PlayerDataServer:set(player, valueName, NewValue)
	self.Profiles[player][valueName] = NewValue
end

function PlayerDataServer:get(player, valueName)
	return self.Profiles[player][valueName]
end

function PlayerDataServer:add(player, valueName, NewValue)
	if typeof(self.Profiles[player][valueName]) == "number" then
		self.Profiles[player][valueName] += NewValue
	else
		warn(valueName .. " is not a number")
	end
end

function PlayerDataServer:playerAdded(player: Player)
	-- Start a profile session for this player's data:

	local profile = self.PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		profile.OnSessionEnd:Connect(function()
			self.Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			-- print(profile)
			self.Profiles[player] = profile
			-- print(`Profile loaded for {player.DisplayName}!`)
			self:setupPlayer(player)
		-- otherwise you'll have to check whether "Data.Cash" is not nil
		else
			-- The player has left before the profile session started
			profile:EndSession()
		end
	else
		-- This condition should only happen when the Roblox server is shutting down
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

function PlayerDataServer:playerRemoving(player: Player)
	local profile = self.Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end


return table.freeze(PlayerDataServer)
