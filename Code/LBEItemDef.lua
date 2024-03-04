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
		DisplayName = T(3722768203550818, --[[BobbyRayShopSubCategory Ammo UtilityAmmo DisplayName]] "Backpacks"),
		SortKey = 110,
		group = "Other",
		id = "Holster",
	})
end

function FirearmBase:Init()
	self.items = {}
end

UndefineClass("PersonalStorage")
DefineClass.PersonalStorage = {
	__parents = {
		"InventoryItem",
		"BobbyRayShopOtherProperties"
	},
	properties = {
		{
			category = "General",
			id = "Weight",
			name = "Empty Item weight",
			help = "Weight of the Item in grams",
			editor = "number",
			default = 1000,
			template = true,
			min = 0,
			max = 500000,
			modifiable = true,
		},
		{
			id = "Items"
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

	for i, item in ipairs(items) do
		hint[#hint + 1] = T { 3785082730500817, "<bullet_point> " }  .. item.DisplayName
	end

	return table.concat(hint, "\n")
end


-- AppendClass.InventoryItemProperties = {
-- 	lastSlotPos = false,
-- 	lastSlot = false,
-- 	inventorySlot = false,
-- 	container = false,
-- 	properties = {
-- 		{
-- 			id = "lastSlotPos",
-- 		},
-- 		{
-- 			id = "lastSlot",
-- 		},
-- 		{
-- 			id = "inventorySlot",
-- 		},
-- 		{
-- 			id = "container",
-- 		}
-- 	}
-- }