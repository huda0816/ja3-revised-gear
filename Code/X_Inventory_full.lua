function OnMsg.DataLoaded()
	PlaceObj('XTemplate', {
		__is_kind_of = "XDialog",
		group = "Zulu",
		id = "Inventory",
		PlaceObj('XTemplateWindow', {
			'__context', function(parent, context) return context or { unit = SelectedObj } end,
			'__class', "XDialog",
			'Id', "idInventory",
			'ContextUpdateOnOpen', true,
			'OnContextUpdate', function(self, context, ...)
			self:CloseCompare()
			self.selected_unit = context.unit
			self.idRight:SetContext(context, true)
			self.idLeft:SetContext(context, true)
			if self.selected_unit then
				self.idUnitInfo:SetContext(self.selected_unit, true)
				local left = self:ResolveId("idPartyContainer")
				local squad_list = left.idParty and left.idParty.idContainer or empty_table
				for _, button in ipairs(squad_list) do
					local bctx = button:GetContext()
					local is_selected = bctx and bctx.session_id == self.selected_unit.session_id
					button:SetSelected(is_selected)
				end
			end
			self:CompareWeaponSetUI()
			InventoryUIRespawn()
			--self.idCenter:SetContext(context.container,true)
		end,
			'InitialMode', "ammo",
			'InternalModes', "loot, ammo",
			'FocusOnOpen', "child",
		}, {
			PlaceObj('XTemplateWindow', {
				'__class', "XCameraLockLayer",
				'lock_id', "Inventory",
			}),
			PlaceObj('XTemplateLayer', {
				'__condition', function(parent, context) return not netInGame and not gv_SatelliteView end,
				'layer', "XPauseLayer",
				'PauseReason', "InventoryPauseSP",
			}),
			PlaceObj('XTemplateFunc', {
				'name', "Open",
				'func', function(self, ...)
				self.spawned_popup = false
				self.item_wnd = false

				if gv_SatelliteView then
					SetCampaignSpeed(0, GetUICampaignPauseReason("Inventory"))
				end

				local context = self:GetContext()
				self.selected_unit = context.unit
				self.selected_items = {}
				self.selected_tab = "all"

				self.slots = {}
				self.compare_wnd = {}
				self.compare_mode = false
				self.compare_mode_weaponslot = context.unit.current_weapon == "Handheld A" and 1 or 2

				--self.idInventoryMouseText:SetVisible(false)
				local retVal = XDialog.Open(self, ...)

				self.idPartyContainer:SelectSquad(gv_Squads[self.selected_unit.Squad])
				local container_mode = context.container and "loot" or "ammo"
				if InventoryDisabled(context) then
					container_mode = "ammo"
				end
				if gv_SatelliteView and context.unit and (context.unit.Operation == "Arriving" or context.unit.Operation == "Traveling") then
					container_mode = "ammo"
				end

				self:SetMode(container_mode)
				local ctrl_right_area = self.idScrollArea
				for _, wnd in ipairs(ctrl_right_area) do
					local wnd_context = wnd:GetContext()
					local wnd_id = wnd_context and wnd_context.session_id
					if wnd and wnd_id then
						if context.unit and wnd_id == context.unit.session_id then
							ctrl_right_area:ScrollIntoView(wnd)
							wnd.idName:SetHightlighted(true)
							break
						end
					end
				end
				self:CompareWeaponSetUI()
				return retVal
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnDelete(self)",
				'func', function(self)
				if gv_SatelliteView then
					SetCampaignSpeed(nil, GetUICampaignPauseReason("Inventory"))
				end
				local context = self.context
				if context and IsKindOf(context.container, "SectorStash") then
					InventoryUIResetSectorStash()
					NetSyncEvent("SectorStashOpenedBy", false)
				end
				if gv_SquadBag then
					InventoryUIResetSquadBag()
				end
				local splitdlg = GetDialog("SplitStackItem")
				if splitdlg then
					splitdlg:Close()
				end
				self:CloseCompare()
				self:OnEscape()
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "Close",
				'func', function(self, ...)
				self:OnDelete()
				return XDialog.Close(self, ...)
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "GetSlotByName(self,slot_name, slot_context)",
				'func', function(self, slot_name, slot_context)
				local slots = self:GetSlotsArray()
				for slot in pairs(slots) do
					if slot.slot_name == slot_name and (not slot_context or slot_context == slot:GetContext()) then
						return slot
					end
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnEscape",
				'func', function(self, ...)
				local slots = self:GetSlotsArray()
				for slot in pairs(slots) do
					if slot:CancelDragging() then
						return true
					end
				end
				if self.spawned_popup and self.spawned_popup.window_state ~= "destroying" then
					local slot = next(slots)
					slot:ClosePopup()
					return true
				end
				if InventoryIsCompareMode(self) then
					self:CloseCompare()
					self.compare_mode = false
					self:ActionsUpdated()
					return true
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "CloseCompare(self, up)",
				'func', function(self, up)
				local cmp_item = self.compare_wnd and self.compare_wnd.item
				if cmp_item then
					HighlightCompareSlots(cmp_item, self.compare_wnd.other, false)
					local mode = self.compare_mode
					self.compare_mode = false
					SetInventoryHighlights(cmp_item, up)
					self.compare_mode = mode
				end
				if next(self.compare_wnd) then
					for _, wnd in ipairs(self.compare_wnd) do
						wnd:delete()
					end
					self.compare_wnd = {}
					XInventoryItem.RolloverTemplate = "RolloverInventory"
					return
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OpenCompare(self, item_wnd, item)",
				'func', function(self, item_wnd, item)
				if next(self.compare_wnd) then
					return false
				end
				if not item_wnd or not item then
					local pt = terminal:GetMousePos()
					local win = terminal.desktop:GetMouseTarget(pt)
					while win and not IsKindOf(win, "XInventorySlot") do
						win = win:GetParent()
					end
					if not win then return false end
					item_wnd, item = win:FindItemWnd(pt)
				end
				self.compare_wnd.item = item
				if item then
					self.compare_mode = false
					SetInventoryHighlights(item, false)
					self.compare_mode = true
					--HighlightEquipSlots(item, true)
				end

				local container = item_wnd and item_wnd.parent and item_wnd.parent.context
				local no_compare = IsKindOfClasses(container, "SectorStash", "ItemDropContainer")
				if no_compare then
					return false
				end
				local equip_slots = GetSlotsToEquipItem(item)
				if item and next(equip_slots) then
					local dlg = GetMercInventoryDlg()
					local unit = GetInventoryUnit()
					local list = XTemplateSpawn("XWindow", dlg.idCompare)
					list:SetHAlign("right")
					list:SetVAlign("top")
					list:SetLayoutMethod("HList")
					list:SetLayoutVSpacing(10)

					local other = {}
					local is_weapon = item:IsWeapon()
					local is_grenade = IsKindOf(item, "Grenade")
					self.compare_mode_weaponslot = self.compare_mode_weaponslot or 1
					if is_weapon or #equip_slots > 1 then
						equip_slots = self.compare_mode_weaponslot == 1 and { "Handheld A" } or { "Handheld B" }
					end
					for idx, slot_name in ipairs(equip_slots) do
						unit:ForEachItemInSlot(slot_name,
							function(itm, slot_name, left, top, self, item, list, other, is_weapon, is_grenade)
								if itm and item ~= itm then
									local is_weapon_eq = itm:IsWeapon()
									local is_grenade_eq = IsKindOf(itm, "Grenade")
									if (is_weapon and is_weapon_eq) or
										(not is_weapon and not is_weapon_eq and
											(InventoryItemDefs[item.class].group == InventoryItemDefs[itm.class].group or
												is_grenade_eq and is_grenade)) then
										local context = SubContext(itm)
										context.control = self:GetSlotByName(slot_name)
										local rollover_slot = XTemplateSpawn("RolloverInventoryCompare", list, context)
										rollover_slot:SetMargins(box(10, 0, 0, 0))
										--rollover_slot:SetDock("right")
										table.insert(other, 1, itm)
									end
								end
							end, self, item, list, other, is_weapon, is_grenade)
					end

					local context = SubContext(item)
					context.control = item_wnd
					context.other = other
					if #other <= 0 then
						XInventoryItem.RolloverTemplate = "RolloverInventory"
						list:delete()
						return false
					end
					if RolloverWin then
						RolloverWin:Close()
						RolloverWin = false
						HighlightCompareSlots(item, other, true)
					end
					self.compare_wnd[#self.compare_wnd + 1] = list
					self.compare_wnd.other = other
					local rollover_item = XTemplateSpawn("RolloverInventoryCompare", list, context)
					rollover_item:SetMargins(box(10, 0, 0, 0))
					--rollover_item:SetDock("right")

					list:Open()
					XInventoryItem.RolloverTemplate = ""
					return true
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnKillFocus(self)",
				'func', function(self)
				local slots = self:GetSlotsArray()
				for slot in pairs(slots) do
					if slot:CancelDragging() then
						break
					end
				end
				XDialog.OnKillFocus(self)
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "GetSlotsArray(self)",
				'func', function(self)
				return self.slots or empty_table
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnDialogModeChange(self, mode, dialog)",
				'func', function(self, mode, dialog)
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
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnXButtonDown(self, button, controller_id)",
				'func', function(self, button, controller_id)
				local res = XDialog.OnXButtonDown(self, button, controller_id)
				if res == "break" then
					return "break"
				end
				local dlg = GetDialog("FullscreenGameDialogs")
				local pt = GamepadMouseGetPos()
				-- compare mode
				if XInput.IsCtrlButtonPressed(controller_id, "RightTrigger") then
					if button == "ButtonY" then
						if self.compare_mode then
							self:CloseCompare()
							XInventoryItem.RolloverTemplate = "RolloverInventory"
							self.compare_mode               = not self.compare_mode
						else
							self.compare_mode = not self.compare_mode
							self:OpenCompare()
						end

						self:ActionsUpdated()
						return "break"
					end
				end

				-- also close compare mode with B
				if button == "ButtonB" and self.compare_mode then
					self:CloseCompare()
					XInventoryItem.RolloverTemplate = "RolloverInventory"
					self.compare_mode               = not self.compare_mode
					self:ActionsUpdated()
					return "break"
				end

				-- center on units backpack
				if button == "RightThumbClick" then
					local pos, slot
					for ctrl, val in pairs(self.slots) do
						local ctx = ctrl:GetContext()
						if IsKindOf(ctrl, "BrowseInventorySlot") and ctx and ctx.session_id and ctx.session_id == self.selected_unit.session_id then
							slot = ctrl
						end
					end
					pos = slot and slot.box:min() or self.slots[1]:GetPos()
					if pos then
						terminal.SetMousePos(pos)
					end
					return "break"
				end

				--LeftTrigger
				if XInput.IsCtrlButtonPressed(controller_id, "LeftTrigger") then
					-- open modify weapon
					local pt = GamepadMouseGetPos()
					local win = terminal.desktop:GetMouseTarget(pt)
					while win and not IsKindOf(win, "XInventorySlot") do
						win = win:GetParent()
					end
					local owner, item
					if win then
						local _, left, top = win:FindTile(pt)
						owner = win.context
						item = owner:GetItemInSlot(win.slot_name, false, left, top)
					end
					if button == "ButtonA" then
						local win = terminal.desktop:GetMouseTarget(pt)
						while win and not IsKindOf(win, "XInventorySlot") do
							win = win:GetParent()
						end
						if not win then return "break" end
						local wnd_found, item = win:FindItemWnd(pt)
						if InventoryToggleItemMultiselect(self, wnd_found, item) then
							return "break"
						end
						if self and (not item or not self.selected_items[item]) then
							self:DeselectMultiItems()
						end

						return "break"
					end
					if button == "DPadRight" or button == "Right" then
						-- modify weapon
						if item and item:IsWeapon() and IsKindOf(item, "Firearm") then
							if not IsInMultiplayerGame() or not g_Combat then
								OpenDialog("ModifyWeaponDlg", false,
									{ weapon = item, slot = owner:GetItemPackedPos(item), owner = owner })
							end
							return "break"
						end
					elseif button == "DPadUp" or button == "Up" then
						-- fast equip
						if win and not IsEquipSlot(win.slot_name) then
							if InventoryDragItem then
								self:CancelDragging()
							end
							win:EquipItem(item)
							return "break"
						end
					elseif button == "DPadDown" or button == "Down" then
						if IsEquipSlot(win.slot_name) then
							-- unequip
							win:UnEquipItem(item)
							return "break"
						elseif owner.Operation ~= "Arriving" and
							not (IsKindOf(owner, "Unit") and owner:IsDead()) and not IsKindOf(owner, "ItemContainer") then
							-- drop item
							win:DropItem(item)
							return "break"
						end
					elseif button == "DPadLeft" or button == "Left" then
						local ammo, weapon
						local unit = GetInventoryUnit()
						if IsKindOf(item, "Ammo") then
							ammo = item
							unit:ForEachItemInSlot(unit.current_weapon, function(witem, slot, l, t, caliber)
								if witem.Caliber == caliber then
									weapon = witem
									return "break"
								end
							end, ammo.Caliber)
						elseif item:IsWeapon() then
							weapon = item
							local ammos, containers, slots = owner:GetAvailableAmmos(weapon, nil, "unique")
							local can, err = IsWeaponAvailableForReload(weapon, ammos)
							if can and err ~= AttackDisableReasons.FullClipHaveOther then
								local ammo = weapon.ammo
								if ammo then
									local haveMoreFromCurrent = table.find(ammos, "class", ammo.class)
									ammo = haveMoreFromCurrent and ammos[haveMoreFromCurrent] or ammos[1]
								else
									-- Put in first ammo if no ammo loaded
									ammo = ammos[1]
								end
							end
						end
						-- reload
						if weapon and ammo then
							local context = self:ResolveId("node"):GetContext()
							local container = context.context

							local actionArgs = { target = ammo.class, pos = pos, item_id = weapon.id }

							local ap = CombatActions.Reload:GetAPCost(unit, actionArgs)
							ap = InventoryIsCombatMode(unit) and ap or 0
							assert(IsKindOfClasses(unit, "Unit", "UnitData"))
							if IsKindOf(unit, "Unit") then
								NetStartCombatAction("Reload", unit, ap, actionArgs)
							elseif IsKindOf(unit, "UnitData") then
								NetSyncEvent("InvetoryAction_RealoadWeapon", unit.session_id, ap, actionArgs, ammo.class)
							end


							ObjModified(unit)
							InventoryUpdate(unit)
							--PlayFX("WeaponReload", "start", weapon.class, weapon.object_class)
						end
					end
				end

				-- exit
				--[[				if button=="ButtonB" then					
					if not self:OnEscape() then
						if CurrentTutorialPopup and CurrentTutorialPopup.window_state ~= "destroying" then
							local ctx = CurrentTutorialPopup:ResolveId("idText"):GetContext()
							TutorialDismissHint(ctx)
							CloseCurrentTutorialPopup()
						else
							dlg:SetMode("empty")
							dlg:Close()
						end
						return "break"
					end
				end
				]]
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "OnSquadSelected(self, selected_squad)",
				'func', function(self, selected_squad)
				if selected_squad then
					local ctx = self:GetContext()
					local firstUnitId = selected_squad.units[1]
					local clone
					local fromPDA = GetDialog("PDADialog") or gv_SatelliteView
					local ctx_unit = fromPDA and gv_UnitData[firstUnitId] or g_Units[firstUnitId]
					ctx.unit = ctx_unit
					local sector_id = ctx.unit and gv_Squads[ctx.unit.Squad].CurrentSector
					if gv_SatelliteView and gv_SectorInventory and ctx.unit then
						if sector_id then
							gv_SectorInventory:Clear()
							gv_SectorInventory:SetSectorId(sector_id)
							ctx.container = gv_SectorInventory
						else
							ctx.container = false
						end
					end
					if clone then
						ObjModified(clone)
					end
					ObjModified(ctx_unit)
					local prep_context = PrepareInventoryContext(ctx.unit, ctx.container)
					ctx.unit = prep_context.unit
					ctx.container = prep_context.container
					self:SetContext(ctx)
					self:OnContextUpdate(ctx)
					InventoryUIResetSquadBag()
					--					InventoryUIResetSectorStash(sector_id)
					InventoryUIRespawn()

					if IsKindOf(ctx_unit, "Unit") then
						if ctx_unit:CanBeControlled() then
							SelectObj(ctx_unit)
						end
						ObjModified("hud_squads")
					elseif g_SatelliteUI then
						g_SatelliteUI:SelectSquad(selected_squad)
					end
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "TakeAllState(self)",
				'func', function(self)
				if self.selected_tab ~= "all" then
					return "hidden"
				end
				local context = self:GetContext()
				local container = context and context.container
				if not container or InventoryIsCombatMode() then return "hidden" end

				if not InventoryIsValidTargetForUnit(container) then
					return "hidden"
				end

				local containers = InventoryGetLootContainers(container) or empty_table
				local hasItem = false
				for _, cont in ipairs(containers) do
					local container_slot_name = GetContainerInventorySlotName(cont)
					if cont:GetItemInSlot(container_slot_name) then
						hasItem = true
						break
					end
				end
				if not hasItem then return "hidden" end
				if InventoryDisabled(context) then return "disabled" end

				--check for free space
				local unit = context.unit
				if not unit then return end
				local units = { unit }
				local left = self:ResolveId("idPartyContainer")
				local list = left.idParty and left.idParty.idContainer or empty_table
				for _, ctrl in ipairs(list) do
					local data = ctrl:GetContext()
					if data then
						table.insert_unique(units, data)
					end
				end
				local free_space = false
				for _, container in ipairs(containers) do
					local container_slot_name = GetContainerInventorySlotName(container)
					local result = container:ForEachItemInSlot(container_slot_name, false,
						function(item, slot_name, src_left, src_top, units)
							if IsKindOf(item, "SquadBagItem") then
								return "break"
							end
							local is_stack = IsKindOf(item, "InventoryStack")
							for _, unit in ipairs(units) do
								local pos, reason = unit:CanAddItem("Inventory", item)
								if pos then
									return "break"
								elseif is_stack then
									local res = unit:ForEachItemInSlot("Inventory", item.class,
										function(itm, slot_n, l, t)
											if itm.Amount + item.Amount <= itm.MaxStacks then
												return "break"
											end
										end)
									if res == "break" then
										return "break"
									end
								end
							end
						end, units)
					if result == "break" then
						free_space = true
						break
					end
				end
				if not free_space then return "disabled", T(545718357333, "Inventory is full") end
				return "enabled"
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "TakeAllStateWarning(self,ctrl)",
				'func', function(self, ctrl)
				if not ctrl.enabled then
					local state, reason = self:TakeAllState()
					if reason and not self:IsThreadRunning("warning text") then
						self:CreateThread("warning text", function()
							local node = ctrl:ResolveId("node")
							local txt = node.idWarningText
							txt:SetText(reason)
							txt:SetVisible(true)
							Sleep(1037)
							txt:SetVisible(false)
						end)
					end
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "TakeAllAction(self)",
				'func', function(self)
				local dlg = self
				local tab_filter = self.Mode == "loot" and self.selected_tab

				local context = dlg:GetContext()
				local unit = context.unit
				if not unit then return end
				local containers = InventoryGetLootContainers(context.container) or empty_table
				local units = { unit }
				local left = dlg:ResolveId("idPartyContainer")
				local list = left.idParty and left.idParty.idContainer or empty_table
				for _, ctrl in ipairs(list) do
					local data = ctrl:GetContext()
					if data then
						table.insert_unique(units, data)
					end
				end

				InventoryTakeAll(units, containers)
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "CompareWeaponSetUI(self, force_stop)",
				'func', function(self, force_stop)
				local set1, set2 = self.idUnitInfo.idWeapons1, self.idUnitInfo.idWeapons2
				--set1:SetVisible(self.compare_mode)-- and self.compare_mode_weaponslot==1)
				--set2:SetVisible(self.compare_mode)-- and self.compare_mode_weaponslot==2)
				if not force_stop and self.compare_mode_weaponslot then
					local ctrl = self.idUnitInfo["idWeapons" .. self.compare_mode_weaponslot]
					ctrl:SetToggled(true)
					ctrl:SetIconColumn(ctrl.Toggled and 2 or 1)
					local slot_ctrl
					if self.compare_mode then
						slot_ctrl = self.idUnitInfo["idWeapon" .. (self.compare_mode_weaponslot == 1 and "A" or "B")]
						local item_wnds = slot_ctrl.item_windows
						for item_ctrl, item in pairs(item_wnds) do
							item_ctrl.idText:SetEnabled(true)
							item_ctrl.idCenterText:SetEnabled(true)
							item_ctrl.idTopRightText:SetEnabled(true)
							item_ctrl.idItemImg:SetTransparency(0)
							item_ctrl.idItemImg:SetDesaturation(0)
						end
					end
					ctrl = self.idUnitInfo["idWeapons" .. (self.compare_mode_weaponslot == 1 and 2 or 1)]
					ctrl:SetToggled(false)
					ctrl:SetIconColumn(ctrl.Toggled and 2 or 1)
					if self.compare_mode then
						slot_ctrl = self.idUnitInfo["idWeapon" .. (self.compare_mode_weaponslot == 1 and "B" or "A")]
						local item_wnds = slot_ctrl.item_windows
						for item_ctrl, item in pairs(item_wnds) do
							item_ctrl.idText:SetEnabled(false)
							item_ctrl.idCenterText:SetEnabled(false)
							item_ctrl.idTopRightText:SetEnabled(false)
							item_ctrl.idItemImg:SetTransparency(180)
							item_ctrl.idItemImg:SetDesaturation(200)
						end
					end
				else
					for _, slot in ipairs({ "idWeaponA", "idWeaponB" }) do
						local slot_ctrl = self.idUnitInfo[slot]
						local item_wnds = slot_ctrl.item_windows
						for item_ctrl, item in pairs(item_wnds) do
							item_ctrl.idText:SetEnabled(true)
							item_ctrl.idCenterText:SetEnabled(true)
							item_ctrl.idTopRightText:SetEnabled(true)
							item_ctrl.idItemImg:SetTransparency(0)
							item_ctrl.idItemImg:SetDesaturation(0)
						end
					end
				end
				self:SetChangeWeaponRollover()
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "SetChangeWeaponRollover(self)",
				'func', function(self)
				local set1, set2 = self.idUnitInfo.idWeapons1, self.idUnitInfo.idWeapons2
				local unit = self.selected_unit
				if not self.compare_mode and InventoryIsCombatMode(unit) then
					local action = CombatActions.ChangeWeapon
					local state, reason = action:GetUIState({ unit })
					local ap = action:GetAPCost(unit)
					local has_ap = unit:UIHasAP(ap)

					local active_set = self.idUnitInfo["idWeapons" .. self.compare_mode_weaponslot]
					local new_set = self.idUnitInfo["idWeapons" .. (self.compare_mode_weaponslot == 1 and 2 or 1)]
					active_set:SetRolloverText("")
					new_set:SetRolloverText(T { 789323452495, "<ap(ap_cost)>", ap_cost = ap })
					if state == "hidden" then
						new_set.RolloverTemplate = "SmallRolloverGeneric"
						new_set:SetRolloverText(T(462153644901, "Character is busy"))
					elseif state == "disabled" and has_ap then -- bandage

					elseif has_ap then
						new_set.RolloverTemplate = "ChangeActiveWeaponAPRollover"
					else
						new_set.RolloverTemplate = "ChangeActiveWeaponAPFailedRollover"
					end
				else
					set1:SetRolloverText("")
					set2:SetRolloverText("")
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "SwapWeaponSet(self)",
				'func', function(self)
				local unit = self.selected_unit
				if InventoryIsCombatMode() then
					local action = CombatActions.ChangeWeapon
					local state = action:GetUIState({ unit })
					local ap = action:GetAPCost(unit)
					local has_ap = unit:UIHasAP(ap)
					if not has_ap or state ~= "enabled" then
						PlayFX("UnjamFail", "start")
						return false
					else
						if IsKindOf(unit, "Unit") then
							NetStartCombatAction("ChangeWeapon", unit, ap)
						else
							NetSyncEvent("InvetoryAction_SwapWeapon", unit.session_id, ap)
						end
						PlayFX("UnjamWeapon", "start")
					end
				else
					NetSyncEvent("InvetoryAction_SwapWeapon", unit.session_id, 0)
				end
				return true
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "ChangeContainerMode(self, mode)",
				'func', function(self, mode)
				local dlg = self
				local win, button
				if InventoryDragItem then
					local bag                 = GetSquadBagInventory(dlg.context.unit.Squad)
					local container_slot_name = GetContainerInventorySlotName(dlg.context.container)
					local slot_ctrl           = mode == "ammo" and
						dlg:GetSlotByName(InventoryStartDragSlotName or container_slot_name, dlg.context.container) or
						dlg:GetSlotByName(InventoryStartDragSlotName or "Inventory", bag)
					win                       = slot_ctrl.drag_win
					button                    = slot_ctrl.drag_button
					slot_ctrl.drag_win        = false
					local desktop             = slot_ctrl.desktop
					if desktop:GetMouseCapture() == slot_ctrl then
						desktop:SetMouseCapture(false)
					end
				end
				dlg:SetMode(mode)
				if InventoryDragItem then
					local bag = GetSquadBagInventory(dlg.context.unit.Squad)
					local container_slot_name = GetContainerInventorySlotName(dlg.context.container)
					local slot_ctrl = mode == "ammo" and
						dlg:GetSlotByName(InventoryStartDragSlotName or "Inventory", bag) or
						dlg:GetSlotByName(InventoryStartDragSlotName or container_slot_name, dlg.context.container)
					slot_ctrl.drag_win = win
					slot_ctrl.drag_button = button
					DragSource = slot_ctrl
					slot_ctrl.desktop:SetMouseCapture(slot_ctrl)
					if InventoryDragItem and not InventoryDragItems then
						HighlightEquipSlots(InventoryDragItem, true)
						HighlightWeaponsForAmmo(InventoryDragItem, true)
						--HighlightAPCost(InventoryDragItem, true, StartDragSource)
					end
				end
			end,
			}),
			PlaceObj('XTemplateFunc', {
				'name', "DeselectMultiItems(self)",
				'func', function(self)
				local selected_items = self.selected_items
				self.selected_items = {}
				for im, wnd_found in pairs(selected_items) do
					if wnd_found.window_state ~= "destroying" then
						wnd_found:OnSetSelected(false)
						wnd_found.idRollover:SetVisible(false)
					end
				end
			end,
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "NextUnit",
				'ActionName', T(196270563950, --[[XTemplate Inventory ActionName]] "Next Unit"),
				'ActionShortcut', "Tab",
				'ActionGamepad', "RightShoulder",
				'ActionBindable', true,
				'OnAction', function(self, host, source, ...)
				host:CloseCompare()
				if InventoryDragItem and StartDragSource then
					StartDragSource:CancelDragging()
				end
				local context = host:GetContext()
				if InventoryIsCombatMode() then
					g_Combat:NextUnit()
					context.unit = SelectedObj
				elseif gv_SatelliteView then
					local squad = context.unit.Squad and gv_Squads[context.unit.Squad]
					local idx = table.find(squad.units, context.unit.session_id)
					idx = idx + 1
					if idx > #squad.units then idx = 1 end
					context.unit = gv_UnitData[squad.units[idx]]
				else
					GetInGameInterfaceModeDlg():NextUnit()
					context.unit = SelectedObj
				end
				host:SetContext(context)
				host:OnContextUpdate(context)
				InventoryUIRespawn()
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPressGeneric",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "PrevUnit",
				'ActionName', T(884862371491, --[[XTemplate Inventory ActionName]] "Prev Unit"),
				'ActionGamepad', "LeftShoulder",
				'ActionBindable', true,
				'OnAction', function(self, host, source, ...)
				local context = host:GetContext()
				host:CloseCompare()
				if InventoryIsCombatMode() then
					g_Combat:PrevUnit()
					context.unit = SelectedObj
				elseif gv_SatelliteView then
					local squad = context.unit.Squad and gv_Squads[context.unit.Squad]
					local idx = table.find(squad.units, context.unit.session_id)
					idx = idx - 1
					if idx < 1 then idx = 1 end
					context.unit = gv_UnitData[squad.units[idx]]
				else
					GetInGameInterfaceModeDlg():NextUnit(nil, nil, nil, true)
					context.unit = SelectedObj
				end
				host:SetContext(context)
				host:OnContextUpdate(context)
				InventoryUIRespawn()
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPressGeneric",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "NextSquad",
				'ActionName', T(673071428097, --[[XTemplate Inventory ActionName]] "Next Squad"),
				'ActionGamepad', "LeftTrigger-RightShoulder",
				'ActionBindable', true,
				'OnAction', function(self, host, source, ...)
				local left = host:ResolveId("idPartyContainer")
				local squads = left:GetContext()
				if #squads <= 1 then
					return
				end
				local selected = left.selected_squad
				local idx = table.find(squads, selected)
				idx = idx + 1
				if idx > #squads then idx = 1 end
				left:SelectSquad(squads[idx])
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPressGeneric",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "PrevSquad",
				'ActionName', T(752681569250, --[[XTemplate Inventory ActionName]] "Prev Squad"),
				'ActionGamepad', "LeftTrigger-LeftShoulder",
				'ActionBindable', true,
				'OnAction', function(self, host, source, ...)
				local left = host:ResolveId("idPartyContainer")
				local squads = left:GetContext()
				if #squads <= 1 then
					return
				end
				local selected = left.selected_squad
				local idx = table.find(squads, selected)
				idx = idx - 1
				if idx < 1 then idx = #squads end
				left:SelectSquad(squads[idx])
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPressGeneric",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "CurrentWeapon1",
				'ActionName', T(222512614441, --[[XTemplate Inventory ActionName]] "Active Weapon I"),
				'ActionShortcut', "Z",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				return not host.compare_mode and "enabled" or "hidden"
			end,
				'OnAction', function(self, host, source, ...)
				if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 1 then
					if host:SwapWeaponSet() then
						host.compare_mode_weaponslot = 1
						host:CompareWeaponSetUI()
					end
				end
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "CurrentWeapon2",
				'ActionName', T(708528887842, --[[XTemplate Inventory ActionName]] "Active Weapon II"),
				'ActionShortcut', "X",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				return not host.compare_mode and "enabled" or "hidden"
			end,
				'OnAction', function(self, host, source, ...)
				if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 2 then
					if host:SwapWeaponSet() then
						host.compare_mode_weaponslot = 2
						host:CompareWeaponSetUI()
					end
				end
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "Primary",
				'ActionName', T(369940981994, --[[XTemplate Inventory ActionName]] "Loadout I"),
				'ActionToolbar', "InventoryActionBar",
				'ActionShortcut', "Z",
				'ActionShortcut2', "Shift-Z",
				'ActionGamepad', "DPadUp",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				return host.compare_mode and "enabled" or "hidden"
			end,
				'OnAction', function(self, host, source, ...)
				if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 1 then
					host.compare_mode_weaponslot = 1
					host:CloseCompare()
					host:OpenCompare()
					host:CompareWeaponSetUI()
				end
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "Secondary",
				'ActionName', T(961191695579, --[[XTemplate Inventory ActionName]] "Loadout II"),
				'ActionToolbar', "InventoryActionBar",
				'ActionShortcut', "X",
				'ActionShortcut2', "Shift-X",
				'ActionGamepad', "DPadDown",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				return host.compare_mode and "enabled" or "hidden"
			end,
				'OnAction', function(self, host, source, ...)
				if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 2 then
					host.compare_mode_weaponslot = 2
					host:CloseCompare()
					host:OpenCompare()
					host:CompareWeaponSetUI()
				end
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "Actions",
				'ActionName', T(330169171314, --[[XTemplate Inventory ActionName]] "Item Menu"),
				'ActionToolbar', "InventoryActionBar",
				'ActionShortcut', "right_click",
				'ActionGamepad', "ButtonX",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				return not host.compare_mode and "enabled" or "hidden"
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "Multiselect",
				'ActionName', T(706402605218, --[[XTemplate Inventory ActionName]] "Multiselect"),
				'ActionToolbar', "InventoryActionBar",
				'ActionShortcut', "Ctrl",
				'ActionGamepad', "LeftTrigger-ButtonA",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'OnShortcutUp', function(self, host, source, ...)
				return
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPress', "buttonPress",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "CompareItems",
				'ActionName', T(977052176447, --[[XTemplate Inventory ActionName]] "Compare"),
				'ActionToolbar', "InventoryActionBar",
				'ActionShortcut', "Shift",
				'ActionGamepad', "RightTrigger-ButtonY",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				if host.compare_mode then
					--self.ActionName =  T(917414532426, "<GameColorL>Compare</GameColorL>")
					return "hidden"
				else
					self.ActionName = T(341553928683, "Compare")
					return "enabled"
				end
			end,
				'OnAction', function(self, host, source, ...)
				if not host.compare_mode then
					host.compare_mode            = true
					host.compare_mode_weaponslot = host.context.unit.current_weapon == "Handheld A" and 1 or 2
					host:OpenCompare()
					PlayFX("buttonPress", "start")
				end
				host:CompareWeaponSetUI()
				host:ActionsUpdated()
			end,
				'OnShortcutUp', function(self, host, source, ...)
				if host.window_state == "destroying" then
					return
				end
				if host.compare_mode then
					host:CloseCompare("up")
					host.compare_mode_weaponslot    = host.context.unit.current_weapon == "Handheld A" and 1 or 2
					XInventoryItem.RolloverTemplate = "RolloverInventory"
					host.compare_mode               = false
				end
				host:CompareWeaponSetUI("force")
				host:ActionsUpdated()
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateAction', {
				'ActionId', "CloseInventory",
				'ActionName', T(370922956055, --[[XTemplate Inventory ActionName]] "Close"),
				'ActionToolbar', "InventoryActionBar",
				'ActionGamepad', "ButtonB",
				'ActionButtonTemplate', "InventoryActionBarButton",
				'ActionState', function(self, host)
				if not GetUIStyleGamepad() then
					return "hidden"
				end
				if host.compare_mode then
					self.ActionName = T(917456887182, "Stop Comparing")
				else
					self.ActionName = T(175313021861, "Close")
				end
			end,
				'OnAction', function(self, host, source, ...)
				if host.compare_mode then
					hostCloseCompare()
					XInventoryItem.RolloverTemplate = "RolloverInventory"
					host.compare_mode               = false
					host:CompareWeaponSetUI()
					host:ActionsUpdated()
				elseif not host:OnEscape() then
					if CurrentTutorialPopup and CurrentTutorialPopup.window_state ~= "destroying" then
						local ctx = CurrentTutorialPopup:ResolveId("idText"):GetContext()
						TutorialDismissHint(ctx)
						CloseCurrentTutorialPopup()
					else
						local dlg = GetDialog("FullscreenGameDialogs")
						if dlg then
							dlg:SetMode("empty")
							dlg:Close()
						end
					end
				end
			end,
				'OnShortcutUp', function(self, host, source, ...)
				if host.window_state == "destroying" then
					return
				end
				if host.compare_mode then
					host:CloseCompare("up")
					host.compare_mode_weaponslot    = host.context.unit.current_weapon == "Handheld A" and 1 or 2
					XInventoryItem.RolloverTemplate = "RolloverInventory"
					host.compare_mode               = false
					host:CompareWeaponSetUI("force")
					host:ActionsUpdated()
				end
			end,
				'IgnoreRepeated', true,
				'FXMouseIn', "buttonRollover",
				'FXPressDisabled', "IactDisabled",
			}),
			PlaceObj('XTemplateWindow', {
				'Id', "idDlgContent",
				'LayoutMethod', "HList",
			}, {
				PlaceObj('XTemplateTemplate', {
					'__context', function(parent, context)
					return SortSquads(gv_SatelliteView and
						GetSquadsInSector(false, false, nil) or GetSquadsOnMap("reference"))
				end,
					'__template', "SquadsAndMercs",
					'Margins', box(25, 25, 10, 0),
					'MinWidth', 446,
					'MaxWidth', 446,
				}, {
					PlaceObj('XTemplateFunc', {
						'name', "SelectSquad(self, ...)",
						'func', function(self, ...)
						if SquadsAndMercsClass.SelectSquad(self, ...) then
							local invDiag = GetDialog(self)
							invDiag:OnSquadSelected(self.selected_squad)
						end
					end,
					}),
				}),
				PlaceObj('XTemplateWindow', {
					'Margins', box(-1610, 0, 0, 73),
					'HAlign', "left",
					'VAlign', "bottom",
					'MinWidth', 580,
					'MaxWidth', 580
				}, {
					PlaceObj('XTemplateWindow', {
						'comment', "left",
						'__context', function(parent, context) return context.unit end,
						'__class', "XContentTemplate",
						'Id', "idUnitInfo",
						'MinHeight', 360,
						'MinWidth', 580,
						'MaxHeight', 360,
						'HAlign', "right",
						'RespawnOnContext', false,
					}, {
						PlaceObj('XTemplateWindow', {
							'comment', "background rectangle",
							'__class', "XImage",
							'BorderWidth', 1,
							'Dock', "box",
							'ImageFit', "stretch",
							'Background', RGBA(43, 43, 43, 255),
							'Image', "UI/Inventory/character_pad",
						}),
						PlaceObj('XTemplateWindow', {
							'comment', "big portrait",
							'__class', "XContextImage",
							'Id', "idBigPortrait",
							'Dock', "box",
							'ImageFit', "none",
							'ImageRect', box(100, -1000, 1480, 1900),
							'ScaleModifier', point(530, 530),
							'ContextUpdateOnOpen', true,
							'OnContextUpdate', function(self, context, ...)
							self:SetImage(context.BigPortrait)
						end,
						}, {
							PlaceObj('XTemplateWindow', {
								'__class', "XContextWindow",
								'Margins', box(0, 100, 0, 0),
								'HandleMouse', true,
							}, {
								PlaceObj('XTemplateFunc', {
									'name', "IsDropTarget(self, draw_win, pt)",
									'func', function(self, draw_win, pt)
									return IsKindOf(InventoryDragItem, "MiscItem")
										and InventoryDragItem.effect_moment == "on_use"
										and not next(InventoryDragItems)
									--and (gv_SatelliteView or InventoryIsValidGiveDistance(InventoryStartDragContext, self:GetContext()))
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "OnDrop(self, drag_win, pt, drag_source_win)",
									'func', function(self, drag_win, pt, drag_source_win)
									if (not gv_SatelliteView or InventoryIsCombatMode()) and not InventoryIsValidGiveDistance(InventoryStartDragContext, self:GetContext()) then
										PlayFX("IactDisabled", "start", InventoryDragItem)
										return true
									end
									if InventoryUnitCanUseItem(self.context, InventoryDragItem) and (not g_Combat or self.context:HasAP(InventoryDragItem.APCost * const.Scale.AP)) then
										InventoryUseItem(self.context, InventoryDragItem, InventoryStartDragContext,
											InventoryStartDragSlotName)
										if InventoryDragItem and StartDragSource then
											StartDragSource:ClearDragState(drag_win)
										end
									else
										PlayFX("IactDisabled", "start", InventoryDragItem)
									end
									return true
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "OnDropEnter(self, draw_win, pt, drag_source)",
									'func', function(self, draw_win, pt, drag_source)
									local mouse_text = T { 863973882023, "<merc> Uses <em><item_name></em>", merc = self.context.Nick, item_name = InventoryDragItem.DisplayName }
									local can_use = InventoryUnitCanUseItem(self.context, InventoryDragItem)
									if not can_use then
										mouse_text = mouse_text ..
											"\n" .. T(498556428804, "<style InventoryHintTextRed>Max stat</style>")
									end
									local valid, reason = InventoryIsValidGiveDistance(InventoryStartDragContext,
										self:GetContext())
									if (not gv_SatelliteView or InventoryIsCombatMode()) and not valid and reason and reason ~= "" then
										mouse_text = mouse_text .. "\n" .. reason
									end
									if not mouse_text then
										mouse_text = action_name or ""
										if InventoryIsCombatMode() and item.APCost and item.APCost > 0 then
											mouse_text = InventoryFormatAPMouseText(self.context, item.APCost, mouse_text)
										end
									end

									InventoryShowMouseText(true, mouse_text)
									return
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "OnDropLeave(self, drag_win)",
									'func', function(self, drag_win)
									InventoryShowMouseText(false)
									return
								end,
								}),
								PlaceObj('XTemplateFunc', {
									'name', "FindTile",
									'func', function(self, ...)
									return
								end,
								}),
							}),
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "XContentTemplate",
							'IdNode', false,
							'Margins', box(13, 0, 26, 10),
							'Dock', "bottom",
							'RespawnOnContext', false,
						}, {
							PlaceObj('XTemplateWindow', {
								'__class', "XContentTemplate",
								'Id', "idEquipSlots",
								'IdNode', false,
								'LayoutMethod', "Grid",
								'LayoutVSpacing', 10,
								'RespawnOnContext', false,
								'ScaleModifier', point(850, 850),
							}, {
								PlaceObj('XTemplateWindow', {
									'comment', "armor",
									'HAlign', "left",
									'VAlign', "top",
									'GridX', 1,
									'GridY', 1,
									'LayoutMethod', "Grid",
								}, {
									PlaceObj('XTemplateWindow', {
										'__class', "EquipInventorySlot",
										'Id', "idHead",
										'ScaleModifier', point(900, 900),
										'MouseCursor', "UI/Cursors/Pda_Cursor.tga",
										'slot_name', "Head",
										'GridX', 2,
										'GridY', 1,
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
										'GridX', 3,
										'GridY', 1,
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
										'Id', "idFace",
										'ScaleModifier', point(900, 900),
										'MouseCursor', "UI/Cursors/Pda_Cursor.tga",
										'slot_name', "FaceItem",
										'GridX', 2,
										'GridY', 2,
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
										'Id', "idBackpack",
										'ScaleModifier', point(900, 900),
										'slot_name', "Backpack",
										'GridX', 1,
										'GridY', 3,
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
										'GridX', 2,
										'GridY', 3,
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
										'GridX', 3,
										'GridY', 3,
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
										'Id', "idLHolster",
										'ScaleModifier', point(900, 900),
										'slot_name', "LHolster",
										'GridX', 1,
										'GridY', 4,
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
										'GridX', 2,
										'GridY', 4,
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
										'GridX', 3,
										'GridY', 4,
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
									'comment', "weapons",
									'LayoutMethod', "VList",
									'GridX', 2,
									'VAlign', "bottom",
								}, {
									PlaceObj('XTemplateWindow', nil, {
										PlaceObj('XTemplateWindow', {
											'Id', "idWeaponAEx",
											'Dock', "right",
											'Margins', box(-30, 0, 0, 0),
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
											'Dock', "right",
											'Margins', box(-30, 0, 0, 0),
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
							}),
							PlaceObj('XTemplateWindow', {
								'__class', "XText",
								'Id', "idEquipHint",
								'Margins', box(70, 0, 0, -25),
								'HAlign', "left",
								'VAlign', "bottom",
								'MinWidth', 190,
								'Visible', false,
								'TextStyle', "PDABrowserTextLight",
								'Translate', true,
								'Text', T(673883947178, --[[XTemplate Inventory Text]] "Not Enough AP "),
								'TextHAlign', "center",
							}),
						}),
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "left - mercpack",
						'Margins', box(0, 0, 0, 0),
						'HAlign', "right",
						'Dock', "bottom",
						'LayoutMethod', "VList",
					}, {
						PlaceObj('XTemplateWindow', {
							'comment', "right",
							'__class', "XContentTemplate",
							'__context', function(parent, context) return context.unit end,
							'Id', "idLeft",
							'IdNode', false,
							'Margins', box(0, 20, 0, 0),
							'MinHeight', 372,
							'MaxHeight', 372,
							'MinWidth', 580,
							'MaxWidth', 580,
							'Clip', "parent & self",
							'RespawnOnContext', false,
						}, {
							PlaceObj('XTemplateWindow', {
								'__class', "XImage",
								'IdNode', false,
								'Image', "UI/Inventory/T_Backpack_Inventory_Container",
								'ImageFit', "stretch",
							}),
							PlaceObj('XTemplateTemplate', {
								'comment', "inventory list",
								'__template', "InventoryScrollArea",
								'Id', "idScrollAreaLeft",
								'IdNode', false,
								'Margins', box(0, 20, 0, 30),
								'VScroll', "idScrollbarLeft",
								'ScaleModifier', point(800, 800),
							}, {
								PlaceObj('XTemplateForEach', {
									'array', function(parent, context)
									return context and context.unit and { context.unit.session_id }
								end,
									'condition', function(parent, context, item, i) return context end,
									'__context', function(parent, context, item, i, n)
									if not item then return false end
									local unit
									if gv_SatelliteView then
										unit = gv_UnitData[item]
									else
										unit = g_Units[item] or
											gv_UnitData[item]
									end
									return unit
								end,
									'run_after', function(child, context, item, i, n, last)
									child.unit = context
									if InventoryUIGrayOut(context) then
										child:SetTransparency(150)
									end
								end,
								}, {
									PlaceObj('XTemplateWindow', {
										'__class', "XContentTemplate",
										'LayoutMethod', "VList",
										'RespawnOnContext', false,
									}, {
										PlaceObj('XTemplateCode', {
											'run', function(self, parent, context)
											if InventoryIsNotControlled(context) then
												parent.RespawnOnContext = true
											end
										end,
										}),
										PlaceObj('XTemplateWindow', {
											'Margins', box(26, 0, 0, 0),
										}, {
											PlaceObj('XTemplateWindow', {
												'__condition', function(parent, context) return context end,
												'__class', "XText",
												'Id', "idName",
												'HandleMouse', false,
												'TextStyle', "InventoryBackpackTitle",
												'Translate', true,
												'Text', T(971957775453, --[[XTemplate Inventory Text]] "<Nick> BACKPACK"),
												'TextVAlign', "center",
												'OnLayoutComplete', function(self)
												local unit = self.context
												if not REV_IsMerc(unit) then
													return
												end
												self:SetText(T(3269654860290817,
													"<Nick> EQUIPMENT <GetCurrentWeightInKg()>/<GetMaxWeightInKg()> Kg",
													unit))
											end
											}, {
												PlaceObj('XTemplateFunc', {
													'name', "SetHightlighted(self, show)",
													'func', function(self, show)
													local dlg = GetDialog(self)
													local show = show or
														dlg.selected_unit.session_id == self:GetContext().session_id
													self:SetTextStyle(not show and "InventoryBackpackTitle" or
														"InventoryBackpackTitleHighlight")
												end,
												}),
											}),
										}),
										PlaceObj('XTemplateWindow', {
											'__condition', function(parent, context) return context end,
											'__class', "BrowseInventorySlot",
											'Id', "idInventorySlot",
											'Margins', box(24, 0, 0, 0),
											'HAlign', "left",
											'UniformColumnWidth', true,
											'UniformRowHeight', false,
											'slot_name', "Inventory",
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "Open",
												'func', function(self, ...)
												BrowseInventorySlot.Open(self, ...)
												local dlg = GetDialog(self)
												dlg.slots[self] = true
												if dlg.context.unit and self.context.session_id == dlg.context.unit.session_id then
													self.parent.idName:SetHightlighted(true)
												end
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
							}),
							PlaceObj('XTemplateWindow', {
								'__class', "XZuluScroll",
								'Id', "idScrollbarLeft",
								'Margins', box(0, 30, 10, 20),
								'HAlign', "right",
								'FoldWhenHidden', false,
								'MouseCursor', "UI/Cursors/Hand.tga",
								'Target', "idScrollAreaLeft",
								'Max', 9999,
								'AutoHide', true,
							}, {
								PlaceObj('XTemplateFunc', {
									'name', "MoveThumb",
									'func', function(self, ...)
									XZuluScroll.MoveThumb(self, ...)
									if not self.layout_update then
										Msg("ScrollInventory")
									end
								end,
								}),
							}),
						}),
					}),
				}),
				PlaceObj('XTemplateWindow', {
					'comment', "center - loot/ammo",
					'__class', "XContextWindow",
					'Margins', box(-1015, 18, 0, 0),
					'HAlign', "left",
					'LayoutMethod', "VList",
				}, {
					PlaceObj('XTemplateWindow', {
						'__class', "XText",
						'Id', "idCenterHeading",
						'Padding', box(0, 0, 0, 0),
						'TextStyle', "InventoryContainerTitle",
						'Translate', true,
						'Text', T(236302281025, --[[XTemplate Inventory Text]] "Loot"),
						'TextHAlign', "center",
						'TextVAlign', "center",
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "center",
						'__class', "XContentTemplate",
						'Id', "idCenter",
						'IdNode', false,
						'Margins', box(0, 20, 0, 0),
						'HAlign', "center",
						'MinWidth', 400,
						'MinHeight', 752,
						'MaxWidth', 400,
						'MaxHeight', 752,
						'OnContextUpdate', function(self, context, ...)
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
					end,
						'RespawnOnContext', false,
					}, {
						PlaceObj('XTemplateMode', {
							'mode', "loot",
						}, {
							PlaceObj('XTemplateWindow', {
								'comment', "loot",
								'__context', function(parent, context)
								if not gv_SatelliteView then
									return context.container
								end

								local dlg = GetDialog(parent)
								local tab = dlg.selected_tab
								if not tab or tab == "all" then
									return context.container
								end
								local sector_id = gv_SectorInventory.sector_id
								gv_SectorInventory:Clear()
								local preset = InventoryTabs[tab]
								local context = GetSectorInventory(sector_id,
									function(item) return preset:FilterItem(item) end, 'sort')
								dlg.context.container = context
								return context
							end,
								'__class', "XContextWindow",
								'Id', "idLootContainer",
								'ContextUpdateOnOpen', true,
							}, {
								PlaceObj('XTemplateWindow', {
									'__class', "XFrame",
									'IdNode', false,
									'Image', "UI/Inventory/T_Backpack_Inventory_Container",
								}, {
									PlaceObj('XTemplateWindow', {
										'__condition', function(parent, context)
										local unit = GetInventoryUnit()
										if gv_SatelliteView then
											if unit.Squad and gv_Squads[unit.Squad] and context.sector_id ~= gv_Squads[unit.Squad].CurrentSector then
												return true
											end
										end
										return false
									end,
										'__class', "XText",
										'Id', "idOtherSectorStash",
										'Margins', box(24, 0, 24, 0),
										'HAlign', "left",
										'VAlign', "top",
										'MinWidth', 430,
										'MinHeight', 60,
										'MaxWidth', 430,
										'MaxHeight', 60,
										'TextStyle', "InventoryWarning",
										'Translate', true,
										'Text', T(613199745056, --[[XTemplate Inventory Text]]
										"The selected squad is not in the sector"),
										'TextHAlign', "center",
										'TextVAlign', "center",
									}),
									PlaceObj('XTemplateTemplate', {
										'comment', "inventory list",
										'__template', "InventoryScrollArea",
										'Id', "idScrollAreaCenter",
										'IdNode', false,
										'Margins', box(0, 20, 0, 65),
										'VScroll', "idScrollbarCenter",
										'ScaleModifier', point(800, 800),
									}, {
										PlaceObj('XTemplateForEach', {
											'array', function(parent, context) return InventoryGetLootContainers(context) end,
											'__context', function(parent, context, item, i, n) return item end,
											'run_after', function(child, context, item, i, n, last)
											child.container = context

											-- Make sure all containers we are operating on are open, syncing the items with the stash
											if IsKindOf(context, "ItemContainer") then
												local unit = GetInventoryUnit()
												if not context:IsOpened() then
													NetSyncEvent("OpenContainer", context, unit.session_id)
												end

												-- Log interaction for any containers opened because they were close to the one being interacted with.
												if i ~= 1 and IsKindOf(context, "Interactable") then
													context:LogInteraction(unit, { id = "ProxyLoot" })
												end
											end

											local name = T(495002164195, "BAG")
											local is_sector_stash = IsKindOf(context, "SectorStash")
											if is_sector_stash then
												name = Untranslated("") -- T{288565331426, "SECTOR <sector> STASH", sector = Untranslated(context.sector_id or gv_CurrentSectorId or "")}
												child.parent:SetMargins(box(0, 60, 0, 65))
											elseif IsKindOf(context, "Unit") then
												name = context:IsMerc() and T(185167895211, "<Nick> BODY") or
													T(698760915819, "DEAD BODY")
											elseif context:HasMember("spawner") and IsKindOf(context.spawner, "ContainerMarker") then
												name = context.spawner.DisplayName or T(495002164195, "BAG")
											elseif context:HasMember("DisplayName") then
												name = context.DisplayName
											end
											child.idName:SetText(name)

											if not IsMerc(context) then
												context:ForEachItem(function(item)
													if not g_GossipItemsSeenByPlayer[item.id] and not g_GossipItemsTakenByPlayer[item.id] and not g_GossipItemsMoveFromPlayerToContainer[item.id] then
														g_GossipItemsSeenByPlayer[item.id] = true
														NetGossip("Loot", "PlayerSeen", item.class,
															rawget(item, "Amount") or 1, GetCurrentPlaytime(),
															Game and Game.CampaignTime)
													end
												end)
											end
										end,
										}, {
											PlaceObj('XTemplateWindow', {
												'__class', "XContentTemplate",
												'Margins', box(24, 0, 24, 0),
												'LayoutMethod', "VList",
												'RespawnOnContext', false,
											}, {
												PlaceObj('XTemplateWindow', nil, {
													PlaceObj('XTemplateWindow', {
														'__condition', function(parent, context) return context end,
														'__class', "XText",
														'Id', "idName",
														'Padding', box(6, 2, 2, 2),
														'FoldWhenHidden', true,
														'TextStyle', "InventoryBackpackTitle",
														'Translate', true,
														'Text', T(227485168633, --[[XTemplate Inventory Text]] "BAG"),
														'HideOnEmpty', true,
														'TextVAlign', "center",
													}),
												}),
												PlaceObj('XTemplateWindow', {
													'__condition', function(parent, context)
													return context and
														IsKindOf(context, "Unit")
												end,
													'__class', "BrowseInventorySlot",
													'Id', "idInventorySlot",
													'HAlign', "left",
													'UniformColumnWidth', true,
													'UniformRowHeight', false,
													'slot_name', "InventoryDead",
												}, {
													PlaceObj('XTemplateFunc', {
														'name', "Open",
														'func', function(self, ...)
														BrowseInventorySlot.Open(self, ...)
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
													'__condition', function(parent, context)
													return context and
														not IsKindOf(context, "Unit")
												end,
													'__class', "BrowseInventorySlot",
													'Id', "idInventorySlot",
													'HAlign', "left",
													'UniformColumnWidth', true,
													'UniformRowHeight', false,
													'slot_name', "Inventory",
												}, {
													PlaceObj('XTemplateFunc', {
														'name', "Open",
														'func', function(self, ...)
														BrowseInventorySlot.Open(self, ...)
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
									}),
									PlaceObj('XTemplateWindow', {
										'__class', "XZuluScroll",
										'Id', "idScrollbarCenter",
										'Margins', box(0, 50, 10, 65),
										'HAlign', "right",
										'MouseCursor', "UI/Cursors/Hand.tga",
										'Target', "idScrollAreaCenter",
										'Max', 9999,
										'AutoHide', true,
									}),
									PlaceObj('XTemplateWindow', {
										'comment', "tabs",
										'__condition', function(parent, context)
										local unit = GetInventoryUnit()
										if gv_SatelliteView then
											if unit.Squad and gv_Squads[unit.Squad] and context.sector_id == gv_Squads[unit.Squad].CurrentSector then
												return true
											end
										end
										return false
									end,
										'Margins', box(28, 20, 0, 0),
										'ScaleModifier', point(800, 800),
									}, {
										PlaceObj('XTemplateWindow', {
											'__context', function(parent, context) return "inventory tabs" end,
											'__class', "XContentTemplate",
											'Id', "idTabs",
											'Dock', "top",
											'LayoutMethod', "HList",
											'LayoutHSpacing', 11,
										}, {
											PlaceObj('XTemplateForEach', {
												'array', function(parent, context) return Presets.InventoryTab.Default end,
												'__context', function(parent, context, item, i, n) return item end,
												'run_after', function(child, context, item, i, n, last)
												local tab = item --InventoryTabs[item]
												child.idTabIcon:SetImage(tab.icon)
												local dlg = GetDialog(child)
												child:SetToggled(dlg.selected_tab == item.id)
												child:SetId(item.id)
											end,
											}, {
												PlaceObj('XTemplateWindow', {
													'__class', "XToggleButton",
													'MinWidth', 62,
													'MinHeight', 32,
													'MaxWidth', 62,
													'MaxHeight', 32,
													'LayoutMethod', "Box",
													'BorderColor', RGBA(0, 0, 0, 0),
													'Background', RGBA(255, 255, 255, 0),
													'FocusedBorderColor', RGBA(0, 0, 0, 0),
													'FocusedBackground', RGBA(255, 255, 255, 0),
													'DisabledBorderColor', RGBA(0, 0, 0, 0),
													'OnPress', function(self, gamepad)
													if self.Toggled then return end
													self:SetToggled(not self.Toggled)
													XTextButton.OnPress(self)
													local dlg = GetDialog(self)
													dlg.selected_tab = self.context.id
													local sector_id = gv_SectorInventory.sector_id
													gv_SectorInventory:Clear()
													dlg.context.container = GetSectorInventory(sector_id,
														function(item) return self.context:FilterItem(item) end, 'sort')
													dlg.idCenter:RespawnContent()
													local selected = dlg.selected_items
													dlg:DeselectMultiItems()

													ObjModified("inventory tabs")
												end,
													'RolloverBackground', RGBA(0, 0, 0, 0),
													'PressedBackground', RGBA(0, 0, 0, 0),
													'Icon', "UI/Inventory/tabs_button",
													'IconColumns', 2,
													'DisabledIconColor', RGBA(255, 255, 255, 0),
													'ToggledBackground', RGBA(215, 159, 80, 255),
												}, {
													PlaceObj('XTemplateFunc', {
														'name', "OnChange(self, toggled)",
														'func', function(self, toggled)
														self:SetIconColumn(toggled and 2 or 1)
														self.idTabIcon:SetColumn(toggled and 2 or 1)
													end,
													}),
													PlaceObj('XTemplateWindow', {
														'__class', "XImage",
														'Id', "idTabIcon",
														'HAlign', "center",
														'VAlign', "center",
														'HandleMouse', true,
														'Image', "UI/Inventory/tabs_all.png",
														'Columns', 2,
													}),
												}),
											}),
										}),
									}),
									PlaceObj('XTemplateWindow', {
										'ZOrder', 2,
										'Margins', box(0, 0, 0, 10),
										'VAlign', "bottom",
										'DrawOnTop', true,
									}, {
										PlaceObj('XTemplateFunc', {
											'name', "Open",
											'func', function(self, ...)
											XWindow.Open(self)
											local take = self:ResolveId("idTakeAll")
											local vtake = take and take:GetVisible()
											local select = self:ResolveId("idSelectAll")
											local vselect = select and select:GetVisible()

											if vtake and not vselect then
												take:SetHAlign("center")
											end
											if vtake and vselect then
												take:SetHAlign("right")
												select:SetHAlign("left")
											end
											if not vtake and vselect then
												select:SetHAlign("center")
											end
										end,
										}),
										PlaceObj('XTemplateTemplate', {
											'comment', "ammo pack -  set invisble",
											'__context', function(parent, context) return "GamepadUIStyleChanged" end,
											'__condition', function(parent, context)
											local host = GetActionsHost(parent, true)
											local context = host:GetContext()
											return context.container
										end,
											'__template', "InventoryActionBarButtonCenter",
											'Id', "idAmmo",
											'HAlign', "left",
											'VAlign', "bottom",
											'MinWidth', 240,
											'MaxHeight', 240,
											'Visible', false,
											'OnPressEffect', "action",
											'OnPressParam', "AmmoPack",
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "IsDropTarget(self, draw_win, pt)",
												'func', function(self, draw_win, pt)
												return true
											end,
											}),
											PlaceObj('XTemplateFunc', {
												'name', "OnDropEnter(self, draw_win, pt, drag_source)",
												'func', function(self, draw_win, pt, drag_source)
												self:SetRollover(true)
											end,
											}),
											PlaceObj('XTemplateFunc', {
												'name', "OnDropLeave(self, drag_win)",
												'func', function(self, drag_win)
												self:SetRollover(false)
											end,
											}),
											PlaceObj('XTemplateFunc', {
												'name', "OnDrop(self, drag_win, pt, drag_source_win)",
												'func', function(self, drag_win, pt, drag_source_win)
												local dlg = GetDialog(self)
												--dlg:SetMode("ammo")
												dlg:ChangeContainerMode("ammo")
												return "not valid target"
											end,
											}),
										}),
										PlaceObj('XTemplateWindow', {
											'__class', "XText",
											'Id', "idWarningText",
											'Margins', box(0, 0, 0, 40),
											'HAlign', "center",
											'VAlign', "bottom",
											'Visible', false,
											'FoldWhenHidden', true,
											'TextStyle', "InventoryActionsTextRedBig",
											'Translate', true,
											'Text', T(295657023753, --[[XTemplate Inventory Text]] "Inventory is full"),
											'HideOnEmpty', true,
										}),
										PlaceObj('XTemplateTemplate', {
											'comment', "takeall",
											'__context', function(parent, context) return "GamepadUIStyleChanged" end,
											'__condition', function(parent, context)
											local host = GetActionsHost(parent, true)
											local context = host:GetContext()
											return context.container
										end,
											'__template', "InventoryActionBarButtonCenter",
											'Id', "idTakeAll",
											'HAlign', "center",
											'VAlign', "bottom",
											'MinWidth', 240,
											'MaxHeight', 240,
											'ScaleModifier', point(800, 800),
											'OnContextUpdate', function(self, context, ...)
											if self.action then
												self:SetText(self.action.ActionName)
											end
											local host = GetActionsHost(self.parent, true)
											local hidden = host:TakeAllState() == "hidden"
											self:SetVisible(not hidden)
										end,
											'OnPressEffect', "action",
											'OnPressParam', "TakeAll",
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "Open",
												'func', function(self, ...)
												XTextButton.Open(self)
												if self.action then
													self:SetText(self.action.ActionName)
												end
												local host = GetActionsHost(self.parent, true)
												local hidden = host:TakeAllState() == "hidden"
												self:SetVisible(not hidden)
											end,
											}),
											PlaceObj('XTemplateFunc', {
												'name', "Press(self, alt, force, gamepad)",
												'func', function(self, alt, force, gamepad)
												local dlg = GetDialog(self)
												dlg:TakeAllStateWarning(self)
												XTextButton.Press(self, alt, force, gamepad)
											end,
											}),
										}),
										PlaceObj('XTemplateTemplate', {
											'comment', "select all",
											'__context', function(parent, context) return "GamepadUIStyleChanged" end,
											'__condition', function(parent, context)
											local host = GetActionsHost(parent, true)
											local context = host:GetContext()
											return context.container and gv_SatelliteView
										end,
											'__template', "InventoryActionBarButtonCenter",
											'Id', "idSelectAll",
											'HAlign', "left",
											'VAlign', "bottom",
											'MinWidth', 240,
											'MaxHeight', 240,
											'ScaleModifier', point(800, 800),
											'OnContextUpdate', function(self, context, ...)
											if self.action then
												self:SetText(self.action.ActionName)
											end
										end,
											'OnPressEffect', "action",
											'OnPressParam', "SelectAll",
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "Open",
												'func', function(self, ...)
												XTextButton.Open(self)
												if self.action then
													self:SetText(self.action.ActionName)
												end
												local host = GetActionsHost(self.parent, true)
												local hidden = self.action:ActionState(host) == "hidden"
												self:SetVisible(not hidden)
											end,
											}),
										}),
									}),
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "AmmoPack",
									'ActionName', T(217119703945, --[[XTemplate Inventory ActionName]] "SQUAD SUPPLIES"),
									'ActionShortcut', "A",
									'ActionState', function(self, host)
									local context = host:GetContext()
									return context.container and "enabled" or "hidden"
								end,
									'OnAction', function(self, host, source, ...)
									-- temporaly remove attached obj when change ammo and loot
									--host:OnEscape()
									--host:SetMode("ammo")
									--[[
									local dlg = GetDialog(self)
									host:ChangeContainerMode("ammo")
									--]]
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "TakeAll",
									'ActionName', T(756073794149, --[[XTemplate Inventory ActionName]] "TAKE ALL"),
									'ActionShortcut', "T",
									'ActionGamepad', "LeftTrigger-ButtonY",
									'ActionState', function(self, host)
									return host:TakeAllState()
								end,
									'OnAction', function(self, host, source, ...)
									return host:TakeAllAction()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "UnloadAll",
									'ActionName', T(7560737941490816, --[[XTemplate Inventory ActionName]] "UNLOAD ALL"),
									'ActionShortcut', "Ctrl-Shift-U",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									local inventory = gv_SectorInventory.Inventory

									for i, item in ipairs(inventory) do
										if not IsKindOf(item, "Firearm") and not IsKindOf(item, "Mag") then
											goto continue
										end

										local unit = GetInventoryUnit()

										UnloadWeapon(item, gv_SquadBag)

										local subWeapon = not IsKindOf(item, "Mag") and item:GetSubweapon("Firearm")

										if subWeapon then
											UnloadWeapon(subWeapon, gv_SquadBag)
										end

										::continue::
									end

									InventoryUIRespawn()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "ToggleRollover",
									'ActionName', T(7560737941490820, --[[XTemplate Inventory ActionName]]
									"TOGGLE ROLLOVER"),
									'ActionShortcut', "Ctrl-Shift-N",
									'ActionState', function(self, host)
									return "enabled"
								end,
									'OnAction', function(self, host, source, ...)
									gv_REV_ShowRollover = not gv_REV_ShowRollover
									CombatLog("important",
										T { 290809809081789, "Rollover is now <abled>", abled = gv_REV_ShowRollover and T(2987978918, "enabled") or T(2987978919, "disabled") })
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "MergeAll",
									'ActionName', T(7560737941490820, --[[XTemplate Inventory ActionName]] "MERGE ALL"),
									'ActionShortcut', "Ctrl-Shift-M",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									CS_Merge()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "SortAll",
									'ActionName', T(7560737941490820, --[[XTemplate Inventory ActionName]] "SORT ALL"),
									'ActionShortcut', "Ctrl-Shift-S",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									CS_Sort()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "UnloadEquipment",
									'ActionName', T(7560737941490821, --[[XTemplate Inventory ActionName]]
									"UNLOAD EQUIPMENT"),
									'ActionShortcut', "Ctrl-Shift-C",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									local container = gv_SectorInventory

									g_StoredItemIdToItem = g_StoredItemIdToItem or {}

									local sectorItems = container:GetItems()

									for _, litem in ipairs(sectorItems) do
										if IsKindOf(litem, "PersonalStorage") and litem.items and #litem.items > 0 then
											for i, itemId in ipairs(litem.items) do
												local item = g_ItemIdToItem[itemId] or g_StoredItemIdToItem[itemId]

												if not item then
													goto continue
												end

												container:AddItem("Inventory", item)

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

												::continue::
											end

											litem.items = {}

											litem:SetProperty("SubIcon", nil)
										end
									end

									InventoryUIRespawn()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "MoveAllToSectorStash",
									'ActionName', T(7560737941490818, --[[XTemplate Inventory ActionName]]
									"MOVE ALL TO SECTOR STASH"),
									'ActionShortcut', "Ctrl-Shift-D",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									local unit = host.selected_unit

									if not unit then
										return
									end

									local inventory = unit.Inventory

									local movers = {}

									for i, item in ipairs(inventory) do
										if type(item) == "table" then
											table.insert(movers, item.id)
										end
									end

									NetSyncEvent("MoveItemsToStash", movers, gv_SectorInventory.sector_id, "Inventory",
										unit.session_id)
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "MoveEquipmentToSectorStash",
									'ActionName', T(7560737941490817, --[[XTemplate Inventory ActionName]]
									"MOVE EQUIPMENT TO SECTOR STASH"),
									'ActionShortcut', "Ctrl-Shift-E",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									local unit = host.selected_unit

									if not unit then
										return
									end

									local equipSlots = REV_GetEquipSlots()

									for i, slot in ipairs(equipSlots) do
										if unit[slot] then
											local movers = {}

											local items = unit[slot]

											for i, item in ipairs(items) do
												if type(item) == "table" and not item.locked then
													table.insert(movers, item.id)
												end
											end

											local items = GetItemsFromItemsNetId(movers)
											local stash = gv_SectorInventory
											local container = GetContainerFromContainerNetId(unit.session_id)
											if stash then
												for i = 1, #items do
													container:RemoveItem(slot, items[i])
												end
												AddItemsToInventory(stash, items, true)
											end
										end
									end

									InventoryUIRespawn()
									InventoryDeselectMultiItems()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "MovSquadBagToSectorStash",
									'ActionName', T(7560737941490816, --[[XTemplate Inventory ActionName]]
									"MOVE SQUADBAG TO SECTOR STASH"),
									'ActionShortcut', "Ctrl-Shift-B",
									'ActionState', function(self, host)
									return gv_SatelliteView and
										not IsSquadTravelling(gv_Squads[host.selected_unit.Squad]) and
										not InventoryIsCombatMode(host.selected_unit) and
										"enabled" or "disabled"
								end,
									'OnAction', function(self, host, source, ...)
									local inventory = gv_SquadBag.Inventory

									local movers = {}

									for i, item in ipairs(inventory) do
										if type(item) == "table" then
											table.insert(movers, item.id)
										end
									end

									NetSyncEvent("MoveItemsToStash", movers, gv_SectorInventory.sector_id, "Inventory",
										GetContainerNetId(gv_SquadBag))

									-- local bag = gv_SquadBag and GetSquadBag(gv_SquadBag.squad_id)
									-- if not bag then return end
									-- -- move to sector stash

									-- Inspect(bag)

									-- AddToSectorInventory(gv_SectorInventory.sector_id, bag)
									-- InventoryUIResetSectorStash(gv_SectorInventory.sector_id)
									-- InventoryUIResetSquadBag()
									-- InventoryUIRespawn()
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "SelectAll",
									'ActionName', T(502338221981, --[[XTemplate Inventory ActionName]] "SELECT ALL"),
									'ActionShortcut', "S",
									'ActionGamepad', "LeftTrigger-ButtonX",
									'ActionState', function(self, host)
									-- return "hidden"
									return gv_SatelliteView and host.context.container and
										host.context.container:GetItem() and
										"enabled" or "hidden"
								end,
									'OnAction', function(self, host, source, ...)
									local ctn = host.context.container
									InventoryClosePopup()
									local itm, iwnd = next(host.selected_items)
									host:DeselectMultiItems()
									local cont_slot = false
									ctn:ForEachItem(function(item, sn, l, t, cont_slot)
										if not cont_slot then
											for slot, val in pairs(host.slots) do
												local wnd, itm = slot:FindItemWnd(item)
												if wnd then
													host.selected_items[item] = wnd
													wnd:SetRollover(true)
													wnd:OnSetSelected(true)
													wnd:OnSetRollover(true)
													cont_slot = slot
												end
											end
										else
											local wnd, itm            = cont_slot:FindItemWnd(item)
											host.selected_items[item] = wnd
											wnd:SetRollover(true)
											wnd:OnSetSelected(true)
											wnd:OnSetRollover(true)
										end
									end, cont_slot)
								end,
								}),
							}),
						}),
						PlaceObj('XTemplateMode', {
							'mode', "ammo",
						}, {
							PlaceObj('XTemplateWindow', {
								'comment', "ammo",
								'__class', "XContextWindow",
							}, {
								PlaceObj('XTemplateWindow', {
									'__class', "XFrame",
									'IdNode', false,
									'Image', "UI/Inventory/T_Backpack_Inventory_Container",
								}, {
									PlaceObj('XTemplateTemplate', {
										'__template', "InventoryScrollArea",
										'Id', "idScrollAreaCenter",
										'Margins', box(0, 20, 0, 65),
										'VScroll', "idScrollbarCenter",
										'ScaleModifier', point(800, 800),
									}, {
										PlaceObj('XTemplateWindow', {
											'__context', function(parent, context)
											return context and context.unit and
												context.unit.Squad and GetSquadBagInventory(context.unit.Squad, "small")
										end,
											'__class', "XContentTemplate",
											'Id', "idSquadBag",
											'Margins', box(24, 0, 24, 0),
											'LayoutMethod', "VList",
											'RespawnOnContext', false,
										}, {
											PlaceObj('XTemplateWindow', {
												'comment', "just to save space",
												'Visible', false,
											}, {
												PlaceObj('XTemplateWindow', {
													'__condition', function(parent, context) return context end,
													'__class', "XText",
													'Id', "idName",
													'Padding', box(6, 2, 2, 2),
													'TextStyle', "InventoryBackpackTitle",
													'Translate', true,
													'Text', T(884569480073, --[[XTemplate Inventory Text]] "BAG"),
													'TextVAlign', "center",
												}),
											}),
											PlaceObj('XTemplateWindow', {
												'__condition', function(parent, context) return context end,
												'__class', "BrowseInventorySlot",
												'Id', "idInventorySlot",
												'HAlign', "left",
												'UniformColumnWidth', true,
												'UniformRowHeight', false,
												'slot_name', "Inventory",
											}, {
												PlaceObj('XTemplateFunc', {
													'name', "Open",
													'func', function(self, ...)
													BrowseInventorySlot.Open(self, ...)
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
										'__class', "XZuluScroll",
										'Id', "idScrollbarCenter",
										'Margins', box(0, 30, 10, 65),
										'HAlign', "right",
										'MouseCursor', "UI/Cursors/Hand.tga",
										'Target', "idScrollAreaCenter",
										'Max', 9999,
										'AutoHide', true,
									}),
									PlaceObj('XTemplateWindow', {
										'ZOrder', 2,
										'Margins', box(0, 0, 0, 20),
										'VAlign', "bottom",
										'DrawOnTop', true,
									}, {
										PlaceObj('XTemplateTemplate', {
											'comment', "loot",
											'__condition', function(parent, context)
											local host = GetActionsHost(parent, true)
											local context = host:GetContext()
											return context.container
										end,
											'__template', "InventoryActionBarButtonCenter",
											'HAlign', "left",
											'VAlign', "bottom",
											'MinWidth', 240,
											'MaxHeight', 240,
											'OnPressEffect', "action",
											'OnPressParam', "Loot",
										}),
										PlaceObj('XTemplateFunc', {
											'name', "IsDropTarget(self, draw_win, pt)",
											'func', function(self, draw_win, pt)
											return true
										end,
										}),
										PlaceObj('XTemplateFunc', {
											'name', "OnDropEnter(self, draw_win, pt, drag_source)",
											'func', function(self, draw_win, pt, drag_source)
											self:SetRollover(true)
										end,
										}),
										PlaceObj('XTemplateFunc', {
											'name', "OnDropLeave(self, drag_win)",
											'func', function(self, drag_win)
											self:SetRollover(false)
										end,
										}),
										PlaceObj('XTemplateFunc', {
											'name', "OnDrop(self, drag_win, pt, drag_source_win)",
											'func', function(self, drag_win, pt, drag_source_win)
											local dlg = GetDialog(self)
											--dlg:SetMode("ammo")
											dlg:ChangeContainerMode("loot")
											return "not valid target"
										end,
										}),
										PlaceObj('XTemplateWindow', {
											'__class', "XText",
											'Id', "idWarningText",
											'Margins', box(0, 0, 0, 40),
											'HAlign', "center",
											'VAlign', "bottom",
											'Visible', false,
											'FoldWhenHidden', true,
											'TextStyle', "InventoryActionsTextRedBig",
											'Translate', true,
											'Text', T(535760316543, --[[XTemplate Inventory Text]] "Inventory is full"),
											'HideOnEmpty', true,
										}),
										PlaceObj('XTemplateTemplate', {
											'comment', "take loot",
											'__condition', function(parent, context)
											local host = GetActionsHost(parent, true)
											local context = host:GetContext()
											return context.container and InventoryIsValidTargetForUnit(context.container)
										end,
											'__template', "InventoryActionBarButtonCenter",
											'HAlign', "right",
											'VAlign', "bottom",
											'MinWidth', 240,
											'MaxHeight', 240,
											'OnPressEffect', "action",
											'OnPressParam', "TakeLoot",
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "Press(self, alt, force, gamepad)",
												'func', function(self, alt, force, gamepad)
												local dlg = GetDialog(self)
												dlg:TakeAllStateWarning(self)
												XTextButton.Press(self, alt, force, gamepad)
											end,
											}),
										}),
									}),
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "Loot",
									'ActionName', T(672375550834, --[[XTemplate Inventory ActionName]] "Show Loot"),
									'ActionToolbar', "ActionBarCenter",
									'ActionShortcut', "L",
									'ActionState', function(self, host)
									local context = host:GetContext()
									if not context.container then
										return "hidden"
									end

									return "enabled"
								end,
									'OnAction', function(self, host, source, ...)
									-- temporaly remove attached obj when change ammo and loot
									--host:OnEscape()
									--host:local dlg = GetDialog(self)
									--dlg:SetMode("ammo")
									host:ChangeContainerMode("loot")
								end,
								}),
								PlaceObj('XTemplateAction', {
									'ActionId', "TakeLoot",
									'ActionName', T(166438187352, --[[XTemplate Inventory ActionName]] "Take Loot"),
									'ActionToolbar', "ActionBarCenter",
									'ActionShortcut', "T",
									'ActionGamepad', "LeftTrigger-ButtonY",
									'ActionState', function(self, host)
									return host:TakeAllState()
								end,
									'OnAction', function(self, host, source, ...)
									host:SetMode("loot")
									return host:TakeAllAction()
								end,
								}),
							}),
						}),
					}),
				}),
				PlaceObj('XTemplateWindow', {
					'comment', "right - backpacks",
					'Margins', box(-600, 18, 32, 32),
					'HAlign', "right",
					'LayoutMethod', "VList",
				}, {
					PlaceObj('XTemplateWindow', {
						'__class', "XText",
						'Padding', box(0, 0, 0, 0),
						'HAlign', "center",
						'TextStyle', "InventoryContainerTitle",
						'Translate', true,
						'Text', T(481179361219, --[[XTemplate Inventory Text]] "Squad Backpacks"),
					}),
					PlaceObj('XTemplateWindow', {
						'comment', "right",
						'__class', "XContentTemplate",
						'Id', "idRight",
						'IdNode', false,
						'Margins', box(0, 20, 0, 0),
						'MinWidth', 580,
						'MinHeight', 752,
						'MaxWidth', 580,
						'MaxHeight', 752,
						'Clip', "parent & self",
						'RespawnOnContext', false,
					}, {
						PlaceObj('XTemplateWindow', {
							'__class', "XImage",
							'IdNode', false,
							'Image', "UI/Inventory/T_Backpack_Inventory_Container",
							'ImageFit', "stretch",
						}),
						PlaceObj('XTemplateTemplate', {
							'comment', "inventory list",
							'__template', "InventoryScrollArea",
							'Id', "idScrollArea",
							'IdNode', false,
							'Margins', box(0, 20, 0, 30),
							'VScroll', "idScrollbar",
							'ScaleModifier', point(800, 800),
						}, {
							PlaceObj('XTemplateMode', {
								'mode', "loot",
							}, {
								PlaceObj('XTemplateWindow', {
									'__context', function(parent, context)
									return context and context.unit and
										context.unit.Squad and GetSquadBagInventory(context.unit.Squad, "large")
								end,
									'__class', "XContentTemplate",
									'Id', "idSquadBag",
									'LayoutMethod', "VList",
									'RespawnOnContext', false,
									'Margins', box(0, 0, 0, 10),
								}, {
									PlaceObj('XTemplateWindow', {
										'Margins', box(26, 0, 0, 0),
									}, {
										PlaceObj('XTemplateWindow', {
											'__condition', function(parent, context) return context end,
											'__class', "XText",
											'Id', "idName",
											'HandleMouse', false,
											'TextStyle', "InventoryBackpackTitle",
											'Translate', true,
											'Text', T(447637689417, --[[XTemplate Inventory Text]] "Squad Supplies"),
											'TextVAlign', "center",
											'OnLayoutComplete', function(self)
											local bag = self.context
											self:SetText(T(7675803685470817,
												"Squad Supplies <GetSquadBagWeightInKg()> Kg", bag))
										end
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "SetHightlighted(self, show)",
												'func', function(self, show)
												self:SetTextStyle(not show and "InventoryBackpackTitle" or
													"InventoryBackpackTitleHighlight")
											end,
											}),
										}),
									}),
									PlaceObj('XTemplateWindow', {
										'__condition', function(parent, context) return context end,
										'__class', "BrowseInventorySlot",
										'Id', "idInventorySlot",
										'Margins', box(24, 0, 0, 0),
										'HAlign', "left",
										'UniformColumnWidth', true,
										'UniformRowHeight', false,
										'slot_name', "Inventory",
									}, {
										PlaceObj('XTemplateFunc', {
											'name', "Open",
											'func', function(self, ...)
											BrowseInventorySlot.Open(self, ...)
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
							PlaceObj('XTemplateForEach', {
								'array', function(parent, context)
								local squadUnits = context and context.unit and context.unit.Squad and
									gv_Squads[context.unit.Squad].units
								local unitsWithoutContextUnit = {}
								for _, unitId in ipairs(squadUnits) do
									if unitId ~= context.unit.session_id then
										table.insert(unitsWithoutContextUnit, unitId)
									end
								end
								return unitsWithoutContextUnit
							end,
								'condition', function(parent, context, item, i) return context end,
								'__context', function(parent, context, item, i, n)
								if not item then return false end
								local unit
								if gv_SatelliteView then
									unit = gv_UnitData[item]
								else
									unit = g_Units[item] or
										gv_UnitData[item]
								end
								return unit
							end,
								'run_after', function(child, context, item, i, n, last)
								child.unit = context
								if InventoryUIGrayOut(context) then
									child:SetTransparency(150)
								end
							end,
							}, {
								PlaceObj('XTemplateWindow', {
									'__class', "XContentTemplate",
									'LayoutMethod', "VList",
									'RespawnOnContext', false,
									'Margins', box(0, 0, 0, 10),
								}, {
									PlaceObj('XTemplateCode', {
										'run', function(self, parent, context)
										if InventoryIsNotControlled(context) then
											parent.RespawnOnContext = true
										end
									end,
									}),
									PlaceObj('XTemplateWindow', {
										'Margins', box(26, 0, 0, 0),
									}, {
										PlaceObj('XTemplateWindow', {
											'__condition', function(parent, context) return context end,
											'__class', "XText",
											'Id', "idName",
											'HandleMouse', false,
											'TextStyle', "InventoryBackpackTitle",
											'Translate', true,
											'Text', T(971957775453, --[[XTemplate Inventory Text]] "<Nick> BACKPACK"),
											'TextVAlign', "center",
											'OnLayoutComplete', function(self)
											local unit = self.context
											if not REV_IsMerc(unit) then
												return
											end
											self:SetText(T(3269654860290817,
												"<Nick> EQUIPMENT <GetCurrentWeightInKg()>/<GetMaxWeightInKg()> Kg", unit))
										end
										}, {
											PlaceObj('XTemplateFunc', {
												'name', "SetHightlighted(self, show)",
												'func', function(self, show)
												local dlg = GetDialog(self)
												local show = show or
													dlg.selected_unit.session_id == self:GetContext().session_id
												self:SetTextStyle(not show and "InventoryBackpackTitle" or
													"InventoryBackpackTitleHighlight")
											end,
											}),
										}),
									}),
									PlaceObj('XTemplateWindow', {
										'__condition', function(parent, context) return context end,
										'__class', "BrowseInventorySlot",
										'Id', "idInventorySlot",
										'Margins', box(24, 0, 0, 0),
										'HAlign', "left",
										'UniformColumnWidth', true,
										'UniformRowHeight', false,
										'slot_name', "Inventory",
									}, {
										PlaceObj('XTemplateFunc', {
											'name', "Open",
											'func', function(self, ...)
											BrowseInventorySlot.Open(self, ...)
											local dlg = GetDialog(self)
											dlg.slots[self] = true
											if dlg.context.unit and self.context.session_id == dlg.context.unit.session_id then
												self.parent.idName:SetHightlighted(true)
											end
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
							})
						}),
						PlaceObj('XTemplateWindow', {
							'__class', "XZuluScroll",
							'Id', "idScrollbar",
							'Margins', box(0, 30, 10, 20),
							'HAlign', "right",
							'FoldWhenHidden', false,
							'MouseCursor', "UI/Cursors/Hand.tga",
							'Target', "idScrollArea",
							'Max', 9999,
							'AutoHide', true,
						}, {
							PlaceObj('XTemplateFunc', {
								'name', "MoveThumb",
								'func', function(self, ...)
								XZuluScroll.MoveThumb(self, ...)
								if not self.layout_update then
									Msg("ScrollInventory")
								end
							end,
							}),
						}),
					}),
				}),
				PlaceObj('XTemplateWindow', {
					'Id', "idCompare",
					'Dock', "box",
					'HAlign', "left",
					'MinWidth', 855,
				}, {
					PlaceObj('XTemplateFunc', {
						'name', "SetOutsideScale(self, scale)",
						'func', function(self, scale)
						-- The inventory has some custom scale active. In order to have the fake
						-- comparison rollovers which are spawned inside this window scale like
						-- the normal rollovers, we need to override the scale here.

						XWindow.SetOutsideScale(self, terminal.desktop.scale)
					end,
					}),
					PlaceObj('XTemplateFunc', {
						'name', "SetLayoutSpace(self, x, y, width, height)",
						'func', function(self, x, y, width, height)
						-- We want the margins to scale in "inventory scale"

						local dlg = self:ResolveId("node")
						local dlgScale = dlg.scale

						local xMarg, yMarg = ScaleXY(dlgScale, 100, 110)
						x = x + xMarg
						y = y + yMarg

						XWindow.SetLayoutSpace(self, x, y, width, height)
					end,
					}),
				}),
			}),
			PlaceObj('XTemplateWindow', {
				'Id', "idInventoryLegend",
				"Margins",
				box(26, 4, 0, 18),
				'IdNode', true,
				'LayoutMethod', "HList",
				'VAlign', "bottom",
				'HAlign', "center",
				'LayoutHSpacing', 12,
			}, {
				PlaceObj("XTemplateForEach", {
					"__context",
					function(parent, context, item, i, n)
						return item
					end,
					"array",
					function(parent, context)
						return g_REV_InventoryEquipSlots
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
			}),
			PlaceObj('XTemplateTemplate', {
				'__template', "InventoryActionBar",
				'ZOrder', 2,
				'Margins', box(0, 0, 50, 10),
				'MarginPolicy', "FitInSafeArea",
				'Dock', "box",
				'VAlign', "bottom",
				'FoldWhenHidden', true,
				'DrawOnTop', true,
				'ToolbarName', "InventoryActionBar",
			}),
		}),
	})


	local inventory_dialog = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["Inventory"], "Id",
		"idDlgContent")

	if inventory_dialog then
		local element = inventory_dialog.element

		element[1].MinWidth = 1700
		element[1].MaxWidth = 1700
		element[1].DrawOnTop = true
		element[1].LayoutMethod = "HWrap"
	end
end
