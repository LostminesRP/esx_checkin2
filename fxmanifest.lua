fx_version 'bodacious'

game 'gta5'

description 'ESX Checkin'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/no.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/no.lua',
	'config.lua',
	'client/main.lua'
}

dependencies { 
	'es_extended',
	'esx_identity',
	'esx_skin',
	'skinchanger',
	'mythic_progbar'
}



