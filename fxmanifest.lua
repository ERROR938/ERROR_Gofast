fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'error950'
description 'Fivem Gofast script'
version '1.0'

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    "config.lua"
}