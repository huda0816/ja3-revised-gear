function OnMsg.UnitCreated(unit)
    if IsMerc(unit) then
      unit:CreateSlotTypes()
    end
  end
  
  function OnMsg.InventoryChange(unit)
    if IsMerc(unit) then
      unit:CreateSlotTypes()
      unit:CheckItemsInWrongSlots()
    end

  end

  function Unit:CheckItemsInWrongSlots()
    local slot_types = self.inventory_slots["Inventory"].slot_types
    local slot_name = "Inventory"
    local container = GetDropContainer(self)
    self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top)
        if slot_types[left][top] then
            if not ItemFitsTile(slot_item,slot_types[left][top]) then
                self:RemoveItem(slot_name, slot_item)
                if not container:AddItem("Inventory", slot_item) then
                  container = PlaceObject("ItemDropContainer")
                  local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
                  container:SetPos(drop_pos or self:GetPos())
                  container:SetAngle(container:Random(21600))
                  container:AddItem("Inventory", slot_item)
                end
            end
        else
            self:RemoveItem(slot_name, slot_item)
            if not container:AddItem("Inventory", slot_item) then
              container = PlaceObject("ItemDropContainer")
              local drop_pos = terrain.FindPassable(container, 0, const.SlabSizeX / 2)
              container:SetPos(drop_pos or self:GetPos())
              container:SetAngle(container:Random(21600))
              container:AddItem("Inventory", slot_item)
            end
        end
      end)
  end