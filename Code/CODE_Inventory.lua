GameVar("g_StoredItemIdToItem", {})

function OnMsg.ItemAdded(obj, item, slot, pos)
	REV_OnItemAdded(obj, item, slot, pos)

	if REV_IsMerc(obj) then
		REV_ApplyWeightEffects(obj)
		InventoryUIRespawn()
	end
end

function OnMsg.ItemRemoved(obj, item, slot, pos)
	REV_OnItemRemoved(obj, item, slot, pos)

	if REV_IsMerc(obj) then
		REV_ApplyWeightEffects(obj)
		InventoryUIRespawn()
	end
end

function REV_GetEquippedItemContainer(unit, item, pos, slotName)
	local slotX, slotY = point_unpack(pos)

	local allSlots, allTypes = REV_GetInventorySlots(unit)

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
			table.insert(items, item.id)
		end
	end)

	return items
end

function REV_GetContainerRows(unit, slotName)
	local _, allTypes = REV_GetInventorySlots(unit)

	local slotRows = {}

	for i, row in ipairs(allTypes[1]) do
		if row == slotName then
			table.insert(slotRows, i)
		end
	end

	return slotRows
end

function REV_OnItemAdded(obj, item, slot, pos)
	-- print("ItemAdded", item.class)

	if IsEquipSlot(slot) and item:IsKindOfClasses("Backpack", "LBE", "Holster") then
		local inventoryEquipSlots = g_REV_InventoryEquipSlots

		local currentRow = 0

		g_StoredItemIdToItem = g_StoredItemIdToItem or {}

		local itemsToAdd = {}

		for i = #inventoryEquipSlots, 1, -1 do
			local slotObj = inventoryEquipSlots[i]

			local itemInSlot = REV_GetItemInEquipSlot(obj, slotObj.id)

			local slotRows = REV_GetContainerRows(obj, slotObj.id)

			if #slotRows > 0 or itemInSlot or slotObj.baseSlot or slotObj.fallBack then
				local itemsInSlot = itemInSlot and itemInSlot.items or REV_GetInventorySlotItems(obj, slotObj.id)

				for i, invItemId in ipairs(itemsInSlot) do
					local invItem = g_ItemIdToItem[invItemId] or g_StoredItemIdToItem[invItemId]
					local x, y = point_unpack(invItem.lastSlotPos)

					if slotObj.id ~= slot then
						invItem.removedWithContainer = true
						obj:RemoveItem("Inventory", invItem)
						invItem.removedWithContainer = nil
					end

					table.insert(itemsToAdd, { invItem, x, y, slotRows[1] - 1 })

					-- obj:AddItem("Inventory", invItem, x, y + slotRows[1] - 1, true)

					if not g_ItemIdToItem[invItem.id] then
						g_ItemIdToItem[invItem.id] = invItem
					else
						local oldItem = g_ItemIdToItem[invItem.id]

						if oldItem.class ~= invItem.class then
							invItem:Setid(GenerateItemId(), true)
						end
					end
				end
			end
		end

		for i, itemToAdd in ipairs(itemsToAdd) do
			local invItem, x, y, slotRows = table.unpack(itemToAdd)

			obj:AddItem("Inventory", invItem, x, y + slotRows, true)
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

			table.insert(container.items, item.id)
		end

		REV_CheckItemsInWrongSlots(obj)
	end
end

function REV_OnItemRemoved(obj, item, slot, pos)
	-- print("ItemRemoved", item.class)

	item.PrevOwner = item.owner

	if item.MaxStacks then
		item.MaxStacks = g_Classes[item.class].MaxStacks or 1
	end

	if IsEquipSlot(slot) and item:IsKindOfClasses("Backpack", "LBE", "Holster") then
		local inventoryEquipSlots = g_REV_InventoryEquipSlots

		-- remove items

		local removedItemItems = item.items

		g_StoredItemIdToItem = g_StoredItemIdToItem or {}

		for i, rItemId in ipairs(removedItemItems) do
			g_StoredItemIdToItem[rItemId] = g_ItemIdToItem[rItemId]
			local rItem = g_ItemIdToItem[rItemId]
			rItem.removedWithContainer = true
			obj:RemoveItem("Inventory", rItem)
			rItem.removedWithContainer = nil
		end

		for i, slotObj in ipairs(inventoryEquipSlots) do
			local itemInSlot = REV_GetItemInEquipSlot(obj, slotObj.id)

			if (itemInSlot or slotObj.baseSlot) and slotObj.id ~= slot then
				local itemsInSlot = itemInSlot and itemInSlot.items or REV_GetInventorySlotItems(obj, slotObj.id)

				local slotRows = REV_GetContainerRows(obj, slotObj.id)

				for i, invItemId in ipairs(itemsInSlot) do
					local invItem = g_ItemIdToItem[invItemId] or g_StoredItemIdToItem[invItemId]
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

			table.remove_value(container.items, item.id)

			if g_StoredItemIdToItem[item.id] then
				g_StoredItemIdToItem[item.id] = nil
			end
		end

		item.lastSlot = nil
		item.lastSlotPos = nil
		item.inventorySlot = nil
		item.container = nil
	end
end

function REV_CheckItemsInWrongSlots(unit)
	local slot_types, containerTypes = REV_GetInventorySlots(unit)
	local slot_name = "Inventory"
	unit:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top)
		if slot_types[left][top] then
			if not REV_ItemFitsTile(slot_item, slot_types[left][top], unit, left, top, true) then
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

function REV_GetItemInventorySlotNumber(item)
	local slotTypes = g_REV_SlotTypes

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

	local slots = g_REV_InventoryEquipSlots

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

	local _, slot_contextTypes = REV_GetInventorySlots(unit)

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

	local slot_types = REV_GetInventorySlots(unit)

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

	if slotType == "PocketU" or not slotType then
		return g_Classes[item.class].MaxStacks or 1
	end

	if slotType == "Disabled" then
		return 0
	end

	return item[slotType .. "_amount"] or 0
end

function REV_ItemFitsTile(item, type, unit, slotX, slotY, wholeStack)
	if type == "Disabled" then return false, "" end

	if not REV_IsMerc(unit) or not unit.Squad then
		return true
	end

	if IsKindOf(item, "PersonalStorage") and item.items and #item.items > 0 then
		return false, "Cannot add items with items in it"
	end

	if not type then
		return false, "No type"
	end

	local maxStack = REV_GetSlotTypeSizeForItem(type, item)

	if maxStack < 1 then
		return false, "Doesn't fit here"
	end

	local itemInSlot = unit:GetItemInSlot("Inventory", nil, slotX, slotY)

	if itemInSlot and itemInSlot.class ~= item.class then
		return false, "Different item: " .. itemInSlot.class
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

function REV_LargeItemFitsTile(item, slot_types, column, row, sdx, unit, wholeStack)
	if sdx == 0 then
		if column == 6 then return false, "Doesn't fit here" end
		if slot_types[column][row] ~= slot_types[column + 1][row] then
			return false, "Cannot be split between two different slots"
		end
		if not (REV_ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack) or REV_ItemFitsTile(item, slot_types[column + 1][row], unit, column, row, wholeStack)) then
			return false, "Doesn't fit here"
		else
			return true
		end
	elseif sdx == 1 then
		if column == 1 then return false, "Doesn't fit here" end
		if slot_types[column][row] ~= slot_types[column - 1][row] then
			return false, "Cannot be split between two different slots"
		end
		if not (REV_ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack) or REV_ItemFitsTile(item, slot_types[column - 1][row], unit, column, row, wholeStack)) then
			return false, "Doesn't fit here"
		else
			return true
		end
	else
		return false, "Doesn't fit here"
	end
end

function REV_FitTileCheck(item, slot_types, column, row, sdx, unit, wholeStack)
	if item:IsLargeItem() then
		return REV_LargeItemFitsTile(item, slot_types, column, row, sdx, unit, wholeStack)
	else
		return REV_ItemFitsTile(item, slot_types[column][row], unit, column, row, wholeStack)
	end
end

function REV_AppendToTable(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function REV_BuildSlotTypeProperties()
	local properties = {}

	for i, slotType in ipairs(g_REV_SlotTypes) do
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
	for i, equipSlot in ipairs(g_REV_InventoryEquipSlots) do
		if equipSlot.id == slotId then
			return equipSlot.color
		end
	end
end

function REV_GetEquippedSlots(unit, includeBaseInventory)
	local slots = {}
	for i, slot in ipairs(g_REV_InventoryEquipSlots) do
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

function REV_GetAvailableSlotTypes(type)
	local types = {}
	for i, slotType in ipairs(g_REV_SlotTypes) do
		if slotType.available and table.find(slotType.available, type) then
			table.insert(types, slotType)
		end
	end

	return types
end

function REV_GetSlotTypeById(id)
	for i, slotType in ipairs(g_REV_SlotTypes) do
		if slotType.id == id then
			return slotType
		end
	end
end

function REV_GenerateSlotDefs(type, properties)
	local defs = {}
	for i, slotType in ipairs(g_REV_SlotTypes) do
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

function REV_IsUnloadEnabled(context)
	return context.item.items and #context.item.items > 0 and true or false
end

function REV_UnloadItems(context)
	local container = context.container
	local putcontainer

	if IsKindOf(container, "SectorStash") then
		putcontainer = container
	elseif not container and IsKindOf(context.context, "UnitData") then
		local squad = context.context.Squad
		squad = squad and gv_Squads[squad]
		local sectorId = squad.CurrentSector
		putcontainer = GetSectorInventory(sectorId)
	end

	g_StoredItemIdToItem = g_StoredItemIdToItem or {}

	for i, itemId in ipairs(context.item.items) do
		local item = g_ItemIdToItem[itemId] or g_StoredItemIdToItem[itemId]

		if IsEquipSlot(context.slot_wnd.slot_name) then
			item.removedWithContainer = true
			context.unit:RemoveItem("Inventory", item)
			item.removedWithContainer = nil
		end

		if putcontainer then
			putcontainer:AddItem("Inventory", item)
		elseif not container or not container:AddItem("Inventory", item) then
			container = PlaceObject("ItemDropContainer")
			local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
			container:SetPos(drop_pos or context.unit:GetPos())
			container:SetAngle(container:Random(21600))
			container:AddItem("Inventory", item)
		end

		item.lastSlot = nil
		item.lastSlotPos = nil
		item.inventorySlot = nil
		item.container = nil

		if g_StoredItemIdToItem[itemId] then
			g_StoredItemIdToItem[item.id] = nil
		end

		if not g_ItemIdToItem[item.id] then
			g_ItemIdToItem[item.id] = item
		else
			local oldItem = g_ItemIdToItem[item.id]

			if oldItem.class ~= item.class then
				item:Setid(GenerateItemId(), true)
			end
		end
	end

	context.item.items = {}

	InventoryUIRespawn()
end

function REV_IsMerc(o)
	local id
	if IsKindOf(o, "Unit") then
		id = o.unitdatadef_id
	elseif IsKindOf(o, "UnitData") then
		id = o.class
	end

	if RevisedLBEConfig.MilitiaUsesLBE then
		if gv_UnitData[o.session_id] and gv_UnitData[o.session_id].Squad then
			local squad = gv_Squads[gv_UnitData[o.session_id].Squad]
			if squad.militia and (squad.Side == "player1" or squad.Side == "player2") then
				return true
			end
		end
	end

	if IsKindOf(o, "UnitDataCompositeDef") then
		return o.IsMercenary
	end
	return id and UnitDataDefs[id].IsMercenary
end
