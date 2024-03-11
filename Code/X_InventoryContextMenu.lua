function OnMsg.DataLoaded()
	local contextMenuActions = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates.InventoryContextMenu, 'Id',
		'idPopupWindow')

	if contextMenuActions and contextMenuActions.element then
		table.insert(contextMenuActions.element, PlaceObj('XTemplateTemplate', {
			'comment', "unload",
			'__condition', function(parent, context)
			return context and IsKindOf(context.item, "PersonalStorage")
		end,
			'__template', "ContextMenuButton",
			'Id', "unload",
			'FocusOrder', point(1, 2),
			'RelativeFocusOrder', "new-line",
			'OnContextUpdate', function(self, context, ...)
			self:SetEnabled(REV_IsUnloadEnabled(context))
		end,
			'OnPress', function(self, gamepad)
			local context = self.context
			REV_UnloadItems(context)
		end,
			'Text', T(7375332244470816, --[[XTemplate InventoryContextMenu Text]] "UNLOAD"),
		}))
	end
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
