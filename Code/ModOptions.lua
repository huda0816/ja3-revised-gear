function OnMsg.ApplyModOptions(mod_id)
	if mod_id == CurrentModId and CurrentModOptions then
		RevisedLBEConfig.LBEDropChance = tonumber(CurrentModOptions['RevisedLBEDropChance'])
		RevisedLBEConfig.SquadBagHasWeight = CurrentModOptions['RevisedSquadBagHasWeight']
	end
end
