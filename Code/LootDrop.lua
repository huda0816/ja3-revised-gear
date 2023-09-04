function OnMsg.UnitDied(unit)
    if unit then
        if unit:Random(100) < RevisedLootConfigValues.AmmoDropChance then
            local weapon = unit:GetActiveWeapons()
            local mag  = PlaceInventoryItem(weapon.Magazine)
            mag.Amount = unit:Random(RevisedLootConfigValues.Max)
            print(mag.Amount)
            unit:AddItem("InventoryDead", mag)
        end
    end
end