game 'gta5'

fx_version 'adamant'
lua54 'yes'

ui_page 'nui/index.html'

files {
	"nui/**",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'@vrp/lib/utils.lua',
	'server/**.lua'
}

client_scripts {
	'@vrp/client/Tunnel.lua',
	'@vrp/client/Proxy.lua',
	'client/**.lua'
}