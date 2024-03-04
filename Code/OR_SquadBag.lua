OnMsg.CombatStart = function()
	local inventorySlot = REV_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.Inventory, 'Id', 'idInventorySlot', 'all')

	if inventorySlot then
		for i, slot in ipairs(inventorySlot) do
			if slot and slot.ancestors and slot.ancestors[1].Id == "idSquadBag" then
				Inspect(slot["element"])
				slot.element.enabled = false
				slot.element.handleMouse = false
			end
		end
	end
end




-- function AddItemsToSquadBag(squad_id, items)
-- 	return false	
-- 	-- local bag = GetSquadBag(squad_id)
-- 	-- if not bag then
-- 	-- 	bag = {}
-- 	-- 	gv_Squads[squad_id].squad_bag = bag
-- 	-- end

-- 	-- for i=#items,1, -1 do
-- 	-- 	local item =  items[i]
-- 	-- 	if item:IsKindOf("SquadBagItem") then
-- 	-- 		local count = item.Amount
-- 	-- 		for _, curitm in ipairs(bag) do
-- 	-- 			if curitm and curitm.class==item and IsKindOf(curitm,"InventoryStack") and curitm.Amount < curitm.MaxStacks then
-- 	-- 				local to_add = Min(curitm.MaxStacks - curitm.Amount, count)
-- 	-- 				curitm.Amount = curitm.Amount + to_add
-- 	-- 				count = count - to_add			
-- 	-- 				if to_add > 0 then
-- 	-- 					Msg("SquadBagAddItem", curitm, to_add)
-- 	-- 				end
-- 	-- 				if count<=0 then
-- 	-- 					DoneObject(item)
-- 	-- 					item =  false
-- 	-- 					break
-- 	-- 				end	
-- 	-- 			end
-- 	-- 		end	
-- 	-- 		if count > 0 then
-- 	-- 			table.insert(bag, item)		
-- 	-- 			Msg("SquadBagAddItem", item, count)
-- 	-- 		end
-- 	-- 		table.remove(items, i)
-- 	-- 	end	
-- 	-- end

-- 	-- SortItemsInBag(squad_id)

-- 	-- if gv_SquadBag and gv_SquadBag.squad_id == squad_id then
-- 	-- 	InventoryUIResetSquadBag()
-- 	-- 	gv_SquadBag:SetSquadId(squad_id)
-- 	-- 	InventoryUIRespawn()
-- 	-- end	
-- end

-- function AddItemToSquadBag(squad_id, item_id, count, callback,...)	
-- 	return false
-- 	-- local bag = GetSquadBag(squad_id)
-- 	-- if not bag then
-- 	-- 	bag = {}
-- 	-- 	gv_Squads[squad_id].squad_bag = bag
-- 	-- end

-- 	-- local args = {...}
-- 	-- local count = count
-- 	-- for _, curitm in ipairs(bag) do
-- 	-- 	if curitm and curitm.class==item_id and IsKindOf(curitm,"InventoryStack") and curitm.Amount < curitm.MaxStacks then
-- 	-- 		local to_add = Min(curitm.MaxStacks - curitm.Amount, count)
-- 	-- 		curitm.Amount = curitm.Amount + to_add
-- 	-- 		count = count - to_add			
-- 	-- 		if to_add > 0 then
-- 	-- 			Msg("SquadBagAddItem", curitm, to_add)
-- 	-- 			if callback then callback(squad_id, curitm, to_add,...) end
-- 	-- 		end
-- 	-- 		if count<=0 then
-- 	-- 			break
-- 	-- 		end	
-- 	-- 	end
-- 	-- end	
-- 	-- while count > 0 do
-- 	-- 	local item = PlaceInventoryItem(item_id)
-- 	-- 	if not item:IsKindOf("SquadBagItem") then
-- 	-- 		DoneObject(item)
-- 	-- 		break
-- 	-- 	end

-- 	-- 	local to_add = 1
-- 	-- 	if IsKindOf(item,"InventoryStack") then
-- 	-- 		to_add = Min(item.MaxStacks, count)
-- 	-- 		item.Amount = to_add
-- 	-- 	end
-- 	-- 	table.insert(bag, item)

-- 	-- 	if to_add > 0 then
-- 	-- 		Msg("SquadBagAddItem", item, to_add)
-- 	-- 		if callback then callback(squad_id, item, to_add,...) end
-- 	-- 	end
-- 	-- 	count = count - to_add
-- 	-- end

-- 	-- if gv_SquadBag and gv_SquadBag.squad_id == squad_id then
-- 	-- 	InventoryUIResetSquadBag()
-- 	-- 	gv_SquadBag:SetSquadId(squad_id)
-- 	-- 	InventoryUIRespawn()
-- 	-- end

-- 	-- return count
-- end
