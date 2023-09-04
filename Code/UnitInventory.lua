
  function OnMsg.InventoryChange(unit)
    if IsMerc(unit) then
      CheckItemsInWrongSlots(unit)
    end

  end

  function CheckItemsInWrongSlots(unit)
    local slot_types = CreateSlotTypes(unit)
    local slot_name = "Inventory"
    local container = GetDropContainer(unit)
    unit:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top)
        if slot_types[left][top] then
            if not ItemFitsTile(slot_item, slot_types[left][top]) then
                unit:RemoveItem(slot_name, slot_item)
                if not container:AddItem("Inventory", slot_item) then
                  container = PlaceObject("ItemDropContainer")
                  local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
                  container:SetPos(drop_pos or unit:GetPos())
                  container:SetAngle(container:Random(21600))
                  container:AddItem("Inventory", slot_item)
                end
            end
        else
            unit:RemoveItem(slot_name, slot_item)
            if not container:AddItem("Inventory", slot_item) then
              container = PlaceObject("ItemDropContainer")
              local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
              container:SetPos(drop_pos or unit:GetPos())
              container:SetAngle(container:Random(21600))
              container:AddItem("Inventory", slot_item)
            end
        end
      end)
  end