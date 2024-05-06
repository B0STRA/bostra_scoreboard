return {
    debug = false,                                          -- If true, debug messages will be printed to the console
    framework = 'QB',                                       -- The framework you are using (currently only 'QB' is supported)
    keybind = 'HOME',                                       -- The hotkey to toggle the scoreboard (set to false to disable keybind)
    command = true,                                         -- The command to toggle the scoreboard (set to false to disable command)
    description = 'Player Info Panel',                      -- The description of the keybind
    showPlayerIds = {
        show = true,                                        -- If true, player IDs will be shown
        distance = 20.0,                                    -- The distance in which player IDs will be shown
        zOffset = 0.80,                                     -- The z offset of the player ID text
        autoToggle = true,                                  -- If true, the scoreboard will automatically close after toggleTime
        toggleTime = 10000,                                 -- The time in milliseconds before the scoreboard automatically closes
        requireLos = true,                                  -- If true, the player must have line of sight to the other player to see their ID CLIENT INTENSIVE
        textColor = { r = 255, g = 255, b = 255, a = 255 }, -- The color of the text
        textScale = 0.35,                                   -- The scale of the text
        textFont = 5,                                       -- The font of the text
        useBackground = true,                               -- If true, a rectangle will be drawn behind the text slightly more client intensive
        background = { r = 0, g = 0, b = 0, a = 255 },      -- The color of the background
    },
    showPlayerCount = {
        show = true,                          -- If true, the player count will be shown in the scoreboard
        playerCountPosition = 'right-center', -- The position of the player count textUi
        icon = {                              -- The icon to display next to the player count
            name = 'fas fa-users',            -- The name of the icon
            color = 'white',                  -- The color of the icon
            anim = 'fade'                     -- The animation of the icon
        }
    },
    showJobCount = {
        show = true,                         -- If true, the job count will be shown in the scoreboard
        jobType = true,                      -- If true, the job type instead of job name will be used to count the players
        jobs = { 'leo', 'ems', 'mechanic' }, -- The jobs to show the count of in the scoreboard
    }
}
