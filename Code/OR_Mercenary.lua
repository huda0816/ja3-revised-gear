function AddItemsToInventory(inventoryObj, items, bLog)
	local pos, reason
	for i = #items, 1, -1 do
		local item = items[i]
		if IsKindOf(item, "InventoryStack") then
			inventoryObj:ForEachItemDef(item.class,
				function(curitm, slot_name, item_left, item_top)
					if slot_name ~= "Inventory" then return end

					if curitm.Amount < curitm.MaxStacks then
						local to_add = Min(curitm.MaxStacks - curitm.Amount, item.Amount)
						curitm.Amount = curitm.Amount + to_add
						curitm.drop_chance = Max(curitm.drop_chance, item.drop_chance)
						if bLog then
							Msg("InventoryAddItem", inventoryObj, curitm, to_add)
						end
						item.Amount = item.Amount - to_add
						if item.Amount <= 0 then
							DoneObject(item)
							item = false
							table.remove(items, i)
							return "break"
						end
					end
				end)
		end
		if item then
			pos, reason = inventoryObj:AddItem("Inventory", item)
			if pos then
				if bLog then
					Msg("InventoryAddItem", inventoryObj, item, IsKindOf(item, "InventoryStack") and item.Amount or 1)
				end
				table.remove(items, i)
			else
				local container = inventoryObj

				if not inventoryObj or not inventoryObj:AddItem("Inventory", item) then
					if gv_SatelliteView and gv_SectorInventory then
						container = gv_SectorInventory
					else
						container = PlaceObject("ItemDropContainer")
						local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
						container:SetPos(drop_pos or inventoryObj and inventoryObj:GetPos())
						container:SetAngle(container:Random(21600))
					end

					container:AddItem("Inventory", item)
				end
			end
		else
			pos = true
		end
	end
	ObjModified(inventoryObj)
	return pos, reason
end

function UnitInventory:AddItem(slot_name, item, left, top, local_execution)
	local pos, reason = Inventory.AddItem(self, slot_name, item, left, top)
	if not pos then return pos, reason end

	item.owner = REV_IsMerc(self) and self.session_id or false -- Dont bloat save with non-merc owners.
	if not local_execution then
		Msg("ItemAdded", self, item, slot_name, pos)
	end
	item:OnAdd(self, slot_name, pos, item)

	return pos, reason
end
