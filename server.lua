local config = require 'config'

local function debugPrint(...)
    if config.debug then
        print(...)
    end
end

if config.framework == 'QB' then
    local QBCore = exports['qb-core']:GetCoreObject()
    lib.callback.register('bostra_info:server:getJobCount', function(source, jobName)
        local online = 0
        debugPrint("Getting job count for", jobName, source)
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local target = QBCore.Functions.GetPlayer(v)
            debugPrint("Player job:", target.PlayerData.job.name, "On duty:", target.PlayerData.job.onduty)
            debugPrint("Requested job:", jobName)
            if config.showJobCount.jobType and target.PlayerData.job.type == jobName and target.PlayerData.job.onduty then
                online = online + 1
            else
                if target.PlayerData.job.name == jobName and target.PlayerData.job.onduty then
                    online = online + 1
                end
            end
        end
        debugPrint("Job count for", jobName, ":", online)
        return online
    end)
end

lib.callback.register('bostra_info:server:getPlayerCount', function()
    local playerCount = 0
    playerCount = #GetPlayers()
    debugPrint("Player count:", playerCount)
    return playerCount
end)
