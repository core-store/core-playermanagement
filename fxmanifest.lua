fx_version 'cerulean'
game 'gta5'

lua54 'yes'

client_script 'client.lua'
server_script { 'server.lua', '@oxmysql/lib/MySQL.lua' }
shared_scripts {
    '@ox_lib/init.lua'
}
