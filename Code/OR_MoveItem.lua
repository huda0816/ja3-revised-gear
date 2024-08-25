local REV_Original_GetAPCostAndUnit = GetAPCostAndUnit

function GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name,
						  item_at_dest, is_reload, dest_x, dest_y)
	if not REV_IsMerc(src_container) and not REV_IsMerc(dest_container) then
		return REV_Original_GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container,
			dest_container_slot_name, item_at_dest, is_reload)
	end
	if is_reload then
		return REV_Original_GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container,
			dest_container_slot_name, item_at_dest, is_reload)
	end
	if not is_reload and not dest_container:CheckClass(item, dest_container_slot_name) then
		return 0, GetInventoryUnit()
	end
	local ap                   = 0
	local unit                 = false
	local action_name          = false
	local costs                = const["Action Point Costs"]

	--this tries to deduce action cost and combat action executing unit, cpy pasted it from somewhere, its prty obtuse, but seems to work
	local are_diff_containers  = src_container ~= dest_container
	local is_src_bag           = IsKindOf(src_container, "SquadBag")
	local is_dest_bag          = IsKindOf(dest_container, "SquadBag")
	local is_src_unit          = IsKindOfClasses(src_container, "Unit", "UnitData")
	local is_dest_unit         = IsKindOfClasses(dest_container, "Unit", "UnitData")
	local is_src_dead          = is_src_unit and src_container:IsDead()
	local is_dest_dead         = is_dest_unit and dest_container:IsDead()
	-- custom code
	local src_context          = is_src_unit and item and REV_IsMerc(src_container) and
		REV_GetItemSlotContext(src_container, item)
	local dest_context         = is_dest_unit and item and REV_IsMerc(dest_container) and
		REV_GetItemSlotContext(dest_container, item_at_dest, dest_x, dest_y)
	local is_src_Backpack      = src_context == "Backpack"
	local is_dest_Backpack     = dest_context == "Backpack"
	local is_src_LBE           = src_context == "LBE"
	local is_dest_LBE          = dest_context == "LBE"
	local is_src_Inventory     = src_context == "Inventory"
	local is_dest_Inventory    = dest_context == "Inventory"
	local src_slot_type        = REV_GetItemSlotType(item)
	local dest_slot_type       = item_at_dest and REV_GetItemSlotType(item_at_dest)
	local is_src_Holster       = src_slot_type == "PistolHolster" or src_slot_type == "SmgHolster"
	local is_dest_Holster 	   = dest_slot_type == "PistolHolster" or dest_slot_type == "SmgHolster"
	local is_src_KnifeSheath   = src_slot_type == "KnifeSheath"
	local is_dest_KnifeSheath  = dest_slot_type == "KnifeSheath"
	-- end custom code
	local between_bag_and_unit = (is_src_bag and is_dest_unit and not is_src_dead or is_dest_bag and is_src_unit and not is_src_dead)
	local is_refill, is_combine
	is_refill                  = IsMedicineRefill(item, item_at_dest)
	is_combine                 = not (is_dest_dead or IsKindOf(dest_container, "ItemContainer")) and
		InventoryIsCombineTarget(item, item_at_dest)

	if is_src_KnifeSheath and not are_diff_containers and IsEquipSlot(dest_container_slot_name) then
		return 0, src_container, FormatGiveActionText(T(2656223142290919, "Draw from sheath"), dest_container)
	end

	if item_at_dest and is_dest_KnifeSheath and not are_diff_containers and IsEquipSlot(src_container_slot_name) then
		return 0, src_container, FormatGiveActionText(T(2656223142290921, "Sheath knife"), dest_container)
	end

	if is_src_Holster and not are_diff_containers and IsEquipSlot(dest_container_slot_name) then
		return 0, src_container, FormatGiveActionText(T(2656223142290918, "Draw from holster"), dest_container)
	end

	if item_at_dest and not are_diff_containers and IsEquipSlot(src_container_slot_name) and is_dest_Holster then
		return 0, src_container, FormatGiveActionText(T(2656223142290920, "Swap weapon in holster"), dest_container)
	end

	if is_src_Backpack and not is_dest_Backpack then
		-- from backpack to container
		ap = item:GetEquipCost() * 2
		unit = src_container
		action_name = FormatGiveActionText(T(2656223142290817, "Get from backpack"), src_container)
	elseif not is_src_Backpack and is_dest_Backpack then
		-- from container to backpack
		ap = item:GetEquipCost() * 2
		unit = dest_container
		action_name = FormatGiveActionText(T(2656223142290818, "Put in backpack"), dest_container)
	end

	if are_diff_containers and is_dest_bag and (not is_src_unit or is_src_dead) then
		-- from dead unit or container->squad bag
		ap = ap + costs.PickItem
		unit = GetInventoryUnit()
		action_name = T(273687388621, "Put in squad supplies")
	end

	if are_diff_containers and not between_bag_and_unit then
		if (not is_src_unit or is_src_dead) and is_dest_unit and not is_dest_dead then
			--loot/dead unit/container => unit inv?
			ap = ap + costs.PickItem
			unit = dest_container
			action_name = FormatGiveActionText(T(265622314229, "Put in backpack"), dest_container)
		elseif is_src_unit and is_dest_unit and not is_src_dead and not is_dest_dead then
			--unit => other unit?
			-- if not IsKindOf(item, "SquadBagItem") then -- squadbagitems are NOT for free
			ap = ap + costs.GiveItem
			unit = src_container
			action_name = FormatGiveActionText(T { 386181237071, "Give to <merc>", merc = dest_container.Nick },
				dest_container)
			-- end
		end
	end
	if is_refill then
		return 0, unit or GetInventoryUnit(), T(479821153570, "Refill")
	end
	if is_combine then
		return 0, unit or GetInventoryUnit(), T(426883432738, "Combine")
	end
	if is_reload then
		local dest_unit = dest_container
		if IsKindOf(dest_unit, "UnitData") then
			dest_unit = g_Units[dest_unit.session_id]
		end
		local inv_unit = GetInventoryUnit()
		unit = IsKindOf(dest_unit, "Unit") and not dest_unit:IsDead() and dest_unit or
			inv_unit --user can be reloading in container, hence dest_unit can be a container
		local action = CombatActions["Reload"]
		local pos = dest_container:GetItemPackedPos(item_at_dest)
		ap = ap + action:GetAPCost(unit, { weapon = item_at_dest.class, pos = pos }) or 0
		action_name = T(160472488023, "Reload")
	elseif IsEquipSlot(dest_container_slot_name) then
		-- does not charge if move between equip slots of the same unit but charge if between weapon sets
		if (IsEquipSlot(src_container_slot_name) and src_container_slot_name == dest_container_slot_name) or not IsEquipSlot(src_container_slot_name) or src_container ~= dest_container then
			local extraAP = item:GetEquipCost()
			if is_src_LBE then
				extraAP = MulDivRound(extraAP, 33, 100)
			elseif is_src_Inventory then
				extraAP = MulDivRound(extraAP, 66, 100)
			elseif is_src_Backpack then
				extraAP = 0
			end
			ap = ap + extraAP
			unit = dest_container
			action_name = T(622693158009, "Equip")
		end
	elseif item_at_dest and IsEquipSlot(src_container_slot_name) then
		-- does not charge if move between equip slots of the same unit but charge if between weapon sets
		if not (src_container == dest_container and IsEquipSlot(src_container_slot_name) and src_container_slot_name == dest_container_slot_name) then
			local extraAP = item:GetEquipCost()
			if is_src_LBE then
				extraAP = MulDivRound(extraAP, 33, 100)
			elseif is_src_Inventory then
				extraAP = MulDivRound(extraAP, 66, 100)
			elseif is_src_Backpack then
				extraAP = 0
			end
			ap = ap + extraAP
			unit = src_container
			action_name = T(622693158009, "Equip")
		end
	end

	if not unit and is_src_unit and IsKindOf(dest_container, "LocalDropContainer") then
		unit = src_container --drop at src_container unit feet
		action_name = T(778324934848, "Drop")
	end

	unit = is_src_unit and src_container or unit

	return ap, unit, action_name
end
