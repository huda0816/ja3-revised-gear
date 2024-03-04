function BuildInventory(xTileObj, unit)
	local inventories = g_InventoryEquipSlots;

	local width = unit:GetSlotDataDim("Inventory")

	xTileObj.tiles = {}
	xTileObj.slot_name = "Inventory"
	for i = 1, width do xTileObj.tiles[i] = {} end
	local row = 0
	local column = 1

	for i, inventory in ipairs(inventories) do
		column = 7

		local startRow = i > 1 and row + 1 or false

		local slotObject = inventory.baseSlot and false or unit:GetItemInSlot(inventory.id)

		if slotObject then
			column, row = BuildInventorySlot(xTileObj, inventory, slotObject, column, row, i, startRow)
		elseif inventory.fallBack then
			column, row = BuildFallback(xTileObj, inventory, column, row, i, startRow)
		end

		if slotObject or inventory.fallBack then
			column, row = fillEmptySpace(xTileObj, inventory, column, row, row == startRow)
		end

	end

	xTileObj.item_windows = {}
	xTileObj.rollover_windows = {}
	xTileObj:InitialSpawnItems()
end

function BuildInventorySlot(xTileObj, equipSlot, equipItem, column, row, index, startRow)
	-- local startRow = index > 1 and row + 1 or false

	-- column = 7

	local slotTypes = REV_GetAvailableSlotTypes(equipSlot.id)

	for _, slotType in ipairs(slotTypes) do
		for i = 1, equipItem[slotType.id] or 0 do
			if column == 7 then
				column = 1
				row = row + 1
			end
			TileConfig.Type = slotType.id
			TileConfig.Size = "Small"
			BuildPocket(xTileObj, column, row, equipSlot.id, row == startRow)
			column = column + 1
		end
	end

	return column, row

	-- return fillEmptySpace(xTileObj, equipSlot, column, row, row == startRow)
end

function BuildFallback(xTileObj, equipSlot, column, row, index, startRow)
	-- local startRow = index > 1 and row + 1 or false

	-- column = 7

	for i, slot in ipairs(equipSlot.fallBack) do
		local slotType = REV_GetSlotTypeById(slot)
		if slotType or slot == "Disabled" then
			if column == 7 then
				column = 1
				row = row + 1
			end
			TileConfig.Type = slot
			TileConfig.Size = "Small"
			BuildPocket(xTileObj, column, row, equipSlot.id, row == startRow)
			column = column + 1
		end
	end

	return column, row

	-- return fillEmptySpace(xTileObj, equipSlot, column, row, row == startRow)
end

function fillEmptySpace(xTileObj, equipSlot, column, row, startRow)
	if column < 7 then
		for i = 1, 7 - column do
			TileConfig.Type = "Disabled"
			TileConfig.Size = "Small"
			BuildPocket(xTileObj, column, row, "Disabled", startRow)
			column = column + 1
		end
	end

	return column, row
end

function BuildPocket(xTileObj, column, row, objType, startRow)
	local tile = xTileObj:SpawnTile("Inventory", column, row)
	if tile then
		tile:SetBackground(REV_GetEquipSlotColor(objType))
		tile:SetContext(xTileObj:GetContext())
		tile:SetGridX(column)
		tile:SetGridY(row)
		tile.idBackImage:SetTransparency(xTileObj.image_transparency)
		tile.Type = TileConfig.Type
		tile.tileContext = objType
		xTileObj.tiles[column][row] = tile
		if tile.Type == "Disabled" then
			tile:SetEnabled(false)
		end
		if startRow then
			tile:SetMargins(box(0, 20, 0, 0))
		end
	end
end

function GetInventorySlots(unit, fakeItems)
	if not IsMerc(unit) then return end
	local contextTypes = {}
	local types = {}
	for i = 1, 6 do types[i] = {} end
	for i = 1, 6 do contextTypes[i] = {} end

	local column
	local row = 0

	local containers = g_InventoryEquipSlots

	for i, container in ipairs(containers) do
		column = 7

		local containerItem = unit:GetItemInSlot(container.id)

		if containerItem and IsKindOf(containerItem, container.type or container.id) then
			local slotTypes = REV_GetAvailableSlotTypes(container.id)

			for i, slotType in ipairs(slotTypes) do
				for j = 1, containerItem[slotType.id] or 0 do
					if column == 7 then
						column = 1
						row = row + 1
					end

					types[column][row] = slotType.id
					contextTypes[column][row] = container.id
					column = column + 1
				end
			end
		elseif container.fallBack then
			for i, slotType in ipairs(container.fallBack) do
				if column == 7 then
					column = 1
					row = row + 1
				end
				types[column][row] = slotType
				contextTypes[column][row] = container.id
				column = column + 1
			end
		end		

		if column < 7 then
			for j = 1, 7 - column do
				types[column][row] = "Disabled"
				contextTypes[column][row] = "Disabled"
				column = column + 1
			end
		end
	end

	return types, contextTypes
end
