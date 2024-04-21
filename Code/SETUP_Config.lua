CustomPDA.locked = false
Ted.locked = false
PierreMachete.locked = false
Personal_Vicki_CustomTools.locked = false


RevisedLBEConfig = {
	LBEDropChance = 5,
	SquadBagHasWeight = true,
	TannedGoogleSightModifier = 105,
	MilitiaUsesLBE = true,
	PouchesHoldBullets = false,
	LighterItems = false,
}

g_REV_SlotTypes = {
	{
		id = "PocketU",
		displayName = "Utility Pocket",
		description = "A large utility pocket for storing items.",
		available = { 'Backpack' },
		icon = nil
	},
	{
		id = "PocketL",
		displayName = "Large Pocket",
		description = "A large pocket for storing items.",
		available = { 'LBE', 'Backpack', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PocketL.png",
	},
	{
		id = "PocketM",
		displayName = "Medium Pocket",
		description = "A medium pocket for storing items.",
		available = { 'LBE', 'Backpack', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PocketM.png",
	},
	{
		id = "PocketML",
		displayName = "Medium Large Pocket",
		description = "A medium large pocket for storing items.",
		available = { 'LBE', 'Backpack', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PocketML.png",
	},
	{
		id = "PocketS",
		displayName = "Small Pocket",
		description = "A small pocket for storing items.",
		available = { 'LBE', 'Backpack', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PocketS.png",
	},
	{
		id = "RifleMag",
		displayName = "Rifle Magazine",
		description = "A pocket for a rifle magazine.",
		available = { 'LBE', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_LargeMag.png",
	},
	{
		id = "PistolMag",
		displayName = "Pistol Magazine",
		description = "A pistol magazine for storing ammo.",
		available = { 'LBE', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PistolMag.png",
	},
	{
		id = "PistolHolster",
		displayName = "Pistol Holster",
		description = "A holster for storing a pistol.",
		available = { 'LBE', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_PistolHolster.png",
	},
	{
		id = "KnifeSheath",
		displayName = "Knife Sheath",
		description = "A sheath for storing a knife.",
		available = { 'LBE', 'LHolster', 'RHolster', 'Holster' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_KniveSheath.png",
	},
	{
		id = "Carabiner",
		displayName = "Carabiner",
		description = "A carabiner for adding extra storage.",
		available = { 'LBE', 'Backpack' },
		icon = "Mod/ii6mKUf/Lbeicons/T_Backpack_Slot_Small_Carabiner.png",
	}
}

g_REV_InventoryEquipSlots = {
	{
		id = "BaseInventory",
		color = RGBA(88, 92, 68, 130),
		displayName = "Base",
		baseSlot = true,
		fallBack = {
			"PocketU",
			"PocketU",
			"PocketM",
			"PocketM",
			"PocketS",
			"KnifeSheath"
		}
	},
	{
		id = "LHolster",
		color = RGBA(84, 74, 72, 130),
		displayName = "Right Leg",
		type = "Holster",
		-- fallBack = {
		-- 	"PocketS",
		-- 	"PocketM",
		-- }
	},
	{
		id = "RHolster",
		color = RGBA(78, 72, 72, 130),
		displayName = "Left Leg",
		type = "Holster",
		-- fallBack = {
		-- 	"PocketS",
		-- 	"PocketM",
		-- }
	},
	{
		id = "LBE",
		color = RGBA(20, 30, 40, 130),
		displayName = "LBE"
	},
	{
		id = "Backpack",
		color = RGBA(30, 40, 50, 130),
		displayName = "Backpack"
	}
}