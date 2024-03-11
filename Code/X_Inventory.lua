function OnMsg.DataLoaded()

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
					'__condition', function(parent, context) return context.session_id and next(REV_GetEquippedSlots(context, true)) end,
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
