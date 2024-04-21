function OnMsg.BeginTurn(unit)
	if unit:HasStatusEffect("Overweight") then
		unit:ConsumeAP(Min(unit.ActionPoints, -1 * const.Scale.AP))
		unit:RemoveStatusEffect("FreeMove")
	end
end

function UnitData:GetMaxWeight()
	return self.Strength * 500
end

function Unit:GetMaxWeight()
	return self.Strength * 500
end

function Unit:GetCurrentWeightInKg()
  return DivRound(self:GetCurrentWeight(), 10) / 100.00
end

function Unit:GetMaxWeightInKg()
	return DivRound(self:GetMaxWeight(), 10) / 100.00
end

function UnitData:GetMaxWeightInKg()
	return DivRound(self:GetMaxWeight(), 10) / 100.00
end

function UnitData:GetCurrentWeightInKg()
	return DivRound(self:GetCurrentWeight(), 10) / 100.00
end

function Unit:GetCurrentWeight()
	local squad = gv_Squads[self.Squad]
	if not squad then return 0 end
	local total_weight = { weight = 0.0 }
	self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
		local item_amount = slot_item.Amount or 1
		local item_weight = slot_item.Weight or 100
		if IsKindOf(slot_item, "Ammo") then
			item_weight = REV_BulletWeight(slot_item)
		elseif IsKindOf(slot_item, "Armor") then
			if slot_item.FrontPlate then item_weight = item_weight + slot_item.FrontPlate.Weight end
			if slot_item.BackPlate then item_weight = item_weight + slot_item.BackPlate.Weight end
		elseif IsKindOf(slot_item, "Mag") and slot_item.ammo then
			item_amount = slot_item.ammo.Amount
			item_weight = REV_BulletWeight(slot_item.ammo)
		end
		total_weight.weight = total_weight.weight + item_amount * item_weight
	end, total_weight)
	return total_weight.weight + (gv_SquadBag and (gv_SquadBag:GetSquadBagWeight() / #squad.units)) or 0
end

function UnitData:GetCurrentWeight()
	local squad = gv_Squads[self.Squad]
	if not squad then return 0 end
	local total_weight = { weight = 0.0 }
	self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
		local item_amount = slot_item.Amount or 1
		local item_weight = slot_item.Weight or 100
		if IsKindOf(slot_item, "Ammo") then
			item_weight = REV_BulletWeight(slot_item)
		elseif IsKindOf(slot_item, "Mag") and slot_item.ammo then
			item_amount = slot_item.ammo.Amount
			item_weight = REV_BulletWeight(slot_item.ammo)
		end
		total_weight.weight = total_weight.weight + item_amount * item_weight
	end, total_weight)
	return total_weight.weight + (gv_SquadBag and (gv_SquadBag:GetSquadBagWeight() / #squad.units)) or 0
end

function REV_ApplyWeightEffects(unit)
	if not REV_IsMerc(unit) then return end
	local current_weight = unit:GetCurrentWeight()
	local max_weight = unit:GetMaxWeight()
	if current_weight > max_weight then
		unit:AddStatusEffect("Overweight")
	else
		unit:RemoveStatusEffect("Overweight")
	end
	InventoryUIRespawn()
end

function SquadBag:GetSquadBagWeight()
	local total_weight = { weight = 0.0 }
	if not RevisedLBEConfig.SquadBagHasWeight or not self then return 0 end
	self:ForEachItem(function(slot_item, slot_name, left, top, total_weight)
		local item_amount = slot_item.Amount or 1
		local item_weight = slot_item.Weight or 100
		if IsKindOf(slot_item, "Ammo") then
			item_weight = REV_BulletWeight(slot_item)
		elseif IsKindOf(slot_item, "Mag") and slot_item.ammo then
			item_amount = slot_item.ammo.Amount
			item_weight = REV_BulletWeight(slot_item.ammo)
		elseif IsKindOf(slot_item, "Parts") then
			item_weight = 20
		end
		total_weight.weight = total_weight.weight + item_amount * item_weight
	end, total_weight)
	return total_weight.weight
end

function SquadBag:GetSquadBagWeightInKg()
	return DivRound(self:GetSquadBagWeight(), 10) / 100.00
end

function REV_GetSquadBagWeightInKg()
	return gv_SquadBag:GetSquadBagWeightInKg()
end

function REV_BulletWeight(item)
	return (Presets.Caliber[1][item.Caliber].Weight or 10) * 2
end
