function Inventory:ForEachItemInSlot(slot_name, base_class, fn, ...)
    local arg1
    if type(base_class) == "function" then
      arg1 = fn
      fn = base_class
      base_class = false
    end
    local items = self[slot_name]
    if not next(items) then
      return
    end
    local slot_data = self:GetSlotData(slot_name)
    local lbase_class = base_class or slot_data.base_class
    local lcheck_slot_name = slot_data.check_slot_name
    if base_class=="ItemWithCondition" then
        for i = #items, 1, -2 do
            local item, pos = items[i], items[i - 1]
            if not IsKindOfClasses(item, "Mag", "LBE", "Backpack") and item:IsKindOfClasses(lbase_class) and (not lcheck_slot_name or item.Slot == slot_name) then
                local left, top = point_unpack(pos)
                local res
                if arg1 ~= nil then
                res = fn(item, slot_name, left, top, arg1, ...)
                else
                res = fn(item, slot_name, left, top, ...)
                end
                if res == "break" then
                return "break"
                end
            end
        end
    else
        for i = #items, 1, -2 do
            local item, pos = items[i], items[i - 1]
            if item:IsKindOfClasses(lbase_class) and (not lcheck_slot_name or item.Slot == slot_name) then
                local left, top = point_unpack(pos)
                local res
                if arg1 ~= nil then
                res = fn(item, slot_name, left, top, arg1, ...)
                else
                res = fn(item, slot_name, left, top, ...)
                end
                if res == "break" then
                return "break"
                end
            end
        end
    end
  end