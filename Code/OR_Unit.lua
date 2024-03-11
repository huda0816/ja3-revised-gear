function Unit:HasNightVision()
	if HasPerk(self, "NightOps") then
		return true
	end
	local helm = self:GetItemInSlot("Head") or self:GetItemInSlot("NVG")
	return IsKindOf(helm, "NightVisionGoggles") and helm.Condition > 0
end

local REV_Original_GetSightRadius = Unit.GetSightRadius

function Unit:GetSightRadius(other, base_sight, step_pos)
	local sightAmount, hidden, night_time = REV_Original_GetSightRadius(self, other, base_sight, step_pos)

	local faceItem = self:GetItemInSlot("FaceItem")

	local modifier = 100


	if GameState.Fog then
		modifier = modifier + const.EnvEffects.FogSightMod
	end
	if GameState.DustStorm then
		modifier = modifier + const.EnvEffects.DustStormSightMod
	end
	if GameState.FireStorm then
		modifier = modifier + const.EnvEffects.FireStormSightMod
	end

	if not GameState.Underground and faceItem then
		if GameState.DustStorm and faceItem.DustStormModifier then
			modifier = 100 - MulDivRound(const.EnvEffects.DustStormSightMod, faceItem.DustStormModifier, 100)
		elseif GameState.FireStorm and faceItem.FireStormModifier then
			modifier = 100 - MulDivRound(const.EnvEffects.FireStormSightMod, faceItem.FireStormModifier, 100)
		elseif GameState.ClearSky and GameState.Day and not GameState.DustStorm and not GameState.FireStorm and not GameState.Fog and not GameState.Night and faceItem.TannedGoggles then
			modifier = RevisedLBEConfig.TannedGoogleSightModifier
		end

		sightAmount = MulDivRound(sightAmount, modifier, 100)
	end

	return sightAmount, hidden, night_time
end

function UnitProperties:EquipStartingGear(items)
	local func = empty_func
	if IsKindOf(self, "UnitData") then
		local template = UnitDataDefs[self.class]
		func = template and template.CustomEquipGear or self.CustomEquipGear
	end

	-- priority custom gearing rules
	func(self, items)

	-- default gearing rules:
	-- make sure there's an equipped weapon if possible
	if not self:GetItemInSlot("Handheld A", "BaseWeapon") then
		local has_weapon = self:TryEquip(items, "Handheld A", "Firearm")
		has_weapon = has_weapon or self:TryEquip(items, "Handheld A", "MeleeWeapon")
		has_weapon = has_weapon or self:TryEquip(items, "Handheld A", "HeavyWeapon")
	end

	local equipped = {}
	-- locked items that are not weapons add to the first inventory slot
	for i, item in ipairs(items) do
		if item.locked and not item:IsWeapon() and not IsKindOf(item, "Armor") then -- lock to the first inventory slot
			if self:CanAddItem("Inventory", item) then
				self:AddItem("Inventory", item)
				equipped[i] = true
			end
		end
	end
	-- equip the rest of the equppable items when possible

	for i, item in ipairs(items) do
		if not equipped[i] then
			local slot
			if IsKindOf(item, "QuickSlotItem") then
				if self:CanAddItem("Handheld A", item) then
					slot = "Handheld A"
				elseif self:CanAddItem("Handheld B", item) then
					slot = "Handheld B"
				end
			elseif IsKindOf(item, "Armor") and not self:GetItemInSlot(item.Slot) then
				slot = item.Slot
			end
			if slot and self:CanAddItem(slot, item) then
				self:AddItem(slot, item)
				equipped[i] = true
			end
		end
	end

	-- make sure all equipped firearms have ammo
	local function reload_weapon(weapon)
		if not weapon.ammo or weapon.ammo.Amount <= 0 then
			local ammo = GetAmmosWithCaliber(weapon.Caliber, "sort")[1]
			if ammo then
				local tempAmmo = PlaceInventoryItem(ammo.id)
				tempAmmo.Amount = tempAmmo.MaxStacks
				weapon:Reload(tempAmmo, "suspend_fx")
				DoneObject(tempAmmo)
			end
		end
	end
	self:ForEachItemInSlot("Handheld A", "Firearm", reload_weapon)
	self:ForEachItemInSlot("Handheld B", "Firearm", reload_weapon)

	-- place the rest in Inventory slot
	for i, item in ipairs(items) do
		-- if IsMerc(self) then
		-- 	print(item.class, self.class)
		-- end
		if not equipped[i] and not IsKindOf(item, "Ammo") and not IsKindOf(item, "Meds") then
			local pos, reason = self:AddItem("Inventory", item)
			if not pos then
				print("Couldn't add starting item \'", item.class, "\' to unit", self.class, "because", reason,
					"max slots", self:GetMaxTilesInSlot("Inventory"))
			end
		end
	end

	-- place ammo and meds
	for i, item in ipairs(items) do
		if not equipped[i] and IsKindOf(item, "Ammo") or IsKindOf(item, "Meds") then
			local pos, reason = self:AddItem("Inventory", item)
			if not pos then
				print("Couldn't add starting item \'", item.class, "\' to unit", self.class, "because", reason,
					"max slots", self:GetMaxTilesInSlot("Inventory"))
			end
		end
	end
end
