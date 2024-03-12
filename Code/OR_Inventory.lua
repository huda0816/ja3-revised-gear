function Inventory:FindEmptyPosition(slot_name, item, local_changes)
	local slot_data = self:GetSlotData(slot_name)
	local space = {}
	--local rects = {}
	local width, height, last_row_width = self:GetSlotDataDim(slot_name)
	for i = 1, width do
		space[i] = {}
	end
	local free_space = self:GetMaxTilesInSlot(slot_name)
	local fe = local_changes and local_changes.force_empty

	self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top, space)
		local item_width = slot_item:GetUIWidth()
		local item_height = slot_item:GetUIHeight()
		for i = left, left + item_width - 1 do
			for j = top, top + item_height - 1 do
				if not fe or not fe[xxhash(i, j)] then
					space[i][j] = true
				else
					free_space = free_space + 1
				end
			end
		end
		free_space = free_space - item_width * item_height
		--rects[#rects+1] = sizebox(left, top, item_width, item_height)
	end, space)

	-- custom code starts here

	if slot_name == "Inventory" and IsMerc(self) and self.session_id then
		local slot_types = REV_GetInventorySlots(self)
		if slot_types then
			for i = 1, width do
				for j = 1, height do
					local fits, reason = REV_ItemFitsTile(item, slot_types[i][j], self, i, j, true)

					if not fits then
						space[i][j] = true
					end
				end
			end
		end
	end

	-- custom code ends here


	local iwidth = item:GetUIWidth()
	local iheight = item:GetUIHeight()

	if free_space < iwidth * iheight then
		return
	end

	local x, y = 1, 1
	local raw_width = width
	while x <= raw_width and y <= height and (x + iwidth - 1) <= raw_width and (y + iheight - 1) <= height do
		local full = false
		for i = x, x + iwidth - 1 do
			for j = y, y + iheight - 1 do
				if not space[i] or space[i][j] or (local_changes and local_changes[xxhash(i, j)]) then
					full = true
					break
				end
			end
			if full then
				break
			end
		end
		if not full then
			return x, y
		end
		x = x + 1
		if x > raw_width or (x + iwidth - 1) > raw_width then
			x = 1
			y = y + 1
			if y == height then
				raw_width = last_row_width
			end
		end
	end
end

local REV_Original_GetSlotDataDim = Inventory.GetSlotDataDim

function Inventory:GetSlotDataDim(slot_name)
	if not IsMerc(self) or not self.session_id or slot_name ~= "Inventory" then
		return REV_Original_GetSlotDataDim(self, slot_name)
	end

	local max_tiles = self:GetMaxTilesInSlot("Inventory")

	local last_row_width = 6
	local width = 6
	local height = max_tiles / width
	return width, height, last_row_width
end

function InventoryStack:GetItemSlotUI()
	local max = REV_GetMaxStackInSlot(self)

	local maxMax = g_Classes[self.class].MaxStacks

	max = max or self.MaxStacks or maxMax

	if max > maxMax then
		max = maxMax
	end

	return T { 709831548750, "<style InventoryItemsCount><cur><valign bottom 0><style InventoryItemsCountMax>/<max></style>",
		cur = self.Amount, max = max }
end

local REV_OriginaGetItemInSlot = Inventory.GetItemInSlot

function Inventory:GetItemInSlot(slot_name, base_class, left, top)
	if base_class and base_class == "GasMaskBase" then
		slot_name = "FaceItem"
	end

	return REV_OriginaGetItemInSlot(self, slot_name, base_class, left, top)
end

function InvContextMenuEquippable(context)
	if not InventoryIsContainerOnSameSector(context) then
		return false
	end

	if not context or not context.item then return false end
	if context.item.locked then return false end
	if not InvContextMenuFilter(context) then return false end
	if not gv_SatelliteView and not InventoryIsValidGiveDistance(context.context, context.unit) then
		return false
	end

	local equippable = context.item:IsKindOfClasses("Armor", "Firearm", "MeleeWeapon", "HeavyWeapon")

	local not_equippable = context.item:IsKindOfClasses("InventoryStack", "ToolItem", "Medicine",
		"Valuables", "ValuableItemContainer", "QuestItem", "ConditionAndRepair",
		"MiscItem", "TrapDetonator", "ValuablesStack", "Grenade", "QuickSlotItem")

	return equippable or not not_equippable
end

function UnloadWeapon(item, squadBag)
	local ammo = item.ammo
	item.ammo = false
	local owner = item.owner and (g_Units[item.owner] or gv_UnitData[item.owner]) or false
	if ammo and ammo.Amount > 0 then
		UnitAddAndStackItem(ammo, squadBag, owner)
	end
	if IsKindOf(item, "Firearm") then
		item:OnUnloadWeapon()
	end
end

function UnitAddAndStackItem(ammo, squadBag, owner)
	if not owner and squadBag then
		squadBag:AddAndStackItem(ammo, squadBag, owner)
		return
	end

	MergeStackIntoContainer(owner, "Inventory", ammo)

	if ammo.Amount > 0 then
		if not owner:AddItem("Inventory", ammo) then
			if squadBag and (not InventoryIsCombatMode(owner) or IsKindOf(owner, "UnitData")) then
				squadBag:AddAndStackItem(ammo)
			else
				local container = PlaceObject("ItemDropContainer")
				local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
				container:SetPos(drop_pos or owner:GetPos())
				container:SetAngle(container:Random(21600))
				container:AddItem("Inventory", ammo)
			end
		end
		ObjModified(ammo)
	else
		DoneObject(ammo)
	end
end
