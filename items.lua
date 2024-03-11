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
		'name', "Config",
		'CodeFileName', "Code/Config.lua",
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Holster",
		'Id', "Holster_Basic",
		'object_class', "Holster",
		'ScrapParts', 2,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Holster/Holster_Basic.png",
		'DisplayName', T(176162216144, --[[ModItemInventoryItemCompositeDef Holster_Basic DisplayName]] "Basic Pistol Holster"),
		'DisplayNamePlural', T(799185388027, --[[ModItemInventoryItemCompositeDef Holster_Basic DisplayNamePlural]] "Basic Pistol Holsters"),
		'Description', T(311938044797, --[[ModItemInventoryItemCompositeDef Holster_Basic Description]] "Holster for a pistol and 1 pistol mag"),
		'Cost', 499,
		'CanAppearInShop', true,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "Holster",
		'Weight', 300,
		'PistolMag', 1,
		'PistolHolster', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Holster",
		'Id', "Holster_Extended",
		'object_class', "Holster",
		'ScrapParts', 2,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Holster/Extended_Holster.png",
		'DisplayName', T(100365052679, --[[ModItemInventoryItemCompositeDef Holster_Extended DisplayName]] "Extended Pistol Holster"),
		'DisplayNamePlural', T(602862639026, --[[ModItemInventoryItemCompositeDef Holster_Extended DisplayNamePlural]] "Extended Pistol Holsters"),
		'Description', T(173070161578, --[[ModItemInventoryItemCompositeDef Holster_Extended Description]] "Holster for a pistol, 2 pistol mags and extra storage"),
		'Cost', 799,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "Holster",
		'Weight', 500,
		'PocketML', 1,
		'PocketS', 1,
		'PistolMag', 2,
		'PistolHolster', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Holster",
		'Id', "Holster_Drop_Leg_Bag",
		'object_class', "Holster",
		'ScrapParts', 2,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Holster/Holster_Leg_Drop_Bag.png",
		'DisplayName', T(876317568177, --[[ModItemInventoryItemCompositeDef Holster_Drop_Leg_Bag DisplayName]] "Drop Leg Bag"),
		'DisplayNamePlural', T(531363606310, --[[ModItemInventoryItemCompositeDef Holster_Drop_Leg_Bag DisplayNamePlural]] "Drop Leg Bags"),
		'Description', T(249633411882, --[[ModItemInventoryItemCompositeDef Holster_Drop_Leg_Bag Description]] "Drop Leg Bag with additional storage for larger items"),
		'Cost', 699,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "Holster",
		'Weight', 500,
		'PocketL', 1,
		'PocketM', 2,
		'PocketS', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_SWAT_Vest",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_SWAT_Vest.png",
		'DisplayName', T(326349535131, --[[ModItemInventoryItemCompositeDef LBE_SWAT_Vest DisplayName]] "SWAT Tactical Vest"),
		'DisplayNamePlural', T(879443032243, --[[ModItemInventoryItemCompositeDef LBE_SWAT_Vest DisplayNamePlural]] "SWAT Tactical Vests"),
		'Description', T(924404892763, --[[ModItemInventoryItemCompositeDef LBE_SWAT_Vest Description]] "Tactical Vest with holster"),
		'Cost', 1199,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 60,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 1500,
		'PocketM', 3,
		'PocketML', 1,
		'PocketS', 1,
		'RifleMag', 2,
		'PistolMag', 4,
		'PistolHolster', 1,
		'Carabiner', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Basic_Rig",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_Basic_Rig.png",
		'DisplayName', T(737987985840, --[[ModItemInventoryItemCompositeDef LBE_Basic_Rig DisplayName]] "Basic Rig"),
		'DisplayNamePlural', T(838796438087, --[[ModItemInventoryItemCompositeDef LBE_Basic_Rig DisplayNamePlural]] "Basic Rigs"),
		'Description', T(314316421143, --[[ModItemInventoryItemCompositeDef LBE_Basic_Rig Description]] "Basic lightweight rig"),
		'AdditionalHint', T(695333586281, --[[ModItemInventoryItemCompositeDef LBE_Basic_Rig AdditionalHint]] "Few pouches"),
		'Cost', 799,
		'CanAppearInShop', true,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 800,
		'PocketM', 2,
		'RifleMag', 6,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Basic_Army_Rig",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_Basic_Army_Rig.png",
		'DisplayName', T(177539640058, --[[ModItemInventoryItemCompositeDef LBE_Basic_Army_Rig DisplayName]] "Basic Army Rig"),
		'DisplayNamePlural', T(286587946758, --[[ModItemInventoryItemCompositeDef LBE_Basic_Army_Rig DisplayNamePlural]] "Basic Army Rigs"),
		'Description', T(325745705536, --[[ModItemInventoryItemCompositeDef LBE_Basic_Army_Rig Description]] "Basic rig"),
		'AdditionalHint', "",
		'Cost', 999,
		'CanAppearInShop', true,
		'RestockWeight', 50,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 1200,
		'PocketM', 2,
		'PocketML', 1,
		'PocketS', 1,
		'RifleMag', 4,
		'Carabiner', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Modern_Army_Rig",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/Light_Army_Vest.png",
		'DisplayName', T(844649076034, --[[ModItemInventoryItemCompositeDef LBE_Modern_Army_Rig DisplayName]] "Modern Army Rig"),
		'DisplayNamePlural', T(827974105320, --[[ModItemInventoryItemCompositeDef LBE_Modern_Army_Rig DisplayNamePlural]] "Modern Army Rigs"),
		'Description', T(429822648029, --[[ModItemInventoryItemCompositeDef LBE_Modern_Army_Rig Description]] "Modern lightweight rig"),
		'AdditionalHint', "",
		'Cost', 1299,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'PocketL', 1,
		'PocketM', 2,
		'PocketML', 2,
		'PocketS', 1,
		'RifleMag', 4,
		'KnifeSheath', 1,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Combat_Vest",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_Combat_Vest.png",
		'DisplayName', T(932789580806, --[[ModItemInventoryItemCompositeDef LBE_Combat_Vest DisplayName]] "Combat Vest"),
		'DisplayNamePlural', T(274681316767, --[[ModItemInventoryItemCompositeDef LBE_Combat_Vest DisplayNamePlural]] "Combat Vests"),
		'Description', T(111358326729, --[[ModItemInventoryItemCompositeDef LBE_Combat_Vest Description]] "Army vest with a large variety of pockets"),
		'AdditionalHint', "",
		'Cost', 1199,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 1500,
		'PocketM', 2,
		'PocketML', 2,
		'PocketS', 1,
		'RifleMag', 2,
		'PistolMag', 2,
		'PistolHolster', 1,
		'KnifeSheath', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Cheap_Vest",
		'object_class', "LBE",
		'ScrapParts', 2,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_Cheap_Vest.png",
		'DisplayName', T(141326544604, --[[ModItemInventoryItemCompositeDef LBE_Cheap_Vest DisplayName]] "Light Vest"),
		'DisplayNamePlural', T(301072068214, --[[ModItemInventoryItemCompositeDef LBE_Cheap_Vest DisplayNamePlural]] "Light Vests"),
		'Description', T(636857624212, --[[ModItemInventoryItemCompositeDef LBE_Cheap_Vest Description]] "Cheap and lightweight vest."),
		'AdditionalHint', "",
		'Cost', 499,
		'CanAppearInShop', true,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 500,
		'PocketM', 1,
		'PocketS', 1,
		'RifleMag', 4,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - LBE",
		'Id', "LBE_Heavy_Duty_Vest",
		'object_class', "LBE",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/LBE/LBE_Heavy_Duty.png",
		'DisplayName', T(326903387904, --[[ModItemInventoryItemCompositeDef LBE_Heavy_Duty_Vest DisplayName]] "Heavy Duty Vest"),
		'DisplayNamePlural', T(940638560246, --[[ModItemInventoryItemCompositeDef LBE_Heavy_Duty_Vest DisplayNamePlural]] "Heavy Duty Vests"),
		'Description', T(757384009884, --[[ModItemInventoryItemCompositeDef LBE_Heavy_Duty_Vest Description]] "Heavy Duty Combat Vest with a lot of storage"),
		'AdditionalHint', T(262290543820, --[[ModItemInventoryItemCompositeDef LBE_Heavy_Duty_Vest AdditionalHint]] "2 large pouches"),
		'Cost', 1099,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'CategoryPair', "LBE",
		'Weight', 2000,
		'PocketL', 1,
		'PocketM', 2,
		'PocketML', 2,
		'PocketS', 1,
		'RifleMag', 4,
		'PistolMag', 2,
		'KnifeSheath', 1,
		'Carabiner', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Retro_Large",
		'object_class', "Backpack",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Large_Old.png",
		'DisplayName', T(237924317237, --[[ModItemInventoryItemCompositeDef Backpack_Retro_Large DisplayName]] "Large Retro Backpack"),
		'DisplayNamePlural', T(651517839690, --[[ModItemInventoryItemCompositeDef Backpack_Retro_Large DisplayNamePlural]] "Large Retro Backpack"),
		'Description', T(413714257542, --[[ModItemInventoryItemCompositeDef Backpack_Retro_Large Description]] "This backpack was introduced in WWII"),
		'AdditionalHint', "",
		'Cost', 999,
		'CanAppearInShop', true,
		'RestockWeight', 70,
		'CategoryPair', "Backpack",
		'Weight', 3000,
		'PocketU', 4,
		'PocketL', 2,
		'PocketML', 2,
		'PocketS', 1,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Retro",
		'object_class', "Backpack",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Old.png",
		'DisplayName', T(892926173749, --[[ModItemInventoryItemCompositeDef Backpack_Retro DisplayName]] "Army Backpack"),
		'DisplayNamePlural', T(496921922532, --[[ModItemInventoryItemCompositeDef Backpack_Retro DisplayNamePlural]] "Army Backpacks"),
		'Description', T(642420161429, --[[ModItemInventoryItemCompositeDef Backpack_Retro Description]] "Older design but reliable"),
		'AdditionalHint', "",
		'Cost', 899,
		'CanAppearInShop', true,
		'CategoryPair', "Backpack",
		'Weight', 2000,
		'PocketU', 2,
		'PocketL', 1,
		'PocketML', 2,
		'Carabiner', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Mule",
		'object_class', "Backpack",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Flecktarn.png",
		'DisplayName', T(958570756965, --[[ModItemInventoryItemCompositeDef Backpack_Mule DisplayName]] "Large backpack"),
		'DisplayNamePlural', T(741881771429, --[[ModItemInventoryItemCompositeDef Backpack_Mule DisplayNamePlural]] "Large backpacks"),
		'Description', T(446908399915, --[[ModItemInventoryItemCompositeDef Backpack_Mule Description]] "Best used to carry a lot of stuff"),
		'AdditionalHint', "",
		'Cost', 1299,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CategoryPair', "Backpack",
		'Weight', 3000,
		'PocketU', 5,
		'PocketL', 3,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Combat",
		'object_class', "Backpack",
		'ScrapParts', 2,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Compact.png",
		'DisplayName', T(119232818951, --[[ModItemInventoryItemCompositeDef Backpack_Combat DisplayName]] "Combat Bag"),
		'DisplayNamePlural', T(150722396964, --[[ModItemInventoryItemCompositeDef Backpack_Combat DisplayNamePlural]] "Combat Bag"),
		'Description', T(548949425173, --[[ModItemInventoryItemCompositeDef Backpack_Combat Description]] "Smaller lighter backpack"),
		'AdditionalHint', "",
		'Cost', 1399,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CategoryPair', "Backpack",
		'PocketU', 1,
		'PocketL', 1,
		'PocketML', 2,
		'PocketS', 1,
		'Carabiner', 1,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Modern",
		'object_class', "Backpack",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Combat_Large.png",
		'DisplayName', T(631902319328, --[[ModItemInventoryItemCompositeDef Backpack_Modern DisplayName]] "Medium Backpack"),
		'DisplayNamePlural', T(192322619109, --[[ModItemInventoryItemCompositeDef Backpack_Modern DisplayNamePlural]] "Medium Backpacks"),
		'Description', T(477334984053, --[[ModItemInventoryItemCompositeDef Backpack_Modern Description]] "Modern backpack with a lot of space"),
		'AdditionalHint', "",
		'Cost', 1499,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CategoryPair', "Backpack",
		'Weight', 1500,
		'PocketU', 2,
		'PocketL', 1,
		'PocketM', 2,
		'PocketML', 3,
		'PocketS', 1,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Equipment - Backpack",
		'Id', "Backpack_Blackhawk",
		'object_class', "Backpack",
		'ScrapParts', 3,
		'Repairable', false,
		'Icon', "Mod/ii6mKUf/Items/Backpacks/Backpack_Black.png",
		'DisplayName', T(417316122517, --[[ModItemInventoryItemCompositeDef Backpack_Blackhawk DisplayName]] "Blackhawk Backpack"),
		'DisplayNamePlural', T(145682703827, --[[ModItemInventoryItemCompositeDef Backpack_Blackhawk DisplayNamePlural]] "Blackhawk Backpacks"),
		'Description', T(588305884029, --[[ModItemInventoryItemCompositeDef Backpack_Blackhawk Description]] "Black modern backpack"),
		'AdditionalHint', "",
		'Cost', 1599,
		'CanAppearInShop', true,
		'Tier', 2,
		'RestockWeight', 70,
		'CategoryPair', "Backpack",
		'Weight', 1500,
		'PocketU', 2,
		'PocketL', 2,
		'PocketML', 2,
		'PocketS', 1,
		'Carabiner', 2,
	}),
	PlaceObj('ModItemInventoryItemCompositeDef', {
		'Group', "Armor - Other",
		'Id', "FaceItem_Combat_Goggles",
		'object_class', "FaceItem",
		'ScrapParts', 2,
		'Icon', "Mod/ii6mKUf/Items/FaceItems/Face_combat_goggles.png",
		'ItemType', "Armor",
		'DisplayName', T(133813476634, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles DisplayName]] "Combat Goggles"),
		'DisplayNamePlural', T(711946176668, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles DisplayNamePlural]] "Combat Goggles"),
		'Description', T(640711670812, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles Description]] "Those goggles help in bad weather conditions"),
		'Cost', 599,
		'CanAppearInShop', true,
		'RestockWeight', 70,
		'CanBeConsumed', false,
		'PocketL_amount', 1,
		'PocketML_amount', 1,
		'Slot', "FaceItem",
		'DamageReduction', 1,
		'AdditionalReduction', 1,
		'ProtectedBodyParts', set( "Head" ),
		'TannedGoggles', true,
		'DustStormModifier', 50,
		'FireStormModifier', 50,
	}),
	PlaceObj('ModItemCode', {
		'name', "Inventory",
		'CodeFileName', "Code/Inventory.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "X_InventoryContextMenu",
		'CodeFileName', "Code/X_InventoryContextMenu.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LBEBuilder",
		'CodeFileName', "Code/LBEBuilder.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_Unit",
		'CodeFileName', "Code/OR_Unit.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LBEItemDef",
		'CodeFileName', "Code/LBEItemDef.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "LootDrop",
		'CodeFileName', "Code/LootDrop.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "X_Inventory",
		'CodeFileName', "Code/X_Inventory.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SlotDefs",
		'CodeFileName', "Code/SlotDefs.lua",
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
	PlaceObj('ModItemCode', {
		'name', "X_Utils",
		'CodeFileName', "Code/X_Utils.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_CombatActions",
		'CodeFileName', "Code/OR_CombatActions.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_MoveItem",
		'CodeFileName', "Code/OR_MoveItem.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_InventoryUI",
		'CodeFileName', "Code/OR_InventoryUI.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_Inventory",
		'CodeFileName', "Code/OR_Inventory.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_UnitProperties",
		'CodeFileName', "Code/OR_UnitProperties.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_Mercenary",
		'CodeFileName', "Code/OR_Mercenary.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "OR_SquadBag",
		'CodeFileName', "Code/OR_SquadBag.lua",
	}),
	PlaceObj('ModItemTextStyle', {
		RolloverTextColor = 4293320394,
		TextColor = 4293320394,
		TextFont = T(890719471418, --[[ModItemTextStyle REVLBELegendText TextFont]] "HMGothic Rough A, 16"),
		group = "Default",
		id = "REVLBELegendText",
	}),
	PlaceObj('ModItemCode', {
		'name', "SlotConfig",
		'CodeFileName', "Code/SlotConfig.lua",
	}),
}