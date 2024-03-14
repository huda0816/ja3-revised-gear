AppendClass.InventoryItem = {
	properties = REV_BuildSlotTypeProperties()
}

AppendClass.UnitInventory = {
	inventory_slots = REV_AppendToTable(UnitInventory.inventory_slots, {
		{ slot_name = "FaceItem", width = 1, height = 1, base_class = "InventoryItem", check_slot_name = true, enabled = true },
		{ slot_name = "NVG", width = 1, height = 1, base_class = "InventoryItem", check_slot_name = true, enabled = true },
		{ slot_name = "Backpack", width = 1, height = 1, base_class = "InventoryItem", check_slot_name = true, enabled = true },
		{ slot_name = "LBE", width = 1, height = 1, base_class = "InventoryItem", check_slot_name = true, enabled = true },
		{ slot_name = "LHolster", width = 1, height = 1, base_class = "Holster", check_slot_name = false, enabled = true },
		{ slot_name = "RHolster", width = 1, height = 1, base_class = "Holster", check_slot_name = false, enabled = true },
	})
}

local equip_slots = {
	["Handheld A"] = true,
	["Handheld B"] = true,
	["Head"] = true,
	["Legs"] = true,
	["NVG"] = true,
	["FaceItem"] = true,
	["Torso"] = true,	
	["Backpack"] = true,
	["LBE"] = true,
	["LHolster"] = true,
	["RHolster"] = true
}

function IsEquipSlot(slot_name)
	return equip_slots[slot_name]
end

local equip_slot_images = {
	["Head"]  = "UI/Icons/Items/background_helmet",	
	["Legs"]  = "UI/Icons/Items/background_pants", 
	["Torso"]  = "UI/Icons/Items/background_vest", 
	["Handheld A"]  = "UI/Icons/Items/background_weapon",
	["Handheld B"]  = "UI/Icons/Items/background_weapon",
	["Handheld A Big"]  = "UI/Icons/Items/background_weapon_big",
	["Handheld B Big"]  = "UI/Icons/Items/background_weapon_big", 
	["Backpack"]  = "Mod/ii6mKUf/Images/background_backpack.png", 
	["LBE"]  = "Mod/ii6mKUf/Images/background_lbe.png",
	["FaceItem"]  = "Mod/ii6mKUf/Images/background_face.png", 
	["NVG"]  = "Mod/ii6mKUf/Images/background_nvg.png",
	["LHolster"]  = "Mod/ii6mKUf/Images/background_holster.png",
	["RHolster"]  = "Mod/ii6mKUf/Images/background_holster.png",
}

function EquipInventorySlot:SpawnTile(slot_name)
	return XInventoryTile:new({slot_image = equip_slot_images[slot_name]}, self)
end

function OnMsg.ClassesGenerate()
	NightVisionGoggles.Slot = "NVG"
	GasMask.Slot = "FaceItem"
	GasMaskBase.Slot = "FaceItem"
	GasMaskBase.__parents = {"FaceItem"}
	GasMask.DaylightSightModifier = 90
end

UndefineClass("FaceItem")
DefineClass.FaceItem = {
	__parents = {
		"Armor"
	},
	properties = {
		{
			category = "General",
			id = "TannedGoggles",
			name = "Tanned googles",
			help = "Check this box to give the unit a bonus to sight during daylight.",
			editor = "bool",
			default = false,
			template = true,
			modifiable = true,
		},
		{
			category = "General",
			id = "DustStormModifier",
			name = "Dust Storm Penalty reduction",
			help = "Percentage",
			editor = "number",
			default = 0,
			template = true,
			min = 0,
			max = 100,
			slider = true,
			modifiable = true,
		},
		{
			category = "General",
			id = "FireStormModifier",
			name = "Fire Storm Penalty reduction",
			help = "Percentage",
			editor = "number",
			default = 0,
			template = true,
			min = 0,
			max = 100,
			slider = true,
			modifiable = true,
		},
	}
}