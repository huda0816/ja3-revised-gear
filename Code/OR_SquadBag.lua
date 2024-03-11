OnMsg.CombatStart = function()
	local inventorySlot = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', 'idInventorySlot', 'all')

	if inventorySlot then
		for i, slot in ipairs(inventorySlot) do
			if slot and slot.ancestors and slot.ancestors[1].Id == "idSquadBag" then
				slot.element.enabled = false
				slot.element.handleMouse = false
			end
		end
	end
end