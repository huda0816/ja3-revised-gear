itemCombatSkillsList = REV_AppendToTable(itemCombatSkillsList, {
	"ThrowGrenadeE",
	"ThrowGrenadeF",
	"ThrowGrenadeG",
	"ThrowGrenadeH",
	"ThrowGrenadeI",
	"ThrowGrenadeJ"
})

function OnMsg.ModsReloaded()
	local ExtraThrowSlots = { "E", "F", "G", "H", "I", "J" }

	for index, value in ipairs(ExtraThrowSlots) do
		PlaceObj('CombatAction', {
			ActionType = "Ranged Attack",
			AimType = "parabola aoe",
			AlwaysHits = true,
			ConfigurableKeybind = false,
			DisplayName = T(264282791362, --[[CombatAction ThrowGrenadeE DisplayName]] "Grenade"),
			Execute = function(self, units, args)
				local unit = units[1]
				local ap = self:GetAPCost(unit, args)
				NetStartCombatAction(self.id, unit, ap, args)
			end,
			GetAPCost = function(self, unit, args)
				local grenade = self:GetAttackWeapons(unit)
				return grenade and unit:GetAttackAPCost(self, grenade, false, args and args.aim or 0) or -1
			end,
			GetActionDamage = function(self, unit, target, args)
				local weapon = self:GetAttackWeapons(unit)
				local base = unit:GetBaseDamage(weapon)
				local bonus = GetGrenadeDamageBonus(unit)
				return MulDivRound(base, Max(0, 100 + bonus), 100)
			end,
			GetActionDescription = function(self, units)
				return CombatActionGrenadeDescription(self, units)
			end,
			GetActionDisplayName = function(self, units)
				local unit = units[1]
				if unit then
					local weapon = self:GetAttackWeapons(unit)
					if weapon then
						return T { 355482653923, "Throw <name>", name = weapon.DisplayName }
					end
				end
				local name = self.DisplayName
				if (name or "") == "" then
					name = Untranslated(self.id)
				end
				return name
			end,
			GetActionIcon = function(self, units)
				return GetThrowItemIcon(self, units and units[1])
			end,
			GetActionResults = function(self, unit, args)
				return CombatActions.ThrowGrenadeA.GetActionResults(self, unit, args)
			end,
			GetAttackWeapons = function(self, unit, args)
				return GetThrowGrenadeAttackWeapons(unit, index + 4)
			end,
			GetMaxAimRange = function(self, unit, weapon)
				local maxRange = weapon:GetMaxAimRange(unit)
				if HasPerk(unit, "Throwing") then
					maxRange = maxRange + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease")
				end
				return maxRange
			end,
			GetUIState = function(self, units, args)
				return CombatActions.ThrowGrenadeA.GetUIState(self, units, args)
			end,
			Icon = "UI/Icons/Hud/throw_grenade",
			IdDefault = "ThrowGrenade" .. value .. "default",
			IsAimableAttack = false,
			KeybindingFromAction = "actionRedirectThrowGrenade",
			MultiSelectBehavior = "first",
			RequireState = "any",
			RequireWeapon = true,
			Run = function(self, unit, ap, ...)
				unit:SetActionCommand("ThrowGrenade", self.id, ap, ...)
			end,
			SortKey = 6,
			UIBegin = function(self, units, args)
				CombatActionAttackStart(self, units, args, "IModeCombatAreaAim")
			end,
			group = "Consumables",
			id = "ThrowGrenade" .. value,
		})
	end

	local ThrowSlots = { "A", "B", "C", "D" }

	for index, value in ipairs(ThrowSlots) do
		CombatActions["ThrowGrenade" .. value].GetAttackWeapons = function(self, unit, args)
			return GetThrowGrenadeAttackWeapons(unit, index)
		end
	end
end

local REV_Original_GetThrowableKnife = Unit.GetThrowableKnife

function Unit:GetThrowableKnife()
	local l_get_throwable_knife = REV_Original_GetThrowableKnife(self)

	if not l_get_throwable_knife and REV_IsMerc(self) then
		local inventory = self["Inventory"]
		for _, item in pairs(inventory) do
			if IsKindOf(item, "MeleeWeapon") and item.CanThrow and REV_GetItemSlotContext(self, item) ~= "Backpack" then
				l_get_throwable_knife = item
				break
			end
		end
	end

	return l_get_throwable_knife
end

function GetThrowGrenadeAttackWeapons(unit, number)
	if not REV_IsMerc(unit) then
		local weapon = unit:GetItemInSlot("Handheld A", "Grenade", 1, 1)
		return weapon
	end

	local inventory = unit["Inventory"]

	local grenades = {}

	unit:ForEachItemInSlot(unit.current_weapon, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, item) then
				table.insert(grenades, item)
			end
		end
	end)

	local alt_set = unit.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"
	unit:ForEachItemInSlot(alt_set, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, item) then
				table.insert(grenades, item)
			end
		end
	end)

	for _, item in pairs(inventory) do
		if IsKindOf(item, "Grenade") and REV_GetItemSlotContext(unit, item) ~= "Backpack" then
			if not table.find(grenades, item) then
				table.insert(grenades, item)
			end
		end
	end

	return grenades[number]
end

local REV_OriginalUnitEnumUIActions = Unit.EnumUIActions

function Unit:EnumUIActions()
	local actions = REV_OriginalUnitEnumUIActions(self)

	if not REV_IsMerc(self) then
		return actions
	end

	local grenadeThrowActions = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J" }

	for _, action in ipairs(grenadeThrowActions) do
		table.remove_value(actions, "ThrowGrenade" .. action)
	end

	local grenades = {}

	self:ForEachItemInSlot(self.current_weapon, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, item.class) then
				table.insert(grenades, item.class)
			end
		end
	end)

	local alt_set = self.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"
	self:ForEachItemInSlot(alt_set, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, item.class) then
				table.insert(grenades, item.class)
			end
		end
	end)

	local inventory = self["Inventory"]

	for _, item in pairs(inventory) do
		if IsKindOf(item, "Grenade") and REV_GetItemSlotContext(self, item) ~= "Backpack" then
			if not table.find(grenades, item.class) then
				table.insert(grenades, item.class)
			end
		end
	end

	for i, grenade in ipairs(grenades) do
		actions[#actions + 1] = "ThrowGrenade" .. string.char(64 + i)

		if i == #grenadeThrowActions then
			break
		end
	end

	return actions
end

local REV_OriginalGetUnitEquippedMedicine = GetUnitEquippedMedicine

function GetUnitEquippedMedicine(unit)
	if not REV_IsMerc(unit) then
		return REV_OriginalGetUnitEquippedMedicine(unit)
	end

	local item
	unit:ForEachItem("Medicine", function(itm)
		if itm.Condition > 0 and REV_GetItemSlotContext(unit, itm) ~= "Backpack" then
			if not item or (item.UsePriority < itm.UsePriority) then
				item = itm
			end
		end
	end)
	return item
end

function REV_GetUnitQuickSlotItem(unit, item_id)
	if not REV_IsMerc(unit) then
		local get_unit_quick_slot_item = nil

		local filter = function(o)
			if o.Condition > 0 and (not l_get_unit_quick_slot_item or o.Condition < l_get_unit_quick_slot_item.Condition) then
				l_get_unit_quick_slot_item = o
			end
		end

		unit:ForEachItemInSlot("Handheld A", item_id, filter)
		unit:ForEachItemInSlot("Handheld B", item_id, filter)
		unit:ForEachItemInSlot("Inventory", item_id, filter)

		return get_unit_quick_slot_item
	end

	local l_get_unit_quick_slot_item = nil

	local filter = function(o)
		if o.Condition > 0 and (not l_get_unit_quick_slot_item or o.Condition < l_get_unit_quick_slot_item.Condition) and REV_GetItemSlotContext(unit, o) ~= "Backpack" then
			l_get_unit_quick_slot_item = o
		end
	end

	unit:ForEachItemInSlot("Handheld A", item_id, filter)
	unit:ForEachItemInSlot("Handheld B", item_id, filter)
	unit:ForEachItemInSlot("Inventory", item_id, filter)

	return l_get_unit_quick_slot_item
end

function GetUnitLockpick(unit)
	local tool = REV_GetUnitQuickSlotItem(unit, "LockpickBase")
	return tool and not tool:IsCondition("Broken") and tool
end

function GetUnitCrowbar(unit)
	local tool = REV_GetUnitQuickSlotItem(unit, "CrowbarBase")
	return tool and not tool:IsCondition("Broken") and tool
end

function GetUnitWirecutter(unit)
	local tool = REV_GetUnitQuickSlotItem(unit, "WirecutterBase")
	return tool and not tool:IsCondition("Broken") and tool
end
