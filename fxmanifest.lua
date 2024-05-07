game 'gta5'
fx_version 'adamant'
author 'Bostra'
description 'Scoreboard to display ids, job and player counts'
version '1.0.0'
lua54 'yes'
use_experimental_fxv2_oal 'yes'


shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
	'server.lua',
}

files {
    'config.lua',
    'client.lua',
}
