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
		if number > 4 then
			return
		end

		local handHeld = number > 2 and "Handheld B" or "Handheld A"

		local left = number % 2 == 1 and 1 or 2

		local weapon = unit:GetItemInSlot(handHeld, "Grenade", left, 1)
		return weapon
	end

	local inventory = unit["Inventory"]

	local grenades = {}

	unit:ForEachItemInSlot(unit.current_weapon, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, "class", item.class) then
				table.insert(grenades, item)
			end
		end
	end)

	local alt_set = unit.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"
	unit:ForEachItemInSlot(alt_set, function(item)
		if IsKindOf(item, "Grenade") then
			if not table.find(grenades, "class", item.class) then
				table.insert(grenades, item)
			end
		end
	end)

	for _, item in pairs(inventory) do
		if IsKindOf(item, "Grenade") and REV_GetItemSlotContext(unit, item) ~= "Backpack" then
			if not table.find(grenades, "class", item.class) then
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

function OnMsg.DataLoaded()
	CombatActions.DoubleTossA.GetAttackWeapons = function(self, unit, args)
		return GetDoubleTossWeapons(unit, "A")
	end

	CombatActions.DoubleTossB.GetAttackWeapons = function(self, unit, args)
		return GetDoubleTossWeapons(unit, "B")
	end

	CombatActions.DoubleTossA.GetUIState = function(self, units, args)
		local unit = units[1]
		local weapon1 = self:GetAttackWeapons(unit)
		if not weapon1 then
			return "disabled", AttackDisableReasons.OutOfAmmo
		end

		local recharge = unit:GetSignatureRecharge(self.id)
		if recharge then
			if recharge.on_kill then
				return "disabled", AttackDisableReasons.SignatureRechargeOnKill
			end
			return "disabled", AttackDisableReasons.SignatureRecharge
		end
		return CombatActionGenericAttackGetUIState(self, units, args)
	end

	CombatActions.DoubleTossA.GetActionResults = function(self, unit, args)
		local grenade1, grenade2 = self:GetAttackWeapons(unit)
		local target = ResolveGrenadeTargetPos(args.target)
		if not target or not grenade1 then
			return {}
		end
		-- get target_offset from DoubleTossA always (the function can be called for other actions)
		local target_offset = CombatActions.DoubleTossA:ResolveValue("target_offset")
		local offset = MulDivRound(grenade1.AreaOfEffect * const.SlabSizeX, target_offset, 100)
		if grenade1.coneShaped then
			offset = offset / DivRound(360, grenade1.coneAngle)
		end
		local offset_dir = RotateRadius(offset, CalcOrientation(args.step_pos or unit, target) + 90 * 60)

		local args_arr = {}
		args_arr[1] = table.copy(args)
		args_arr[2] = table.copy(args)
		args_arr[1].target = target + offset_dir
		args_arr[2].target = target - offset_dir
		if args.explosion_pos then
			args_arr[1].explosion_pos = args.explosion_pos[1]
			args_arr[2].explosion_pos = args.explosion_pos[2]
		end
		local grenades = { grenade1, grenade2 }
		local attacks = {}
		for i = 1, 2 do
			local results, attack_args = REV_GETDoubleTossSingleActionResult(self, unit, args_arr[i], grenades[i])
			attacks[i] = results
			attacks[i].attack_args = attack_args
		end

		local results = MergeAttacks(attacks)
		return results, attacks[1].attack_args
	end
end

function REV_GETDoubleTossSingleActionResult(action, unit, args, grenade)
	local target = ResolveGrenadeTargetPos(args.target, unit:GetPos(), grenade)
	args.target = target
	args.stance = "Standing"
	local attack_args = unit:PrepareAttackArgs(action.id, args)
	if not grenade or not target then
		return {}, attack_args
	end
	local results = grenade:GetAttackResults(action, attack_args)
	return results, attack_args
end

function GetDoubleTossWeapons(unit, aorb)
	local inventory = unit["Inventory"]

	local grenades = {}

	local allGrenades = {}

	local grenadeAmounts = {}

	local slots = { unit.current_weapon, unit.current_weapon == "Handheld A" and "Handheld B" or "Handheld A" }

	for _, slot in ipairs(slots) do
		unit:ForEachItemInSlot(slot, function(item)
			if IsKindOf(item, "Grenade") then
				table.insert(allGrenades, item)
				if not table.find(grenades, "class", item.class) then
					table.insert(grenades, item)
				end
				if not grenadeAmounts[item.class] then
					grenadeAmounts[item.class] = item.Amount
				else
					grenadeAmounts[item.class] = grenadeAmounts[item.class] + item.Amount
				end
			end
		end)
	end

	for _, item in pairs(inventory) do
		if IsKindOf(item, "Grenade") and REV_GetItemSlotContext(unit, item) ~= "Backpack" then
			table.insert(allGrenades, item)
			if not table.find(grenades, "class", item.class) then
				table.insert(grenades, item)
			end
			if not grenadeAmounts[item.class] then
				grenadeAmounts[item.class] = item.Amount
			else
				grenadeAmounts[item.class] = grenadeAmounts[item.class] + item.Amount
			end
		end
	end

	local possibleOptions = {}

	for class, amount in pairs(grenadeAmounts) do
		if amount >= 2 then
			for _, item in ipairs(grenades) do
				if item.class == class then
					table.insert(possibleOptions, item)
					break
				end
			end
		end
	end

	local index = aorb == "A" and 1 or 2

	local grenade1 = possibleOptions[index]

	if not grenade1 then
		return
	end

	local grenade2 = nil

	for _, item in ipairs(allGrenades) do
		if item ~= grenade1 and item.class == grenade1.class then
			grenade2 = item
			break
		end
	end

	return grenade1, grenade2 or grenade1
end

function Unit:DoubleToss(action_id, cost_ap, args)
	REV_ThrowDoubleTossGrenade(self, action_id, cost_ap, args)
	local action = CombatActions[action_id]
	local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
	self:AddSignatureRechargeTime("DoubleToss", const.Combat.SignatureAbilityRechargeTime, recharge_on_kill > 0)
end

function REV_ThrowDoubleTossGrenade(unit, action_id, cost_ap, args)
	if not string.gmatch(action_id, "DoubleToss") then
		return REV_OriginalUnitThrowGrenade(unit, action_id, cost_ap, args)
	end

	local stealth_attack = not not unit:HasStatusEffect("Hidden")
	local target_pos = args.target
	if unit.stance ~= "Standing" then
		unit:ChangeStance(nil, nil, "Standing")
	end
	local action = CombatActions[action_id]
	unit:ProvokeOpportunityAttacks(action, "attack interrupt")
	local grenade1, grenade2 = action:GetAttackWeapons(unit)
	args.prediction = false                                       -- mishap needs to happen now
	local results, attack_args = action:GetActionResults(unit, args) -- early check for PrepareToAttack
	unit:PrepareToAttack(attack_args, results)
	unit:UpdateAttachedWeapons()
	unit:ProvokeOpportunityAttacks(action, "attack interrupt")
	unit:EndInterruptableMovement()

	-- camera effects
	if not attack_args.opportunity_attack_type == "Retaliation" then
		if g_Combat and IsEnemyKill(unit, results) then
			g_Combat:CheckPendingEnd(results.killed_units)
			local isKillCinematic, dontPlayForLocalPlayer = IsEnemyKillCinematic(unit, results, attack_args)
			if isKillCinematic then
				cameraTac.SetForceMaxZoom(false)
				SetAutoRemoveActionCamera(unit, results.killed_units[1], nil, nil, nil, nil, nil, dontPlayForLocalPlayer)
			end
		end
	end

	unit:RemoveStatusEffect("FirstThrow")

	-- multi-throw support
	local attacks = results.attacks or { results }
	local ap = (cost_ap and cost_ap > 0) and cost_ap or action:GetAPCost(unit, attack_args)
	table.insert(g_CurrentAttackActions, { action = action, cost_ap = ap, attack_args = attack_args, results = results })

	unit:PushDestructor(function(unit)
		unit:ForEachAttach("GrenadeVisual", DoneObject)
		table.remove(g_CurrentAttackActions)
		unit.last_attack_session_id = false
		local dlg = GetInGameInterfaceModeDlg()
		if dlg and dlg:HasMember("dont_return_camera_on_close") then
			dlg.dont_return_camera_on_close = true
		end
	end)

	Msg("ThrowGrenade", unit, grenade1, #attacks)
	-- throw anim
	unit:SetState("gr_Standing_Attack", const.eKeepComponentTargets)
	-- pre-create visual objs and play activate fx
	local visual_objs = {}
	for i = 1, #attacks do
		local grenade = attacks[i].weapon
		local visual_obj = grenade:GetVisualObj(unit, i > 1)
		visual_objs[i] = visual_obj
		PlayFX("GrenadeActivate", "start", visual_obj)
	end
	local time_to_hit = unit:TimeToMoment(1, "hit") or 20
	unit:Face(target_pos, time_to_hit / 2)
	Sleep(time_to_hit)

	if results.miss or not results.killed_units or not (#results.killed_units > 1) then
		local specialNadeVr = table.find(SpecialGrenades, grenade1.class) and
		(IsMerc(unit) and "SpecialThrowGrenade" or "AIThrowGrenadeSpecial")
		local standardNadeVr = IsMerc(unit) and "ThrowGrenade" or "AIThrowGrenade"
		PlayVoiceResponse(unit, specialNadeVr or standardNadeVr)
	end

	local thread = CreateGameTimeThread(function()
		-- create visuals and start anim thread for each throw
		local threads = {}
		for i, attack in ipairs(attacks) do
			visual_objs[i]:Detach()
			visual_objs[i]:SetHierarchyEnumFlags(const.efVisible)
			local trajectory = attack.trajectory
			if #trajectory > 0 then
				local rpm_range = const.Combat.GrenadeMaxRPM - const.Combat.GrenadeMinRPM
				local rpm = const.Combat.GrenadeMinRPM + unit:Random(rpm_range)
				local rotation_axis = RotateAxis(axis_x, axis_z, CalcOrientation(trajectory[2].pos, trajectory[1].pos))
				threads[i] = CreateGameTimeThread(AnimateThrowTrajectory, visual_objs[i], trajectory, rotation_axis, rpm,
					"GrenadeDrop")
			else
				-- try to find a fall down pos
				threads[i] = CreateGameTimeThread(ItemFallDown, visual_objs[i])
			end
		end
		grenade1:OnThrow(unit, visual_objs)
		-- wait until all threads are done
		while #threads > 0 do
			Sleep(25)
			for i = #threads, 1, -1 do
				if not IsValidThread(threads[i]) then
					table.remove(threads, i)
				end
			end
		end
		-- real check when the grenade(s) landed must use the current position(s)
		if #attacks > 1 then
			args.explosion_pos = {}
			for i, res in ipairs(attacks) do
				args.explosion_pos[i] = res.explosion_pos or visual_objs[i]:GetVisualPos()
			end
		else
			args.explosion_pos = results.explosion_pos or visual_objs[1]:GetVisualPos()
		end
		results, attack_args = action:GetActionResults(unit, args)
		local attacks = results.attacks or { results }

		results.attack_from_stealth = stealth_attack

		-- needs to be after GetActionResults
		local destroy_grenade1
		local destroy_grenade2
		
		if not unit.infinite_ammo then
			grenade1.Amount = grenade1.Amount - 1
			destroy_grenade1 = grenade1.Amount <= 0
			if destroy_grenade1 then
				local slot = unit:GetItemSlot(grenade1)
				unit:RemoveItem(slot, grenade1)
			end
			grenade2.Amount = grenade2.Amount - 1
			destroy_grenade2 = grenade2.Amount <= 0
			if destroy_grenade2 then
				local slot = unit:GetItemSlot(grenade2)
				unit:RemoveItem(slot, grenade2)
			end
			ObjModified(unit)
		end

		unit:AttackReveal(action, attack_args, results)

		unit:OnAttack(action_id, nil, results, attack_args)
		LogAttack(action, attack_args, results)
		for i, attack in ipairs(attacks) do
			local grenade = attack.weapon
			grenade:OnLand(unit, attack, visual_objs[i])
		end
		if destroy_grenade1 then
			DoneObject(grenade1)
		end
		if destroy_grenade2 then
			DoneObject(grenade2)
		end
		AttackReaction(action, attack_args, results)
		Msg(CurrentThread())
	end)

	Sleep(unit:TimeToAnimEnd())
	unit:SetRandomAnim(unit:GetIdleBaseAnim())
	if IsValidThread(thread) then
		WaitMsg(thread)
	end
	unit:ProvokeOpportunityAttacks(action, "attack reaction")
	unit:PopAndCallDestructor()
end
