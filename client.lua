local config = require 'config'
local scoreboardOpen = false
local canOpen = true
local scoreboardTimer = nil

local function debugPrint(...)
    if config.debug then
        print(...)
    end
end

local function drawText3D(x, y, z, text)
    SetTextScale(config.showPlayerIds.textScale, config.showPlayerIds.textScale)
    SetTextFont(config.showPlayerIds.textFont)
    SetTextProportional(1)
    SetTextColour(config.showPlayerIds.textColor.r, config.showPlayerIds.textColor.g, config.showPlayerIds.textColor.b,
        config.showPlayerIds.textColor.a)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    if config.showPlayerIds.zOffset then
        z = z + config.showPlayerIds.zOffset
    end
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    if config.showPlayerIds.useBackground then
        local factor = (string.len(text)) / 370
        DrawRect(0.0, 0.0125, 0.015 + factor, 0.03, config.showPlayerIds.background.r, config.showPlayerIds.background.g,
            config.showPlayerIds.background.b, config.showPlayerIds.background.a)
    end
    ClearDrawOrigin()
end

local function getPlayerCount()
    if not config.showPlayerCount.show and not config.showJobCount.show then return end
    if config.showJobCount.show and type(config.showJobCount.jobs) == "table" then
        if next(config.showJobCount.jobs) == nil then
            debugPrint("showJobCount is enabled but jobs table is empty.")
            return
        end
    else
        debugPrint("showJobCount is not properly configured.")
        return
    end

    local totalPlayers = lib.callback('bostra_info:server:getPlayerCount')
    local maxPlayers = GetConvarInt('sv_maxclients', 64)
    local playerCountText = string.format("%d/%d players  \n", totalPlayers, maxPlayers)

    if config.showJobCount.show then
        local jobCounts = {}
        for _, job in ipairs(config.showJobCount.jobs) do
            debugPrint("Requesting job count for: " .. job)
            jobCounts[job] = lib.callback.await('bostra_info:server:getJobCount', false, job)
        end

        local jobCountText = ""
        for job, count in pairs(jobCounts) do
            debugPrint("Received job count for: " .. job, "Count:", count)
            jobCountText = jobCountText .. string.format("  %s: %d  \n", job, count)
        end

        playerCountText = playerCountText .. jobCountText
    end

    local options = {
        position = config.showPlayerCount.playerCountPosition,
        icon = config.showPlayerCount.icon.name,
        iconColor = config.showPlayerCount.icon.color,
        iconAnimation = config.showPlayerCount.icon.anim,
    }

    if scoreboardOpen then
        lib.showTextUI(playerCountText, options)
    end
end

local function getPlayersNearby()
    if not config.showPlayerIds.show then return end
    CreateThread(function()
        while scoreboardOpen do
            local loop = 100
            local nearbyPlayers = lib.getNearbyPlayers(GetEntityCoords(cache.ped), config.showPlayerIds.distance,
                true)
            for _, playerData in ipairs(nearbyPlayers) do
                local playerId = GetPlayerServerId(playerData.id)
                local playerPed = playerData.ped
                local playerCoords = playerData.coords
                loop = 0
                if config.showPlayerIds.requireLos then
                    local handle = StartShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z + 1.0,
                        playerPed,
                        -1, 0)
                    local _, _, _, _, hit = GetShapeTestResult(handle)
                    if hit then
                        if HasEntityClearLosToEntity(cache.ped, playerPed, 17) then
                            local headBoneIndex = GetPedBoneIndex(playerPed, 24816)
                            if headBoneIndex ~= -1 then
                                local headBoneCoords = GetWorldPositionOfEntityBone(playerPed, headBoneIndex)
                                drawText3D(headBoneCoords.x, headBoneCoords.y, headBoneCoords.z + 0.2, playerId)
                            end
                        end
                    end
                else
                    local headBoneIndex = GetPedBoneIndex(playerPed, 24816)
                    if headBoneIndex ~= -1 then
                        local headBoneCoords = GetWorldPositionOfEntityBone(playerPed, headBoneIndex)
                        drawText3D(headBoneCoords.x, headBoneCoords.y, headBoneCoords.z + 0.2, playerId)
                    end
                end
            end
            Wait(loop)
        end
    end)
end

local function closeScoreboard()
    if scoreboardOpen then
        scoreboardOpen = false
        lib.hideTextUI()
        canOpen = true
        if not config.showPlayerIds.autoToggle then
            return
        else
            scoreboardTimer:forceEnd(false)
        end
    end
end

local function startScoreboardTimer()
    scoreboardTimer = lib.timer(config.showPlayerIds.toggleTime, function()
        debugPrint("Scoreboard timeout")
        closeScoreboard()
    end, true)
end

if not config.command then
    return
else
    RegisterCommand('scoreboard', function()
        if not scoreboardOpen and canOpen then
            scoreboardOpen = true
            getPlayerCount()
            getPlayersNearby()
            if not config.showPlayerIds.autoToggle then
                return
            else
                startScoreboardTimer()
            end
        else
            closeScoreboard()
        end
    end, false)
end

if not config.keybind then
    return
else
    RegisterKeyMapping('scoreboard', config.description, 'keyboard', config.keybind)
end
