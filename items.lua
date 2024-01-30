return {
	PlaceObj('ModItemCharacterEffectCompositeDef', {
		'Id', "Overweight",
		'object_class', "CharacterEffect",
		'DisplayName', T(744916557348, --[[ModItemCharacterEffectCompositeDef Overweight DisplayName]] "Overweight"),
		'Description', T(353908600713, --[[ModItemCharacterEffectCompositeDef Overweight Description]] "Unit carries more than they comfortably can"),
		'AddEffectText', T(262318417734, --[[ModItemCharacterEffectCompositeDef Overweight AddEffectText]] "Unit is overweight"),
		'RemoveEffectText', T(540476878649, --[[ModItemCharacterEffectCompositeDef Overweight RemoveEffectText]] "Not overweight anymore"),
		'type', "Debuff",
		'Icon', "Mod/ii6mKUf/Icons/overweight.png",
		'Shown', true,
		'ShownSatelliteView', true,
	}),
	PlaceObj('ModItemCode', {
		'name', "BackpackItems",
		'CodeFileName', "Code/BackpackItems.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "Config",
		'CodeFileName', "Code/Config.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "Inventory",
		'CodeFileName', "Code/Inventory.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "InventoryFix",
		'CodeFileName', "Code/InventoryFix.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LBEBuilder",
		'CodeFileName', "Code/LBEBuilder.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LBEItemDef",
		'CodeFileName', "Code/LBEItemDef.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LBEItems",
		'CodeFileName', "Code/LBEItems.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LootDrop",
		'CodeFileName', "Code/LootDrop.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "ModOptions",
		'CodeFileName', "Code/ModOptions.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "UnitInventory",
		'CodeFileName', "Code/UnitInventory.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "Weight",
		'CodeFileName', "Code/Weight.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "WeightCalc",
		'CodeFileName', "Code/WeightCalc.lua",
	}),
	PlaceObj('ModItemOptionChoice', {
		'name', "RevisedLBEDropChance",
		'DisplayName', "LBE Drop Chance",
		'Help', "Chance for an enemy unit to drop LBE",
		'DefaultValue', "5",
		'ChoiceList', {
			"1",
			"5",
			"10",
			"25",
			"50",
			"75",
			"100",
		},
	}),
	PlaceObj('ModItemOptionToggle', {
		'name', "RevisedSquadBagHasWeight",
		'DisplayName', "Squad Bag Weight",
		'Help', "Weight of squad bag items distributed across mercs",
		'DefaultValue', true,
	}),
	PlaceObj('ModItemCode', {
		'name', "InventoryWeight",
		'CodeFileName', "Code/InventoryWeight.lua",
	}),
}