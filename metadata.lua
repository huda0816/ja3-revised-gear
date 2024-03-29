return PlaceObj('ModDef', {
	'title', "Revised Tactical Gear II (Beta)",
	'description', "This is a reworked and enhanced rerelease of Ablomis' Revised Tactical Gear mod. \n\nThis mod adds more inventory slots to the game (Backpack, LBE, Leg items, Face items, NVG slot)\n\nRevised Mags II Mod is a dependency of this mod. \n\nIt is currently in beta which means that:\n\nthere are bugs \nit is not save-game compatible\nit is not compatible with a lot of popular mods\n\nI am looking forward to your bug reports. You can send your savegames to huda0816 in the JA3 modding Discord. Please do not send reports if you are using any other mods (besides Revised Mags II mod) as I won't have time to investigate compatibility issues at the moment.\n\nInfo for mod creators: I would recommend to wait until you start to make your mod compatible to this one as there could still be major changes.\n\nMore Infos and videos will be added soon.\n\nCopyright:\nLBE and some holster images are from AdobeStock\nBackpacks, the goggle and the rest of the holsters are created with ChatGPT and Bing image creation",
	'image', "Mod/ii6mKUf/Images/JA3Revised-LBE.png",
	'last_changes', "Fixed bug which occured if slots were already occupied by a different item when adding a new slot item",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "URkxyfE",
			'title', "Revised Mags",
		}),
	},
	'id', "ii6mKUf",
	'author', "permanent666",
	'version_minor', 2,
	'version', 11,
	'lua_revision', 233360,
	'saved_with_revision', 350233,
	'code', {
		"CharacterEffect/Overweight.lua",
		"Code/Config.lua",
		"InventoryItem/Holster_Basic.lua",
		"InventoryItem/Holster_Extended.lua",
		"InventoryItem/Holster_Drop_Leg_Bag.lua",
		"InventoryItem/LBE_SWAT_Vest.lua",
		"InventoryItem/LBE_Basic_Rig.lua",
		"InventoryItem/LBE_Basic_Army_Rig.lua",
		"InventoryItem/LBE_Modern_Army_Rig.lua",
		"InventoryItem/LBE_Combat_Vest.lua",
		"InventoryItem/LBE_Cheap_Vest.lua",
		"InventoryItem/LBE_Heavy_Duty_Vest.lua",
		"InventoryItem/Backpack_Retro_Large.lua",
		"InventoryItem/Backpack_Retro.lua",
		"InventoryItem/Backpack_Mule.lua",
		"InventoryItem/Backpack_Combat.lua",
		"InventoryItem/Backpack_Modern.lua",
		"InventoryItem/Backpack_Blackhawk.lua",
		"InventoryItem/FaceItem_Combat_Goggles.lua",
		"Code/Inventory.lua",
		"Code/X_InventoryContextMenu.lua",
		"Code/LBEBuilder.lua",
		"Code/OR_Unit.lua",
		"Code/LBEItemDef.lua",
		"Code/LootDrop.lua",
		"Code/X_Inventory.lua",
		"Code/SlotDefs.lua",
		"Code/ModOptions.lua",
		"Code/UnitInventory.lua",
		"Code/Weight.lua",
		"Code/WeightCalc.lua",
		"Code/InventoryWeight.lua",
		"Code/X_Utils.lua",
		"Code/OR_CombatActions.lua",
		"Code/OR_MoveItem.lua",
		"Code/OR_InventoryUI.lua",
		"Code/OR_Inventory.lua",
		"Code/OR_UnitProperties.lua",
		"Code/OR_Mercenary.lua",
		"Code/OR_SquadBag.lua",
		"Code/SlotConfig.lua",
	},
	'default_options', {
		RevisedLBEDropChance = "5",
		RevisedSquadBagHasWeight = true,
	},
	'has_data', true,
	'saved', 1710187366,
	'code_hash', -7642359806022581051,
	'affected_resources', {
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "Overweight",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Holster_Basic",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Holster_Extended",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Holster_Drop_Leg_Bag",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_SWAT_Vest",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Basic_Rig",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Basic_Army_Rig",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Modern_Army_Rig",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Combat_Vest",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Cheap_Vest",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "LBE_Heavy_Duty_Vest",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Retro_Large",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Retro",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Mule",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Combat",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Modern",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "Backpack_Blackhawk",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "FaceItem_Combat_Goggles",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "TextStyle",
			'Id', "REVLBELegendText",
			'ClassDisplayName', "Text style",
		}),
	},
	'steam_id', "3178380968",
	'TagWeapons&Items', true,
})