
function UnitProperties:GetInventoryMaxSlots()
    local inventorySlots = 6
    if IsMerc(self) then 
        local LBE = self:GetItemInSlot("Inventory", nil, 1, 1)
        local Backpack = self:GetItemInSlot("Inventory", nil, 6, 1)
      if IsKindOf(LBE, "LBE") then
        inventorySlots = inventorySlots + LBE.InventorySlots
      end
      if IsKindOf(Backpack, "Backpack") then
        inventorySlots = inventorySlots + Backpack.InventorySlots
      end
    end
    return IsMerc(self) and inventorySlots or self.max_dead_slot_tiles or 20
  end
  
  function OnMsg.InventoryChange()
    for _, unit in pairs(g_Units) do
        if IsMerc(unit) then
            CheckItemsInWrongSlots(unit)
          end
    end
  end

  function CheckItemsInWrongSlots(unit)
    local slot_types = CreateSlotTypes(unit)
    local slot_name = "Inventory"
    local container = GetDropContainer(unit)
    unit:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top)
        if slot_types[left][top] then
            if not ItemFitsTile(slot_item, slot_types[left][top]) then
                print(unit.session_id, "here")
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
            print(unit.session_id, "there")
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