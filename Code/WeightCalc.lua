function UnitData:GetMaxWeight()
    return self.Strength * 0.5
end

function Unit:GetMaxWeight()
    return self.Strength * 0.5
end

function Unit:GetCurrentWeight()
    local squad
    for i, s in ipairs(GetPlayerMercSquads()) do
        if s.UniqueId == self.Squad then squad = s end
    end
    local total_weight = {weight=0.0}
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 0.1
        if IsKindOf(slot_item, "Ammo") then
            item_weight = BulletWeight(slot_item)
        elseif IsKindOf(slot_item, "Armor") then
            if slot_item.FrontPlate then item_weight = item_weight + slot_item.FrontPlate.Weight end
            if slot_item.BackPlate then item_weight = item_weight + slot_item.BackPlate.Weight end
        elseif  IsKindOf(slot_item, "Mag") and slot_item.ammo then
            item_amount = slot_item.ammo.Amount
            item_weight = BulletWeight(slot_item.ammo)
        end
        total_weight.weight = total_weight.weight + item_amount * item_weight
    end, total_weight)
    return round((total_weight.weight + (gv_SquadBag:GetSquadBagWeight()/ #squad.units))*10, 1)/10.0
end

function UnitData:GetCurrentWeight()
    local squad
    for i, s in ipairs(GetPlayerMercSquads()) do
        if s.UniqueId == self.Squad then squad = s end
    end
    local total_weight = {weight=0.0}
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 0.1
        if IsKindOf(slot_item, "Ammo") then
            item_weight = BulletWeight(slot_item)
        elseif  IsKindOf(slot_item, "Mag") and slot_item.ammo then
            item_amount = slot_item.ammo.Amount
            item_weight = BulletWeight(slot_item.ammo)
        end
        total_weight.weight = total_weight.weight + item_amount * item_weight
    end, total_weight)
    return round((total_weight.weight + (gv_SquadBag:GetSquadBagWeight()/ #squad.units))*10, 1)/10.0
end

function Unit:ApplyWeightEffects()
    local current_weight = self:GetCurrentWeight()
    local max_weight = self.GetMaxtWeight()

    if current_weight>max_weight then
        self:AddStatusEffect("Overweight")
    else 
        self:RemoveStatusEffect("Overweight")
    end
     InventoryUIRespawn()
end

function OnMsg.BeginTurn(unit)
    if unit:HasStatusEffect("Overweight") then
        unit:ConsumeAP(Min(unit.ActionPoints, -1 * const.Scale.AP))
        unit:RemoveStatusEffect("FreeMove")
    end
end

function SquadBag:GetSquadBagWeight()
    local total_weight = {weight=0.0}
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 0.1
        if IsKindOf(slot_item, "Ammo") then
            item_weight = BulletWeight(slot_item)
        elseif  IsKindOf(slot_item, "Mag") and slot_item.ammo then
            item_amount = slot_item.ammo.Amount
            item_weight = BulletWeight(slot_item.ammo)
        elseif IsKindOf(slot_item, "Parts") then
            item_weight = 0.02
        end
        total_weight.weight = total_weight.weight + item_amount * item_weight
    end, total_weight)
    return round(total_weight.weight*10,1)/10.0
end

function BulletWeight(item)
    return (Presets.Caliber[1][item.Caliber].Weight or 0.01) * 2
end