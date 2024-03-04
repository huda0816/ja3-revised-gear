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
