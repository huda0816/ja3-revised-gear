function UnitData:GetMaxWeight()
    return self.Strength * 500
end

function Unit:GetMaxWeight()
    return self.Strength * 500
end

function Unit:GetCurrentWeight()
    if not GetPlayerMercSquads() or not self.Squad then return 0 end
    local squad
    for i, s in ipairs(GetPlayerMercSquads()) do
        if s.UniqueId == self.Squad then squad = s end
    end
    local total_weight = {weight=0.0}
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 100
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
    return round((total_weight.weight + (gv_SquadBag:GetSquadBagWeight()/ #squad.units)), 1)
end

function Unit:GetCurrentWeightInKg()
	return round(self:GetCurrentWeight()/1000, 1)
end

function Unit:GetMaxWeightInKg()
	return round(self:GetMaxWeight()/1000, 1)
end

function UnitData:GetMaxWeightInKg()
	return round(self:GetMaxWeight()/1000, 1)
end

function UnitData:GetCurrentWeightInKg()
	return round(self:GetCurrentWeight()/1000, 1)
end

function UnitData:GetCurrentWeight()
    if not GetPlayerMercSquads() or not self.Squad then return 0 end
    local squad
    for i, s in ipairs(GetPlayerMercSquads()) do
        if s.UniqueId == self.Squad then squad = s end
    end
    local total_weight = {weight=0.0}
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 100
        if IsKindOf(slot_item, "Ammo") then
            item_weight = BulletWeight(slot_item)
        elseif  IsKindOf(slot_item, "Mag") and slot_item.ammo then
            item_amount = slot_item.ammo.Amount
            item_weight = BulletWeight(slot_item.ammo)
        end
        total_weight.weight = total_weight.weight + item_amount * item_weight
    end, total_weight)
    return round((total_weight.weight + (gv_SquadBag:GetSquadBagWeight()/ #squad.units)), 1)
end

function ApplyWeightEffects(unit)
    local current_weight = unit:GetCurrentWeight()
    local max_weight = unit:GetMaxWeight()
    if current_weight>max_weight then
        unit:AddStatusEffect("Overweight")
    else 
        unit:RemoveStatusEffect("Overweight")
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
    if not RevisedLBEConfig.SquadBagHasWeight or not self then return 0 end
    self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
        local item_amount = slot_item.Amount or 1
        local item_weight = slot_item.Weight or 100
        if IsKindOf(slot_item, "Ammo") then
            item_weight = BulletWeight(slot_item)
        elseif  IsKindOf(slot_item, "Mag") and slot_item.ammo then
            item_amount = slot_item.ammo.Amount
            item_weight = BulletWeight(slot_item.ammo)
        elseif IsKindOf(slot_item, "Parts") then
            item_weight = 20
        end
        total_weight.weight = total_weight.weight + item_amount * item_weight
    end, total_weight)
    return round(total_weight.weight,1)
end

function SquadBag:GetSquadBagWeightInKg()
	return round(self:GetSquadBagWeight()/1000, 1)
end

function GetSquadBagWeightInKg()
	return gv_SquadBag:GetSquadBagWeightInKg()
end

function BulletWeight(item)
    return (Presets.Caliber[1][item.Caliber].Weight or 10) * 2
end