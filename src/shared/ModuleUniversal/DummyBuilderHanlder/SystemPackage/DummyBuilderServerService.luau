local playerData = require(script.Parent.Parent.Parent.PlayerDataHanlder.SystemPackage.PlayerDataServerService)

local DummyBuilderServer = {}


local function getPlayerData()
    playerData.get()
end

function DummyBuilderServer.init()


end




return DummyBuilderServer
