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
end
