function OnMsg.DataLoaded()
	PlaceObj('BobbyRayShopSubCategory', {
		Category = "Other",
		DisplayName = T(3722768203550816, --[[BobbyRayShopSubCategory Ammo UtilityAmmo DisplayName]] "LBE"),
		SortKey = 100,
		group = "Other",
		id = "LBE",
	})

	PlaceObj('BobbyRayShopSubCategory', {
		Category = "Other",
		DisplayName = T(3722768203550818, --[[BobbyRayShopSubCategory Ammo UtilityAmmo DisplayName]] "Backpacks"),
		SortKey = 110,
		group = "Other",
		id = "Backpack",
	})

	PlaceObj('BobbyRayShopSubCategory', {
		Category = "Other",
		DisplayName = T(3722768203550818, --[[BobbyRayShopSubCategory Ammo UtilityAmmo DisplayName]] "Leg Items"),
		SortKey = 110,
		group = "Other",
		id = "Holster",
	})
end

UndefineClass("PersonalStorage")
DefineClass.PersonalStorage = {
	__parents = {
		"InventoryItem",
		"BobbyRayShopOtherProperties"
	},
	properties = {
		{
			id = "items",
			name = "Items",
			editor = "table",
		}
	}
}



UndefineClass("LBE")
DefineClass.LBE = {
	__parents = {
		"PersonalStorage"
	},
	properties = REV_GenerateSlotDefs("LBE", {
		{
			category = "Misc",
			id = "Slot",
			name = "Slot",
			help = "Slot where the Item is equipped",
			default = "LBE",
			template = false
		}
	})
}

UndefineClass("Backpack")
DefineClass.Backpack = {
	__parents = {
		"PersonalStorage"
	},
	properties = REV_GenerateSlotDefs("Backpack", {
		{
			category = "Misc",
			id = "Slot",
			name = "Slot",
			help = "Slot where the Item is equipped",
			default = "Backpack",
			modifiable = false,
		}
	})
}

UndefineClass("Holster")
DefineClass.Holster = {
	__parents = {
		"PersonalStorage"
	},
	properties = REV_GenerateSlotDefs("Holster", {
		{
			category = "Misc",
			id = "Slot",
			name = "Slot",
			help = "Slot where the Item is equipped",
			default = "Holster",
			modifiable = false,
		}
	})
}


function PersonalStorage:GetRolloverHint()
	local hint = {}

	if self.AdditionalHint then
		hint[#hint + 1] = self.AdditionalHint
	end

	local items = self.items

	if #items > 0 then
		hint[#hint + 1] = T { 3785082730500816, "Stored Items:" }
	end

	g_StoredItemIdToItem = g_StoredItemIdToItem or {}

	for i, itemId in ipairs(items) do
		local item = g_ItemIdToItem[itemId] or g_StoredItemIdToItem[itemId]

		if item then
			local amount = item.Amount and T { 3785082730500819, " (" .. item.Amount .. ")" } or ""

			hint[#hint + 1] = T { 3785082730500817, "<bullet_point> " } .. item.DisplayName .. amount
		end
	end

	return table.concat(hint, "\n")
end

function PersonalStorage:Init()
	self.items = {}
end

AppendClass.InventoryItemProperties = {
	properties = {
		{
			id = "lastSlotPos",
			name = "Last Slot Position",
			editor = "text",
		},
		{
			id = "lastSlot",
			name = "Last Slot",
			editor = "text",
		},
		{
			id = "inventorySlot",
			name = "Inventory Slot",
			editor = "text",
		},
		{
			id = "container",
			name = "Container",
			editor = "number",
		}
	}
}

function OnMsg.DataLoaded()
	
	local armorTab = Presets.InventoryTab.Default.equipment

	armorTab.item_classes[#armorTab.item_classes + 1] = "PersonalStorage"

end
