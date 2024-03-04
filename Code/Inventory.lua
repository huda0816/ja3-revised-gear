function REV_GetEquippedItemContainer(unit, item, pos, slotName)
	local slotX, slotY = point_unpack(pos)

	local allSlots, allTypes = GetInventorySlots(unit)

	local slotName = allTypes[slotX][slotY]

	local slotRows = {}

	for i, row in ipairs(allTypes[1]) do
		if row == slotName then
			table.insert(slotRows, i)
		end
	end

	local container = unit:GetItemInSlot(slotName)

	return container, slotName, slotRows
end

function REV_GetItemInEquipSlot(unit, slotName)
	local item = unit:GetItemInSlot(slotName)

	return item
end

function REV_GetInventorySlotItems(unit, InventorySlotName)
	local items = {}

	unit:ForEachItemInSlot("Inventory", function(item, slotName, left, top)
		if item.inventorySlot == InventorySlotName then
			table.insert(items, item)
		end
	end)

	return items
end

function REV_GetContainerItems(unit, container)
	local items = {}

	unit:ForEachItemInSlot("Inventory", function(item, slotName, left, top)
		if item.container == container.id then
			table.insert(items, item)
		end
	end)

	return items
end

function REV_GetContainerRows(unit, slotName)
	local _, allTypes = GetInventorySlots(unit)

	local slotRows = {}

	for i, row in ipairs(allTypes[1]) do
		if row == slotName then
			table.insert(slotRows, i)
		end
	end

	return slotRows
end

function OnMsg.ItemAdded(obj, item, slot, pos)
	if IsEquipSlot(slot) and item:IsKindOfClasses("Backpack", "LBE", "Holster") then
		local inventoryEquipSlots = g_InventoryEquipSlots

		-- local prevOwner = item.PrevOwner and item.PrevOwner ~= item.owner and gv_UnitData[item.PrevOwner]

		local currentRow = 0

		for i, slotObj in ipairs(inventoryEquipSlots) do
			local itemInSlot = REV_GetItemInEquipSlot(obj, slotObj.id)

			local slotRows = REV_GetContainerRows(obj, slotObj.id)

			if #slotRows > 0 or itemInSlot or slotObj.baseSlot or slotObj.fallBack then
				local itemsInSlot = itemInSlot and itemInSlot.items or REV_GetInventorySlotItems(obj, slotObj.id)

				for i, invItem in ipairs(itemsInSlot) do
					local x, y = point_unpack(invItem.lastSlotPos)

					-- if prevOwner and slotObj.id == slot then
					-- 	prevOwner:RemoveItem("Inventory", invItem)
					if slotObj.id ~= slot then
						invItem.removedWithContainer = true
						obj:RemoveItem("Inventory", invItem)
						invItem.removedWithContainer = nil
					end

					obj:AddItem("Inventory", invItem, x, y + slotRows[1] - 1, true)
				end
			end
		end
	end


	if slot == "Inventory" then
		local container, slotName, slotRows = REV_GetEquippedItemContainer(obj, item, pos, slot)

		local x, y = point_unpack(pos)

		local slotPos = point_pack(x, y - slotRows[1] + 1)

		item.lastSlot = slot
		item.lastSlotPos = slotPos
		item.inventorySlot = slotName
		item.container = container and container.id


		if container then
			container.items = container.items or {}

			table.insert(container.items, item)
		end
	end
end

function OnMsg.ItemRemoved(obj, item, slot, pos)
	item.PrevOwner = item.owner

	if IsEquipSlot(slot) and item:IsKindOfClasses("Backpack", "LBE", "Holster") then
		local inventoryEquipSlots = g_InventoryEquipSlots

		-- remove items

		local removedItemItems = item.items

		for i, rItem in ipairs(removedItemItems) do
			rItem.removedWithContainer = true
			obj:RemoveItem("Inventory", rItem)
			rItem.removedWithContainer = nil
		end

		for i, slotObj in ipairs(inventoryEquipSlots) do
			local itemInSlot = REV_GetItemInEquipSlot(obj, slotObj.id)

			if itemInSlot or slotObj.baseSlot then
				local itemsInSlot = itemInSlot and itemInSlot.items or REV_GetInventorySlotItems(obj, slotObj.id)

				local slotRows = REV_GetContainerRows(obj, slotObj.id)

				for i, invItem in ipairs(itemsInSlot) do
					local x, y = point_unpack(invItem.lastSlotPos)

					invItem.removedWithContainer = true
					obj:RemoveItem("Inventory", invItem)
					invItem.removedWithContainer = nil

					obj:AddItem("Inventory", invItem, x, y + slotRows[1] - 1, true)
				end
			end
		end
	end

	if slot == "Inventory" and not item.removedWithContainer then
		local container = item.container and g_ItemIdToItem[item.container]

		if container then
			container.items = container.items or {}

			table.remove_value(container.items, item)
		end

		item.lastSlot = nil
		item.lastSlotPos = nil
		item.inventorySlot = nil
		item.container = nil
	end
end

function OnMsg.InventoryChange(obj)
	if IsMerc(obj) then
		CheckItemsInWrongSlots(obj)
		ApplyWeightEffects(obj)
		InventoryUIRespawn()
	end
	-- end
end

function REV_DropItems(unit, items)
	local container = GetDropContainer(unit)

	for i, item in ipairs(items) do
		unit:RemoveItem("Inventory", item)
		if not container:AddItem("Inventory", item) then
			container = PlaceObject("ItemDropContainer")
			local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
			container:SetPos(drop_pos or unit:GetPos())
			container:SetAngle(container:Random(21600))
			container:AddItem("Inventory", item)
		end
	end
end

-- function REV_GetPreviousInventoryItems(unit, item, prevSlot)
-- 	local allSlots, allTypes = GetInventorySlots(unit, { [prevSlot] = item })

-- 	local items = {}

-- 	for i, column in ipairs(allSlots) do
-- 		for j = 1, #column do
-- 			if allTypes[i][j] == prevSlot then
-- 				local itemInSlot = unit:GetItemInSlot("Inventory", nil, i, j)

-- 				if itemInSlot then
-- 					table.insert(items, itemInSlot)
-- 				end
-- 			end
-- 		end
-- 	end

-- 	return items
-- end

function CheckItemsInWrongSlots(unit)
	local slot_types, containerTypes = GetInventorySlots(unit)
	local slot_name = "Inventory"
	unit:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top)
		if slot_types[left][top] then
			if not ItemFitsTile(slot_item, slot_types[left][top], unit, left, top, true) then
				local slot_x, slot_y = unit:FindEmptyPosition(slot_name, slot_item)
				if slot_x then
					unit:RemoveItem(slot_name, slot_item)
					unit:AddItem(slot_name, slot_item, slot_x, slot_y)
				else
					local container = GetDropContainer(unit)
					unit:RemoveItem(slot_name, slot_item)
					if not container:AddItem("Inventory", slot_item) then
						container = PlaceObject("ItemDropContainer")
						local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
						container:SetPos(drop_pos or unit:GetPos())
						container:SetAngle(container:Random(21600))
						container:AddItem("Inventory", slot_item)
					end
				end
			end
		else
			local slot_x, slot_y = unit:FindEmptyPosition(slot_name, slot_item)
			if slot_x then
				unit:RemoveItem(slot_name, slot_item)
				unit:AddItem(slot_name, slot_item, slot_x, slot_y)
			else
				local container = GetDropContainer(unit)
				unit:RemoveItem(slot_name, slot_item)
				print("Item removed from invalid slot", slot_item)
				if not container:AddItem("Inventory", slot_item) then
					container = PlaceObject("ItemDropContainer")
					local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
					container:SetPos(drop_pos or unit:GetPos())
					container:SetAngle(container:Random(21600))
					container:AddItem("Inventory", slot_item)
				end
			end
		end
	end)
end

function REV_GetTileBackgroundColor(context)
	if context == "LBE" then
		return RGB(20, 30, 40)
	elseif context == "Backpack" then
		return RGB(30, 40, 50)
	else
		return RGB(88, 92, 68)
	end
end

function REV_GetItemInventorySlotNumber(item)
	local slotTypes = g_SlotTypes

	local total = 0

	for i, slotType in ipairs(slotTypes) do
		total = total + (item[slotType.id] or 0)
	end

	return total
end

function REV_IsItemFirstRow(item)
	local unit = item.owner and gv_UnitData[item.owner]

	if not unit then
		return
	end

	local _, slotY = unit:GetItemPos(item)

	if not slotY or slotY == 1 then
		return false
	end

	local startRow = 1

	local slots = g_InventoryEquipSlots

	for i, slot in ipairs(slots) do
		local equippedItem = slot.baseSlot and false or unit:GetItemInSlot(slot.id)

		local totalSlots = equippedItem and REV_GetItemInventorySlotNumber(equippedItem) or
			slot.fallBack and #slot.fallBack or 0

		if totalSlots > 0 then
			local rowCount = totalSlots / 6 + (totalSlots % 6 == 0 and 0 or 1)

			startRow = startRow + rowCount

			if slotY == startRow then
				return true
			end
		end
	end
end

function REV_GetItemSlotContext(unit, item)
	local slotX, slotY = unit:GetItemPos(item)

	if not slotX or not slotY then
		return
	end

	local _, slot_contextTypes = GetInventorySlots(unit)

	return slot_contextTypes[slotX][slotY]
end

function REV_GetItemSlotType(item)
	local unit = item.owner and gv_UnitData[item.owner]

	if not unit then
		return
	end

	local slot = unit:GetItemSlot(item)

	if slot ~= "Inventory" then
		return slot
	end

	local slotX, slotY = unit:GetItemPos(item)

	local slot_types = GetInventorySlots(unit)

	local tile = slot_types[slotX][slotY]

	return tile
end

function REV_GetHandheldType(item)
	local unit = item.owner and gv_UnitData[item.owner]

	if not unit then
		return
	end

	local handheldItems, slots = unit:GetHandheldItems()

	for i, hhItem in ipairs(handheldItems) do
		if hhItem.id == item.id then
			return slots[i]
		end
	end
end

function REV_GetMaxStackInSlot(item)
	local slotType = REV_GetHandheldType(item) or REV_GetItemSlotType(item) or "PocketU"

	local amount = REV_GetSlotTypeSizeForItem(slotType, item)

	return amount
end

function REV_GetSlotTypeSizeForItem(slotType, item)
	if IsEquipSlot(slotType) then
		return 1
	end

	if slotType == "PocketU" then
		return g_Classes[item.class].MaxStacks or 1
	end

	if slotType == "Disabled" then
		return 0
	end

	return item[slotType .. "_amount"] or 0
end

function ItemFitsTile(item, type, unit, slotX, slotY, wholeStack)
	if type == "Disabled" then return false, "" end

	if IsKindOf(item, "PersonalStorage") and item.items and #item.items > 0 then
		return false, "Cannot add items with items in it"
	end

	if not type then
		print(item.class)
		return false, "No type"
	end

	local maxStack = REV_GetSlotTypeSizeForItem(type, item)

	if maxStack < 1 then
		return false, "Doesn't fit here"
	end

	local itemInSlot = unit:GetItemInSlot("Inventory", nil, slotX, slotY)

	if itemInSlot and itemInSlot.class ~= item.class then
		return false, "Different item"
	end

	local amount = 0

	if itemInSlot and itemInSlot.id ~= item.id then
		local amount = itemInSlot.Amount == nil and 1 or itemInSlot.Amount

		if amount >= maxStack then
			return false, "Stack is full"
		end
	end

	if wholeStack and (amount + (item.Amount == nil and 1 or item.Amount)) > maxStack then
		return false, "Not enough space"
	end

	return true
end

function LargeItemFitsTile(item, slot_types, column, row, sdx, unit, wholeStack)
	if sdx == 0 then
		if column == 6 then return false end
		if slot_types[column][row] ~= slot_types[column + 1][row] then
			return false, "Cannot be split between two different slots"
		end
		if not (ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack) or ItemFitsTile(item, slot_types[column + 1][row], unit, column, row, wholeStack)) then
			return false, "Doesn't fit here"
		else
			return true
		end
	elseif sdx == 1 then
		if column == 1 then return false end
		if slot_types[column][row] ~= slot_types[column - 1][row] then
			return false, "Cannot be split between two different slots"
		end
		if not (ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack) or ItemFitsTile(item, slot_types[column - 1][row], unit, column, row, wholeStack)) then
			return false, "Doesn't fit here"
		else
			return true
		end
	else
		return false, "Doesn't fit here"
	end
end

function FitTileCheck(item, slot_types, column, row, sdx, unit, wholeStack)
	if item:IsLargeItem() then
		return LargeItemFitsTile(item, slot_types, column, row, sdx, unit, wholeStack)
	else
		return ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack)
	end
end
