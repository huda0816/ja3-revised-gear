CustomPDA.locked = false
Ted.locked = false
PierreMachete.locked = false
Personal_Vicki_CustomTools.locked = false
gv_CampaignStarted = false


RevisedLBEConfig = {
	LBEDropChance = 10,
	SquadBagHasWeight = true,
	TannedGoogleSightModifier = 105,
}

g_SlotTypes = {
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

g_InventoryEquipSlots = {
	{
		id = "BaseInventory",
		color = RGB(88, 92, 68),
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
		color = RGB(84, 74, 72),
		displayName = "Right Leg",
		type = "Holster",
		-- fallBack = {
		-- 	"PocketS",
		-- 	"PocketM",
		-- }
	},
	{
		id = "RHolster",
		color = RGB(52, 45, 41),
		displayName = "Left Leg",
		type = "Holster",
		-- fallBack = {
		-- 	"PocketS",
		-- 	"PocketM",
		-- }
	},
	{
		id = "LBE",
		color = RGB(20, 30, 40),
		displayName = "LBE"
	},
	{
		id = "Backpack",
		color = RGB(30, 40, 50),
		displayName = "Backpack"
	}
}

function REV_BuildSlotTypeProperties()
	local properties = {}

	for i, slotType in ipairs(g_SlotTypes) do
		if slotType.id ~= "PocketU" then
			local property = {
				category = "LBE",
				template = true,
				id = slotType.id .. '_amount',
				name = slotType.displayName,
				editor = "number",
				default = 0,
				min = 0,
				max = 10000,
				help = slotType.description
			}

			table.insert(properties, property)
		end
	end

	return properties
end

function REV_GetEquipSlotColor(slotId)
	slotId = slotId or "Inventory"
	for i, equipSlot in ipairs(g_InventoryEquipSlots) do
		if equipSlot.id == slotId then
			return equipSlot.color
		end
	end
end

function REV_GetEquippedSlots(unit, includeBaseInventory)
	local slots = {}
	for i, slot in ipairs(g_InventoryEquipSlots) do
		if slot.fallBack then
			if includeBaseInventory then
				table.insert(slots, slot)
			end
		else
			local item = unit:GetItemInSlot(slot.id)
			if item then
				table.insert(slots, slot)
			end
		end
	end
	return slots
end

function REV_GetEquippedEquipSlotItems(unit)
	local items = {}
	for i, slot in ipairs(g_InventoryEquipSlots) do
		local item = unit:GetItemInSlot(slot.id)
		if item then
			table.insert(items, { item = item, slot = slot.id })
		end
	end

	return items
end

function REV_GetAvailableSlotTypes(type)
	local types = {}
	for i, slotType in ipairs(g_SlotTypes) do
		if slotType.available and table.find(slotType.available, type) then
			table.insert(types, slotType)
		end
	end

	return types
end

function REV_GetSlotTypeById(id)
	for i, slotType in ipairs(g_SlotTypes) do
		if slotType.id == id then
			return slotType
		end
	end
end

function REV_GenerateSlotDefs(type, properties)
	local defs = {}
	for i, slotType in ipairs(g_SlotTypes) do
		if slotType.available and table.find(slotType.available, type) then
			local def = {
				category = "Setup",
				id = slotType.id,
				name = slotType.displayName,
				help = slotType.description,
				editor = "number",
				default = 0,
				template = true,
				min = 0,
				max = 100,
				slider = true,
				modifiable = true,
			}

			table.insert(defs, def)
		end
	end

	if properties then
		for i, property in ipairs(properties) do
			table.insert(defs, property)
		end
	end

	return defs
end