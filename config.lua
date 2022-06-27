----------------------------------------------------------------------------------------------------
--------------------------------------- CONFIG -----------------------------------------------------
-- VORP INVENTORY LUA*

Config = {

  Debug = true, -- if your server is live set this to false.  to true only if you are testing things
  DevMode = true, -- if your server is live set this to false.  to true only if you are testing things (auto load inventory when script restart and before character selection. Alos add /getInv command)

  defaultlang = "en_lang",

  -- GOLD ITEM LIKE DOLLARS
  UseGoldItem = true, -- IF TRUE YOU HAVE GOLD IN INVENTORY LIKE DOLLARS
  -- CHANGE IN html/js/config.js TOO !!!

  -- DEATH FUNCTIONS
  DisableDeathInventory = true, -- prevent the ability to access inventory while dead

  --{ I } OPEN INVENTORY
  OpenKey = 0xC1989F95,

  --RMB mouse PROMPT PICKUP
  PickupKey = 0xF84FA74F,

  -- LOGS 
  webhookavatar = "https://cdn3.iconfinder.com/data/icons/hand/500/Hand_give_thumbs_finger-512.png",
  webhook = "https://discord.com/api/webhooks/952537644259221544/EdqpLMoDJJx0b-eXJJn3m4cOUhktW21YY2nr-8pq8XEbsMZYEYbL8t6LO5dIzavr9tzE",
  discordid = false, -- turn to true if ur using discord whitelist

  -- WEBHOOK LANGUAGE
  Language = {
    gaveitem = "item transfer",
    gave = " transfered ",
    to = " to ",
    withid = " with the weapon ID: ",
  },

  -- NEED TO TEST
  DropOnRespawn = {
    Money   = true,
    Gold    = false, -- TRUE ONLY IF UseGoldItem = true
    Weapons = true,
    Items   = true
  },

  -- HOW MANY WEAPONS AND ITEMS ALLOWED PER PLAYER
  MaxItemsInInventory = {
    Weapons = 6,
    Items = 50,
  },


  -- FIRST JOIN
  startItems = {
    consumable_raspberrywater = 2, --ITEMS SAME NAME AS IN DATABASE
    ammorevolvernormal = 1 --AMMO SAME NAME AS I NTHE DATABASE
  },

  startWeapons = {
    WEAPON_MELEE_KNIFE = {} --WEAPON HASH NAME
  },


  --DON'T TOUCH BESIDES NAME OF WEAPON
  Weapons = {
    {
      Name     = "Lasso", -- TRANSLATE NAME ONLY
      Desc     = "DESC IN config.lua", -- CHANGE DESCRIPTION ONLY
      HashName = "WEAPON_LASSO", -- DONT TOUCH
    },
    {
      Name     = "Reinforced Lasso",
      Desc     = "DESC IN config.lua",
      HashName = "WEAPON_LASSO_REINFORCED",
    },
    {
      Name = "Knife",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE",
    },
    {
      Name = "Knife Rustic",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_RUSTIC",
    },
    {
      Name = "Knife Horror",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_HORROR",
    },
    {
      Name = "Knife Civil War",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_CIVIL_WAR",
    },
    {
      Name = "Knife Jawbone",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_JAWBONE",
    },
    {
      Name = "Knife Miner",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_MINER",
    },
    {
      Name = "Knife Vampire",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_VAMPIRE",
    },
    {
      Name = "Cleaver",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_CLEAVER",
    },
    {
      Name = "Hachet",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_HATCHET",
    },
    {
      Name = "Hachet Double Bit",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_HATCHET_DOUBLE_BIT",
    },
    {
      Name = "Hachet Hewing",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_HATCHET_HEWING",
    },
    {
      Name = "Hachet Hunter",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_HATCHET_HUNTER",
    },
    {
      Name = "Hachet Viking",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_HATCHET_VIKING",
    },
    {
      Name = "Tomahawk",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_TOMAHAWK",
    },
    {
      Name = "Tomahawk Ancient",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_TOMAHAWK_ANCIENT",
    },
    {
      Name = "Throwing Knifes",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_THROWING_KNIVES",

    },
    {
      Name = "Machete",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_MACHETE",
    },
    {
      Name = "Bow",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_BOW",
    },
    {
      Name = "Pistol Semi-Auto",
      Desc = "DESC IN config.lua",
      HashName = 'WEAPON_PISTOL_SEMIAUTO',
    },
    {
      Name = "Pistol Mauser",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_PISTOL_MAUSER",
    },
    {
      Name = "Pistol Volcanic",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_PISTOL_VOLCANIC",
    },
    {
      Name = "Pistol M1899",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_PISTOL_M1899",
    },
    {
      Name = "Revolver Schofield",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_SCHOFIELD",
    },
    {
      Name = "Revolver Navy",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_NAVY",
    },
    {
      Name = "Revolver Navy Crossover",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_NAVY_CROSSOVER",
    },
    {
      Name = "Revolver Lemat",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_LEMAT",
    },
    {
      Name = "Revolver Double Action",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_DOUBLEACTION",
    },
    {
      Name = "Revolver Cattleman",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_CATTLEMAN",
    },
    {
      Name = "Revolver Cattleman mexican",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REVOLVER_CATTLEMAN_MEXICAN",
    },
    {
      Name = "Varmint Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_RIFLE_VARMINT",

    },
    {
      Name = "Winchester Repeater",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REPEATER_WINCHESTER",

    },
    {
      Name = "Henry Reapeater",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REPEATER_HENRY",

    },
    {
      Name = "Evans Repeater",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REPEATER_EVANS",

    },
    {
      Name = "Carabine Reapeater",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_REPEATER_CARBINE",
    },
    {
      Name = "Rolling Block Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SNIPERRIFLE_ROLLINGBLOCK",
    },
    {
      Name = "Carcano Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SNIPERRIFLE_CARCANO",
    },
    {
      Name = "Springfield Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_RIFLE_SPRINGFIELD",
    },
    {
      Name = "Elephant Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_RIFLE_ELEPHANT",
    },
    {
      Name = "BoltAction Rifle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_RIFLE_BOLTACTION",
    },
    {
      Name = "Semi-Auto Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_SEMIAUTO",
    },
    {
      Name = "Sawedoff Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_SAWEDOFF",
    },
    {
      Name = "Repeating Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_REPEATING",
    },
    {
      Name = "Double Barrel Exotic Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_DOUBLEBARREL_EXOTIC",
    },
    {
      Name = "Pump Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_PUMP",

    },
    {
      Name = "Double Barrel Shotgun",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_SHOTGUN_DOUBLEBARREL",
    },
    {
      Name = "Camera",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_KIT_CAMERA",
    },
    {
      Name = "Improved Binoculars",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_KIT_BINOCULARS_IMPROVED",
    },
    {
      Name = "Knife Trader",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_KNIFE_TRADER",
    },
    {
      Name = "Binoculars",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_KIT_BINOCULARS",
    },
    {
      Name = "Advanced Camera",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_KIT_CAMERA_ADVANCED",
    },
    {
      Name = "Lantern",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_LANTERN",
    },
    {
      Name = "Davy Lantern",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_DAVY_LANTERN",
    },
    {
      Name = "Halloween Lantern",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_LANTERN_HALLOWEEN",
    },
    {
      Name = "Poison Bottle",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_POISONBOTTLE",
    },
    {
      Name = "Metal Detector",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_KIT_METAL_DETECTOR",
    },
    {
      Name = "Dynamite",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_DYNAMITE",

    },
    {
      Name = "Molotov",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_MOLOTOV",

    },
    {
      Name = "Improved Bow",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_BOW_IMPROVED",
    },
    {
      Name = "Machete Collector",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_MACHETE_COLLECTOR",
    },
    {
      Name = "Electric Lantern",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_LANTERN_ELECTRIC",
    },
    {
      Name = "Torch",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_TORCH",
    },
    {
      Name = "Moonshine Jug",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MOONSHINEJUG_MP",

    },
    {
      Name = "Bolas",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_BOLAS",
    },
    {
      Name = "Bolas Hawkmoth",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_BOLAS_HAWKMOTH",
    },
    {
      Name = "Bolas Ironspiked",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_BOLAS_IRONSPIKED",

    },
    {
      Name = "Bolas Intertwined",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_THROWN_BOLAS_INTERTWINED",

    },
    {
      Name = "Fishing Rod",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_FISHINGROD",
    },
    {
      Name = "Machete Horror",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MACHETE_HORROR",
    },
    {
      Name = "Lantern Haloween",
      Desc = "DESC IN config.lua",
      HashName = "WEAPON_MELEE_LANTERN_HALOWEEN",

    }
  }
}
