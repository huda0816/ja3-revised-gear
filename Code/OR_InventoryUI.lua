local tile_size = 90
local tile_size_rollover = 110

TileConfig = {
	Type = "Small",
	Size = "Small",
}

local REV_Original_XInventoryTileInit = XInventoryTile.Init

function XInventoryTile:Init()
	local k = 1
	local emptyImage = "UI/Inventory/T_Backpack_Slot_Small_Empty.tga"
	local hoverImage = "UI/Inventory/T_Backpack_Slot_Small_Hover.tga"
	local imageBase = "UI/Inventory/T_Backpack_Slot_Small.tga"

	local slotTypes = g_SlotTypes

	if TileConfig.Size == "Large" then
		k = 2
		emptyImage = "UI/Inventory/T_Backpack_Slot_Large_Empty.tga"
		hoverImage = "UI/Inventory/T_Backpack_Slot_Large_Hover.tga"
		imageBase = "UI/Inventory/T_Backpack_Slot_Large.tga"
	elseif TileConfig.Type == "Disabled" then
		emptyImage = ""
		hoverImage = ""
		imageBase = ""
	else
		for _, slotType in ipairs(slotTypes) do
			if TileConfig.Type == slotType.id and slotType.icon then
				emptyImage = slotType.icon
				-- hoverImage = slotType.icon
				imageBase = slotType.icon
			end
		end
	end

	local image = XImage:new({
		MinWidth = tile_size * k,
		MaxWidth = tile_size * k,
		MinHeight = tile_size * k,
		MaxHeight = tile_size * k,
		Id = "idBackImage",
		Image = emptyImage, -- curstom
		ImageColor = 4291018156
	}, self)
	if self.slot_image then
		local imgslot = XImage:new({
			MinWidth = tile_size * k,
			MaxWidth = tile_size * k,
			MinHeight = tile_size * k,
			MaxHeight = tile_size * k,
			Dock = "box",
			Id = "idEqSlotImage",
			ImageFit = "height"
		}, self)
		imgslot:SetImage(self.slot_image)
		image:SetImage(imageBase) -- curstom
		image:SetImageColor(RGB(255, 255, 255))
	end
	local rollover_image = XImage:new({
		MinWidth = tile_size_rollover * k,
		MaxWidth = tile_size_rollover * k,
		MinHeight = tile_size_rollover * k,
		MaxHeight = tile_size_rollover * k,
		Id = "idRollover",
		Image = hoverImage, -- curstom
		ImageColor = 0xFFc3bdac,
		Visible = false
	}, self)
	rollover_image:SetVisible(false)
end

local REV_Original_XInventorySlotSetslot_name = XInventorySlot.Setslot_name

function XInventorySlot:Setslot_name(slot_name)
	local context = self:GetContext()

	if not context then
		return
	end

	if context.session_id and (slot_name == "Inventory") then
		BuildInventory(self, context)
	else
		TileConfig.Type = "PocketU"
		TileConfig.Size = "Small"
		REV_Original_XInventorySlotSetslot_name(self, slot_name)
	end
end

local REV_Original_XInventoryTileOnDropEnter = XInventoryTile.OnDropEnter

function XInventoryTile:OnDropEnter(drag_win, pt, drag_source_win)
	InventoryOnDragEnterStash()
	local drag_item = InventoryDragItem
	local mouse_text
	local slot = self:GetInventorySlotCtrl()
	local _, dx, dy = slot:FindTile(pt)

	local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)

	if slot.slot_name == "Inventory" and slot.context.session_id then
		if not dx then
			mouse_text = Untranslated("Item does not fit here")
		else
			local slot_types = GetInventorySlots(slot:GetContext())
			if slot_types then
				local fits, reason = FitTileCheck(drag_item, slot_types, dx, dy, sdx, slot.context)
				if not fits then
					mouse_text = Untranslated(reason)
				else
					mouse_text = Untranslated("Drop item")
				end
			end
		end
		-- TODO: adding AP costs
		InventoryShowMouseText(true, mouse_text)
		HighlightDropSlot(self, true, pt, drag_win)
		HighlightAPCost(InventoryDragItem, true, self)
	else
		REV_Original_XInventoryTileOnDropEnter(self, drag_win, pt, drag_source_win)
	end
end

local REV_Original_XInventorySlotDragDropMoveItem = XInventorySlot.DragDrop_MoveItem

function XInventorySlot:DragDrop_MoveItem(pt, target, check_only)
	if not InventoryDragItem then
		return "no item being dragged"
	end

	if not target then
		return "not valid target"
	end

	if table.find({ "Inventory", "Handheld A", "Handheld B" }, target.slot_name) and target.context.session_id then
		local dest_slot = target.slot_name
		local _, dx, dy = target:FindTile(pt)

		if not dx then
			return "no target tile"
		end

		local dest_container = target:GetContext()
		local src_container = InventoryStartDragContext

		local under_item = dest_container:GetItemInSlot(target.slot_name, nil, dx, dy)

		local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)
		local item = InventoryDragItem

		if not IsReload(item, under_item) and not IsMedicineRefill(item, under_item) and not InventoryIsCombineTarget(item, under_item) then
			local max = g_Classes[item.class].MaxStacks

			if not IsEquipSlot(target.slot_name) then
				local slot_types = GetInventorySlots(target.context)

				if slot_types then
					local fits, reason = FitTileCheck(item, slot_types, dx, dy, sdx, target.context)
					if not fits then
						return reason
					else
						local slotType = slot_types[dx][dy]

						max = REV_GetSlotTypeSizeForItem(slotType, item) or max
					end
				end
			else
				if under_item and under_item.Amount and under_item.Amount > 0 and under_item.class == item.class and (item.Amount or 1) > 1 then
					return "Stack is full", "no change"
				end

				max = 1
			end

			if item:IsLargeItem() then
				dx = dx - sdx
				if IsEquipSlot(dest_slot) then
					dx = 1
				end
			end

			local apCosts = InventoryIsCombatMode(target.context) and
				GetAPCostAndUnit(item, src_container, self.slot_name, dest_container, target.slot_name) or 0

			-- Check if a swap is possible
			if (not src_container.session_id or src_container:UIHasAP(apCosts)) and
				under_item and
				under_item.class ~= item.class
			then
				local destSlotType = REV_GetItemSlotType(under_item)

				local sourceInDestMaxStacks = REV_GetSlotTypeSizeForItem(destSlotType, item)

				local sourceSlotType = REV_GetItemSlotType(item)

				local destInSourceMaxStacks = REV_GetSlotTypeSizeForItem(sourceSlotType, under_item)

				local sourceAmount = item.Amount == nil and 1 or item.Amount

				local destAmount = under_item.Amount == nil and 1 or under_item.Amount

				if sourceInDestMaxStacks < sourceAmount or destInSourceMaxStacks < destAmount then
					return "cannot swap"
				end
			end

			-- Create a new stack with 0 amout to trigger the stack merge
			if not under_item and (not src_container.session_id or src_container:UIHasAP(apCosts)) and (g_Classes[item.class].MaxStacks or 0) > 1 then
				local pos, reason = dest_container:AddItem(target.slot_name, PlaceInventoryItem(item.class), dx, dy)

				under_item = dest_container:GetItemInSlot(target.slot_name, nil, dx, dy)

				under_item.Amount = 0

				under_item.MaxStacks = max
			end
		end

		local src_slot_name = InventoryStartDragSlotName
		local use_alternative_swap_pos = not not (IsEquipSlot(dest_slot) and not IsEquipSlot(src_slot_name) and under_item)

		local args = {
			item = item,
			src_container = src_container,
			src_slot = src_slot_name,
			dest_container = dest_container,
			dest_slot = dest_slot,
			dest_x = dx,
			dest_y = dy,
			check_only = check_only,
			exec_locally = false,
			alternative_swap_pos = use_alternative_swap_pos
		}
		local r1, r2, sync_unit = MoveItem(args)
		if r1 or not check_only then
			PlayFXOnMoveItemResult(r1, item, dest_slot, sync_unit)
		end
		if not r1 and not check_only and (not r2 or r2 ~= "no change") then
			self:Gossip(item, src_container, target, ssx, ssy, dx, dy)
		end
		return r1, r2
	end

	return REV_Original_XInventorySlotDragDropMoveItem(self, pt, target, check_only)
end

function XInventorySlot:SpawnItemUI(item, left, top)
	local image = self.tiles[left][top]
	if not image then
		return
	end
	image:SetVisible(false)
	if item:IsLargeItem() then
		self.tiles[left + 1][top]:SetVisible(false)
	end
	local item_wnd = XTemplateSpawn("XInventoryItem", self, item)
	item_wnd.idItemPad:SetTransparency(self.image_transparency)
	item_wnd:SetPosition(left, top)
	if image.tileContext then
		item_wnd.idItemPad:SetBackground(REV_GetEquipSlotColor(image.tileContext))
	end

	if item_wnd.parent.parent.Id == "idSquadBag" then
		local bag = item_wnd.parent.parent

		local squadId = bag.context.squad_id

		if squadId and SquadIsInCombat(squadId) then
			item_wnd:SetEnabled(false)
			item_wnd.parent:SetEnabled(false)
			item_wnd.parent:SetHandleMouse(false)
			item_wnd.parent:SetChildrenHandleMouse(false)
		end
	end

	local slotTypes = g_SlotTypes

	local currentSlotTypeIndex = image.Type and table.find(slotTypes, "id", image.Type)

	if item_wnd.idimgTile and currentSlotTypeIndex and slotTypes[currentSlotTypeIndex].icon then
		item_wnd.idimgTile:SetImage(slotTypes[currentSlotTypeIndex].icon)
		item_wnd.idimgTile:SetVisible(true)
		-- item_wnd.idItemPad:SetImageColor(0x1EFFFFFF)
	end

	self.item_windows[item_wnd] = item
end

local REV_Original_XInventoryItemInit = XInventoryItem.Init

function XInventoryItem:Init()
	REV_Original_XInventoryItemInit(self)

	local item = self:GetContext()
	local w = item:IsLargeItem() and tile_size_rollover * 2 or tile_size_rollover

	local tileImage = XTemplateSpawn("XImage", self) -- currently for locked items on rollover
	tileImage:SetId("idimgTile")
	tileImage:SetUseClipBox(false)
	tileImage:SetClip(false)
	tileImage:SetHAlign("center")
	tileImage:SetVAlign("center")
	tileImage:SetHandleMouse(false)
	tileImage:SetVisible(false)
	tileImage:SetMinWidth(w)
	tileImage:SetMaxWidth(w)
	tileImage:SetMinHeight(tile_size_rollover)
	tileImage:SetMaxHeight(tile_size_rollover)
	tileImage:SetImageColor(RGBA(255, 255, 255, 10))
	tileImage:SetImage("UI/Inventory/padlock")

	if self.parent and self.parent.slot_name == "Inventory" and REV_IsItemFirstRow(item) then
		self:SetMargins(box(0, 20, 0, 0))
	end
end

local REV_Original_XInventorySlotWndStartDrag = XInventorySlot.ItemWndStartDrag

function XInventorySlot:ItemWndStartDrag(wnd_found, item)
	if wnd_found.idimgTile then
		wnd_found.idimgTile:SetVisible(false)
	end

	wnd_found:SetMargins(box(0, 0, 0, 0))

	REV_Original_XInventorySlotWndStartDrag(self, wnd_found, item)
end

local REV_Original_BrowseInventorySlotGetPrevEquipItem = BrowseInventorySlot.GetPrevEquipItem

function BrowseInventorySlot:GetPrevEquipItem(item, B_slot_first)
	if IsKindOf(item, "LBE") or IsKindOf(item, "Backpack") or IsKindOf(item, "NVG") or IsKindOf(item, "FaceItem") then
		local unit = GetInventoryUnit()

		if not unit then return end

		local prev_item = unit:GetItemInSlot(item.Slot)
		local slot = item.Slot

		local slot_pos = point_pack(1, 1)

		return prev_item, slot, slot_pos
	else
		return REV_Original_BrowseInventorySlotGetPrevEquipItem(self, item, B_slot_first)
	end
end