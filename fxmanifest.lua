fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Battleground Team'
description 'Server-Authoritative Battle Royale / Battleground Resource for FiveM'
version '1.0.0'

ui_page 'web/index.html'
loadingscreen 'loadingscreen/index.html'

shared_scripts {
    'config/config.lua',
    'config/weapons.lua',
    'config/vehicles.lua',
    'config/loot_tables.lua',
    'config/airdrop.lua',
    'config/zones.lua',
    'config/redeem.lua',
    'config/killmessages.lua',
    'shared/constants.lua',
    'shared/utils.lua',
    'shared/locales.lua'
}

server_scripts {
    'server/core/state.lua',
    'server/core/players.lua',
    'server/core/permissions.lua',
    'server/core/events.lua',
    'server/room/room.lua',
    'server/room/team.lua',
    'server/match/match.lua',
    'server/match/countdown.lua',
    'server/match/ranking.lua',
    'server/match/results.lua',
    'server/gameplay/player_state.lua',
    'server/gameplay/inventory.lua',
    'server/gameplay/interaction.lua',
    'server/combat/damage.lua',
    'server/combat/knock.lua',
    'server/combat/revive.lua',
    'server/combat/kill.lua',
    'server/combat/death.lua',
    'server/combat/elimination.lua',
    'server/loot/loot.lua',
    'server/loot/lootzone.lua',
    'server/loot/loottable.lua',
    'server/vehicle/vehicle.lua',
    'server/vehicle/spawner.lua',
    'server/zone/zone.lua',
    'server/airdrop/airdrop.lua',
    'server/airdrop/spawner.lua',
    'server/redeem/redeem.lua',
    'server/redeem/codes.lua',
    'server/admin/commands.lua',
    'server/admin/admin.lua',
    'server/main.lua'
}

client_scripts {
    'client/core/state.lua',
    'client/core/events.lua',
    'client/room/room.lua',
    'client/match/match.lua',
    'client/match/countdown.lua',
    'client/plane/plane.lua',
    'client/plane/flight.lua',
    'client/plane/jump.lua',
    'client/plane/parachute.lua',
    'client/gameplay/movement.lua',
    'client/gameplay/interaction.lua',
    'client/gameplay/animations.lua',
    'client/gameplay/hud.lua',
    'client/gameplay/voice.lua',
    'client/gameplay/ping.lua',

    'client/combat/combat.lua',
    'client/combat/effects.lua',
    'client/loot/loot.lua',
    'client/vehicle/vehicle.lua',
    'client/zone/zone.lua',
    'client/airdrop/airdrop.lua',
    'client/airdrop/plane.lua',
    'client/airdrop/crate.lua',
    'client/main.lua'
}

files {
    'web/index.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/assets/**/*',
    'web/gif/*',
    'loadingscreen/index.html',
    'loadingscreen/style.css',
    'loadingscreen/app.js',
    'data/wrangler24/*.meta'
}

data_file 'DLCTEXT_FILE' 'data/wrangler24/dlctext.meta'
data_file 'HANDLING_FILE' 'data/wrangler24/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/wrangler24/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/wrangler24/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/wrangler24/carvariations.meta'
