function OnMsg.DataLoaded()
	local onDialogModeChange = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'name', 'OnDialogModeChange(self, mode, dialog)')

	if onDialogModeChange and onDialogModeChange.element then
		onDialogModeChange.element.func = function(self, mode, dialog)
			if dialog == self then
				if gv_SatelliteView then
					self.idCenterHeading:SetText(mode == "loot" and
					T { 288565331426, "SECTOR <SectorId(sector)> STASH", sector = dialog.context.container.sector_id or gv_CurrentSectorId } or
					T(1974181345670816, "Squad Supplies " .. gv_SquadBag:GetSquadBagWeight(gv_SquadBag) .. " Kg"))
				else
					self.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or
					T(1974181345670816, "Squad Supplies " .. gv_SquadBag:GetSquadBagWeight(gv_SquadBag) .. " Kg"))
				end
				return
			end

			if mode ~= "inventory" and dialog ~= self then
				Msg("CloseInventorySubDialog", "inventory")
				PlayFX("InventoryClose")
				self:OnEscape()
				self:Close()
			end
		end
	end

	local idCenter = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', "idCenter")

	if idCenter and idCenter.element then
		idCenter.element.OnContextUpdate = function(self, context, ...)
			if self.RespawnOnContext then
				if self.window_state == "open" then
					self:RespawnContent()
				end
			else
				local respawn_value = self:RespawnExpression(context)
				if rawget(self, "respawn_value") ~= respawn_value then
					self.respawn_value = respawn_value
					if self.window_state == "open" then
						self:RespawnContent()
					end
				end
			end
			local node = self:ResolveId("node")
			local mode = GetDialog(self).Mode
			if gv_SatelliteView then
				node.idCenterHeading:SetText(mode == "loot" and
				T { 288565331426, "SECTOR <SectorId(sector)> STASH", sector = context.container.sector_id or gv_CurrentSectorId } or
				T(1974181345670816, "Squad Supplies" .. gv_SquadBag:GetSquadBagWeight() .. " Kg"))
			else
				node.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or
				T(1974181345670816, "Squad Supplies" .. gv_SquadBag:GetSquadBagWeight() .. " Kg"))
			end
		end
	end

	local idName = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', "idName", "all")

	if idName and idName[3] and idName[3].element then
		idName[3].element.OnLayoutComplete = function (self)
			local unit = self.context
			self:SetText(T(3269654860290817, "<Nick> EQUIPMENT <GetCurrentWeight()>/<GetMaxWeight()> Kg", unit))
		end
	end

	if idName and idName[4] and idName[4].element then
		idName[4].element.OnLayoutComplete = function (self)
			local bag = self.context
			self:SetText(T(7675803685470817, "Squad Supplies <GetSquadBagWeight()> Kg", bag))
		end
	end
end
