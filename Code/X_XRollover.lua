GameVar("gv_REV_ShowRollover", true)

if FirstLoad then
	g_REV_InventoryOpen = false
end

function OnMsg.CloseInventorySubDialog()
	g_REV_InventoryOpen = true
end

function OnMsg.OpenInventorySubDialog()
	g_REV_InventoryOpen = true
end

local REV_Original_XCreateRolloverWindow = XCreateRolloverWindow

function XCreateRolloverWindow(control, gamepad, immediate, context)

	if not gv_REV_ShowRollover and g_REV_InventoryOpen then
		return
	end

	return REV_Original_XCreateRolloverWindow(control, gamepad, immediate, context)
end