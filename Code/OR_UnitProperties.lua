local REV_Original_UnitPropertiesGetInventoryMaxSlots = UnitProperties.GetInventoryMaxSlots

function UnitProperties:GetInventoryMaxSlots()
	if REV_IsMerc(self) then
		local slots = g_REV_InventoryEquipSlots

		local inventorySlots = 0

		for i, container in ipairs(slots) do
			local containerItem = self:GetItemInSlot(container.id)

			local containerItemType = container.type or container.id

			if IsKindOf(containerItem, containerItemType) then

				local totalSlots = REV_GetItemInventorySlotNumber(containerItem)

				inventorySlots = inventorySlots + totalSlots + (6 - (totalSlots % 6 > 0 and totalSlots % 6 or 6))
			elseif container.fallBack then
					inventorySlots = inventorySlots + #container.fallBack + (6 - (#container.fallBack % 6 > 0 and #container.fallBack % 6 or 6))
			end
		end

		return inventorySlots

	end
	return REV_Original_UnitPropertiesGetInventoryMaxSlots(self)
end