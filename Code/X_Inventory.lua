function OnMsg.DataLoaded()
	local onDialogModeChange = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'name', 'OnDialogModeChange(self, mode, dialog)')

	if onDialogModeChange and onDialogModeChange.element then
		onDialogModeChange.element.func = function(self, mode, dialog)
			if dialog == self then
				if gv_SatelliteView then
					self.idCenterHeading:SetText(mode == "loot" and
						T { 288565331426, "SECTOR <SectorId(sector)> STASH", sector = dialog.context.container.sector_id or gv_CurrentSectorId } or
						T(1974181345670816, "Squad Supplies " .. REV_GetSquadBagWeightInKg() .. " Kg"))
				else
					self.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or
						T(1974181345670816, "Squad Supplies " .. REV_GetSquadBagWeightInKg() .. " Kg"))
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
					T(1974181345670816, "Squad Supplies " .. REV_GetSquadBagWeightInKg() .. " Kg"))
			else
				node.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or
					T(1974181345670816, "Squad Supplies " .. REV_GetSquadBagWeightInKg() .. " Kg"))
			end
		end
	end

	local idName = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', "idName", "all")

	if idName and idName[3] and idName[3].element then
		idName[3].element.OnLayoutComplete = function(self)
			local unit = self.context
			self:SetText(T(3269654860290817, "<Nick> EQUIPMENT <GetCurrentWeightInKg()>/<GetMaxWeightInKg()> Kg", unit))
		end
	end

	if idName and idName[4] and idName[4].element then
		idName[4].element.OnLayoutComplete = function(self)
			local bag = self.context
			self:SetText(T(7675803685470817, "Squad Supplies <GetSquadBagWeightInKg()> Kg", bag))
		end
	end




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

	local selectAll = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates.Inventory, "ActionId", "SelectAll")

	if selectAll and selectAll.element then
		selectAll.element.ActionState = function(self, context)
			return "hidden"
		end
	end


	local inventoryDialog = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["Inventory"], "Id",
		"idDlgContent")

	if inventoryDialog and inventoryDialog.element then
		inventoryDialog.element[3].Dock = "right"
		inventoryDialog.element[3].Margins = box(0, 18, 40, 0)
	end

	local inventorySlot = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'slot_name', 'Inventory', 'all')

	if inventorySlot then
		for i, slot in ipairs(inventorySlot) do
			if slot and slot.ancestors then
				slot.ancestors[1].Margins = slot.ancestors[1].Margins or box(0, 16, 0, 0)
			end

			if slot and slot.element then
				slot.element.UniformRowHeight = false

				table.insert(slot.ancestors[1], slot.indices[1], PlaceObj('XTemplateWindow', {
					'__condition', function(parent, context) return context.session_id and
					next(REV_GetEquippedSlots(context, true)) end,
					'Id', "idInventoryLegend",
					"Margins",
					box(26, 4, 0, 16),
					'IdNode', true,
					'LayoutMethod', "HList",
					'LayoutHSpacing', 12,
				}, {
					PlaceObj("XTemplateForEach", {
						"__context",
						function(parent, context, item, i, n)
							return item
						end,
						"array",
						function(parent, context)
							return REV_GetEquippedSlots(context, true)
						end,
						"run_after",
						function(child, context, item, i, n, last)
							child[1]:SetBackground(item.color)
							child[2]:SetText(item.displayName)
						end
					}, {
						PlaceObj('XTemplateWindow', {
							'LayoutMethod', "HList",
							'LayoutHSpacing', 4,
							"HandleMouse",
							false,
						}, {
							PlaceObj("XTemplateWindow", {
								"HAlign",
								"left",
								"VAlign",
								"center",
								"MinWidth",
								18,
								"MaxWidth",
								18,
								"MinHeight",
								18,
								"MaxHeight",
								18,
							}),
							PlaceObj("XTemplateWindow", {
								"__class",
								"XText",
								"HAlign",
								"left",
								"VAlign",
								"top",
								"TextStyle",
								"REVLBELegendText",
							})
						})
					})
				}))
			end
		end
	end

	local equipSlots = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', 'idEquipSlots')


	if equipSlots and equipSlots.element then
		table.remove(equipSlots.ancestors[1], equipSlots.indices[1])
		table.insert(equipSlots.ancestors[1], equipSlots.indices[1],
			PlaceObj('XTemplateWindow', {
				'__class', "XContentTemplate",
				'Id', "idEquipSlots",
				'IdNode', false,
				'LayoutMethod', "VList",
				'LayoutVSpacing', 10,
				'RespawnOnContext', false,
			}, {
				PlaceObj('XTemplateWindow', {
					'comment', "armor",
					'HAlign', "center",
					'LayoutMethod', "VList",
				}, {
					PlaceObj('XTemplateWindow', {
						'comment', "armor",
						'HAlign', "right",
						'LayoutMethod', "HList",
					}, {
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idHead",
							'ScaleModifier', point(900, 900),
							'MouseCursor', "UI/Cursors/Pda_Cursor.tga",
							'slot_name', "Head",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idNVG",
							'ScaleModifier', point(900, 900),
							'MouseCursor', "UI/Cursors/Pda_Cursor.tga",
							'slot_name', "NVG",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						})
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "armor",
						'HAlign', "center",
						'LayoutMethod', "HList",
					}, {
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idFace",
							'ScaleModifier', point(900, 900),
							'MouseCursor', "UI/Cursors/Pda_Cursor.tga",
							'slot_name', "FaceItem",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "armor",
						'HAlign', "left",
						'LayoutMethod', "HList",
					}, {
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idBackpack",
							'ScaleModifier', point(900, 900),
							'slot_name', "Backpack",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idTorso",
							'ScaleModifier', point(900, 900),
							'slot_name', "Torso",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idLBE",
							'ScaleModifier', point(900, 900),
							'slot_name', "LBE",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "armor",
						'HAlign', "center",
						'LayoutMethod', "HList",
					}, {
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idLHolster",
							'ScaleModifier', point(900, 900),
							'slot_name', "LHolster",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idLegs",
							'ScaleModifier', point(900, 900),
							'slot_name', "Legs",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "EquipInventorySlot",
							'Id', "idRHolster",
							'ScaleModifier', point(900, 900),
							'slot_name', "RHolster",
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "Open",
								'func', function(self, ...)
								EquipInventorySlot.Open(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = true
							end,
							}),
							PlaceObj('XTemplateFunc', {
								'name', "OnDelete",
								'func', function(self, ...)
								local dlg = GetDialog(self)
								dlg.slots[self] = nil
							end,
							}),
						}),
					}),
				}),
				PlaceObj('XTemplateWindow', {
					'comment', "weapons",
					'LayoutMethod', "VList",
				}, {
					PlaceObj('XTemplateWindow', nil, {
						PlaceObj('XTemplateWindow', {
							'Id', "idWeaponAEx",
							'Margins', box(-30, 0, -30, 0),
						}, {
							PlaceObj('XTemplateWindow', {
								'__class', "EquipInventorySlot",
								'Id', "idWeaponA",
								'HAlign', "center",
								'VAlign', "center",
								'ScaleModifier', point(900, 900),
								'slot_name', "Handheld A",
							}, {
								PlaceObj('XTemplateFunc', {
									'name', "Open",
									'func', function(self, ...)
									EquipInventorySlot.Open(self, ...)
									local dlg = GetDialog(self)
									dlg.slots[self] = true
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "OnDelete",
									'func', function(self, ...)
									local dlg = GetDialog(self)
									dlg.slots[self] = nil
								end,
								}),
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "XToggleButton",
							'RolloverTemplate', "ChangeActiveWeaponAPRollover",
							'RolloverTitle', T(480351423675, --[[XTemplate Inventory RolloverTitle]] "AP"),
							'Id', "idWeapons1",
							'Margins', box(0, 5, 39, 0),
							'HAlign', "right",
							'VAlign', "top",
							'OnContextUpdate', function(self, context, ...)
							XToggleButton.OnContextUpdate(self, context, ...)
							local unit = GetDialog(self).selected_unit
							self:SetVisible(unit:CanBeControlled())
						end,
							'OnPress', function(self, gamepad)
							if self.Toggled then
								return
							end
							local dlg = GetDialog(self)
							local action
							if dlg.compare_mode then
								action = dlg:ActionById("Primary")
							else
								action = dlg:ActionById("CurrentWeapon1")
							end
							action:OnAction(dlg)
							--self:SetToggled(not self.Toggled)
							--self:SetIconColumn(self.Toggled and 2 or 1)
							XTextButton.OnPress(self)
						end,
							'Image', "UI/Inventory/loadout_01",
							'Columns', 2,
							'Icon', "UI/Inventory/loadout_01",
							'IconColumns', 2,
							'ColumnsUse', "abbba",
						}),
					}),
					PlaceObj('XTemplateWindow', nil, {
						PlaceObj('XTemplateWindow', {
							'Id', "idWeaponBEx",
							'Margins', box(-30, 0, -30, 0),
						}, {
							PlaceObj('XTemplateWindow', {
								'__class', "EquipInventorySlot",
								'Id', "idWeaponB",
								'HAlign', "center",
								'VAlign', "center",
								'ScaleModifier', point(900, 900),
								'slot_name', "Handheld B",
							}, {
								PlaceObj('XTemplateFunc', {
									'name', "Open",
									'func', function(self, ...)
									EquipInventorySlot.Open(self, ...)
									local dlg = GetDialog(self)
									dlg.slots[self] = true
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "OnDelete",
									'func', function(self, ...)
									local dlg = GetDialog(self)
									dlg.slots[self] = nil
								end,
								}),
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "XToggleButton",
							'RolloverTemplate', "ChangeActiveWeaponAPRollover",
							'RolloverTitle', T(362170312988, --[[XTemplate Inventory RolloverTitle]] "AP"),
							'Id', "idWeapons2",
							'Margins', box(0, 5, 39, 0),
							'HAlign', "right",
							'VAlign', "top",
							'OnContextUpdate', function(self, context, ...)
							XToggleButton.OnContextUpdate(self, context, ...)
							local unit = GetDialog(self).selected_unit
							self:SetVisible(unit:CanBeControlled())
						end,
							'OnPress', function(self, gamepad)
							if self.Toggled then
								return
							end
							local dlg = GetDialog(self)
							local action
							if dlg.compare_mode then
								action = dlg:ActionById("Secondary")
							else
								action = dlg:ActionById("CurrentWeapon2")
							end
							action:OnAction(dlg)
							--self:SetToggled(not self.Toggled)
							--self:SetIconColumn(self.Toggled and 2 or 1)
							XTextButton.OnPress(self)
						end,
							'Image', "UI/Inventory/loadout_02",
							'Columns', 2,
							'Icon', "UI/Inventory/loadout_02",
							'IconColumns', 2,
							'ColumnsUse', "abbba",
						}),
					}),
				}),
			})
		)
	end
end
