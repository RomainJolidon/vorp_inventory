game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
ui_page 'html/ui.html'

client_scripts{
  'client/models/*.lua',
  'client/handler/*.lua',
  'client/services/*.lua',
  'client/controllers/*.lua',
  'client/*.lua',
}
server_scripts {
  'server/models/*.lua',
  'server/handler/*.lua',
  'server/services/*.lua',
  'server/controllers/*.lua',
  'server/*.lua',
}

shared_scripts {
  "config.lua",
  "locale.lua",
  "languages/*.lua"
}

files{
  'html/**/*'
}

-- files{
--   'html/ui.html',
--   'html/css/contextMenu.min.css',
--   'html/css/jquery.dialog.min.css',
--   'html/css/ui.min.css',
--   'html/js/config.js',
--   'html/js/contextMenu.min.js',
--   'html/js/jquery.dialog.min.js',
--   'html/fonts/crock.ttf',
--   'html/img/bgPanel.png',
--   'html/img/bgPanel1.png',
--   'html/img/bg.png',
--   'html/img/bgitem.png',
--   'html/webfonts/*',
--   'html/webfonts/**',
--   'html/img/items/*',
--   'html/img/items/**',
--   'html/img/items/*.png',
--   'html/img/items/**.png',
--   'html/css/all.css',
--   'html/css/all.min.css',
--   -- ICONS
--   'html/img/items/*',
--   'html/img/items/**',
--   'html/img/items/**.png',
--   'html/img/items/*.png',
--   'html/img/items/*.jpg',
--   'html/img/items/**.jpg',
--   'html/img/items/weapon_bow.png',
--   'html/img/items/weapon_fishingrod.png',
--   'html/img/items/weapon_kit_binoculars.png',
--   'html/img/items/weapon_kit_detector.png',
--   'html/img/items/weapon_lasso.png',
--   'html/img/items/weapon_melee_ancient_hatchet.png',
--   'html/img/items/weapon_melee_broken_sword.png',
--   'html/img/items/weapon_melee_cleaver.png',
--   'html/img/items/weapon_melee_davy_lantern.png',
--   'html/img/items/weapon_melee_electric_lantern.png',
--   'html/img/items/weapon_melee_hatchet.png',
--   'html/img/items/weapon_melee_hatchet_double_bit.png',
--   'html/img/items/weapon_melee_hatchet_double_bit_rusted.png',
--   'html/img/items/weapon_melee_hatchet_hewing.png',
--   'html/img/items/weapon_melee_hatchet_hunter.png',
--   'html/img/items/weapon_melee_hatchet_hunter_rusted.png',
--   'html/img/items/weapon_melee_hatchet_viking.png',
--   'html/img/items/weapon_melee_knife.png',--
--   'html/img/items/weapon_melee_knife_bear.png',
--   'html/img/items/weapon_melee_knife_civil_war.png',
--   'html/img/items/weapon_melee_knife_jawbone.png',
--   'html/img/items/weapon_melee_knife_john.png',
--   'html/img/items/weapon_melee_knife_miner.png',
--   'html/img/items/weapon_melee_knife_vampire.png',
--   'html/img/items/weapon_melee_machete.png',
--   'html/img/items/weapon_melee_torch.png',
--   'html/img/items/weapon_pistol_mauser.png',
--   'html/img/items/weapon_pistol_mauser_drunk.png',
--   'html/img/items/weapon_pistol_semiauto.png',
--   'html/img/items/weapon_pistol_volcanic.png',
--   'html/img/items/weapon_repeater_carbine.png',
--   'html/img/items/weapon_repeater_henry.png',--
--   'html/img/items/weapon_repeater_lancaster.png',
--   'html/img/items/weapon_revolver_cattleman.png',
--   'html/img/items/weapon_revolver_cattleman_john.png',
--   'html/img/items/weapon_revolver_cattleman_mexican.png',
--   'html/img/items/weapon_revolver_cattleman_pig.png',
--   'html/img/items/weapon_revolver_doubleaction.png',
--   'html/img/items/weapon_revolver_doubleaction_exotic.png',
--   'html/img/items/weapon_revolver_doubleaction_micah.png',
--   'html/img/items/weapon_revolver_schofield.png',
--   'html/img/items/weapon_revolver_schofield_calloway.png',--
--   'html/img/items/weapon_revolver_schofield_golden.png',
--   'html/img/items/weapon_rifle_boltaction.png',
--   'html/img/items/weapon_rifle_springfield.png',
--   'html/img/items/weapon_rifle_varmint.png',
--   'html/img/items/weapon_shotgun_doublebarrel.png',
--   'html/img/items/weapon_shotgun_doublebarrel_exotic.png',
--   'html/img/items/weapon_shotgun_pump.png',
--   'html/img/items/weapon_shotgun_repeating.png',
--   'html/img/items/weapon_shotgun_sawedoff.png',
--   'html/img/items/weapon_shotgun_semiauto.png',----
--   'html/img/items/weapon_sniperrifle_carcano.png',
--   'html/img/items/weapon_sniperrifle_rollingblock.png',
--   'html/img/items/weapon_sniperrifle_rollingblock_exotic.png',
--   'html/img/items/weapon_thrown_ancient_tomahawk.png',
--   'html/img/items/weapon_thrown_dynamite.png',
--   'html/img/items/weapon_thrown_homing_tomahawk.png',
--   'html/img/items/weapon_thrown_improved_tomahawk.png',
--   'html/img/items/weapon_thrown_molotov.png',
--   'html/img/items/weapon_thrown_throwing_knives.png',--
--   'html/img/items/weapon_thrown_throwing_knives_confuse.png',
--   'html/img/items/weapon_thrown_throwing_knives_disorient.png',
--   'html/img/items/weapon_thrown_throwing_knives_drain.png',
--   'html/img/items/weapon_thrown_throwing_knives_improved.png',
--   'html/img/items/weapon_thrown_throwing_knives_poison.png',
--   'html/img/items/weapon_thrown_throwing_knives_trail.png',
--   'html/img/items/weapon_thrown_throwing_knives_wound.png',--
--   'html/img/items/weapon_thrown_tomahawk.png',
--   'html/img/items/weapon_volatile_dynamite.png',
--   'html/img/items/weapon_volatile_fire_bottle.png'
-- }

server_exports{'vorp_inventoryApi'} 
