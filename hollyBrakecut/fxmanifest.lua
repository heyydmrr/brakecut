fx_version 'cerulean'
game 'gta5'

author 'HollyV DMR '
description 'Fren kesme muhabbeti'
version '1.0.0'

shared_script '@qb-core/shared/locale.lua'
shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'

escrow_ignore {
    'config.lua',
}