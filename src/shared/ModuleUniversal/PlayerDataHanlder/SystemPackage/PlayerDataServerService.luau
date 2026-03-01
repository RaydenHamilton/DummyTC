--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Packages
local ProfileStore = require(ReplicatedStorage.Packages.Profilestore)

--// Module
local PlayerDataServer = {}

local PlayerStore
local Profiles

function PlayerDataServer.init(newTemplate: { any })
	PlayerStore = ProfileStore.New("Dummy", newTemplate)
	Profiles = {} :: { [Player]: typeof(PlayerStore:StartSessionAsync()) }

	for _, player in Players:GetPlayers() do
		task.spawn(PlayerDataServer.playerAdded(player))
	end
end

function PlayerDataServer.set(player, valueName, NewValue)
	if Profiles[player] then
		Profiles[player]["Data"][valueName] = NewValue
	end
end

function PlayerDataServer.get(player: Player, valueName)
	if Profiles[player] then
		return Profiles[player]["Data"][valueName]
	end
	return {}
end

function PlayerDataServer.add(player, valueName, NewValue)
	if Profiles[player] and typeof(Profiles[player]["Data"][valueName]) == "number" then
		Profiles[player]["Data"][valueName] += NewValue
	else
		warn(valueName .. " is not a number")
	end
end

function PlayerDataServer.playerAdded(player: Player)
	-- Start a profile session for this player's data:

	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			-- print(profile)
			Profiles[player] = profile
			-- print(`Profile loaded for {player.DisplayName}!`)
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

function PlayerDataServer.playerRemoving(player: Player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end

return table.freeze(PlayerDataServer)
