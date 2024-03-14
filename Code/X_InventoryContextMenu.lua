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
