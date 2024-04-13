function OnMsg.DataLoaded()
	local squadList = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.SquadsAndMercs, 'Id', 'idTitle')

	if squadList and squadList.element then
		squadList.element.LayoutMethod = "HList"
		squadList.element.Margins = box(-10, -10, 0, 0)
		squadList.element[1].HAlign = "left"
		squadList.element[1].VAlign = "center"
		squadList.element[2].Dock = "left"
	end

	local x_fit = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates.SquadsAndMercs, "__class",
		"XFitContent")

	if x_fit then
		x_fit.element.HandleMouse = false
	end

	local selectedFunc = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates.SquadsAndMercs, "name",
		"SelectUnit(self)")

	if selectedFunc and selectedFunc.element then
		local OriginalFunc = selectedFunc.element.func

		selectedFunc.element.func = function(self)
			local myUnit = self.unit
			if not IsCoOpGame and InventoryDragItems or InventoryDragItem then
				if InventoryIsValidGiveDistance(InventoryStartDragContext, myUnit) then
					local args = {
						src_container = InventoryStartDragContext,
						src_slot = InventoryStartDragSlotName,
						dest_container = myUnit,
						dest_slot = GetContainerInventorySlotName(myUnit)
					}
					if InventoryDragItems then
						args.multi_items = true
						for i, item in ipairs(InventoryDragItems) do
							args.item          = item
							args.no_ui_respawn = i ~= #InventoryDragItems
							local r1, r2       = MoveItem(args) --this will merge stacks and move, if you want only move use amount = item.Amount				
							--		print(item.class, r1, r2)
						end
						InventoryDeselectMultiItems()
						PlayFX("GiveItem", "start", GetInventoryItemDragDropFXActor(item))
					elseif InventoryDragItem then
						--give drag item
						args.item = InventoryDragItem
						MoveItem(args)
					end
					--CancelDrag(dlg)
					return
				end
			end

			OriginalFunc(self)
		end
	end
end
