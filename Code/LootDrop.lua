function OnMsg.UnitDied(unit)
    if unit then
        if unit:Random(100) < RevisedLBEConfig.LBEDropChance then
            local drawItemId = DrawItem(unit)
            local LBE = PlaceInventoryItem(drawItemId)
            unit:AddItem("InventoryDead", LBE)
        end
    end
end

function DrawItem(unit)
    local affilation = unit.Affiliation
    local drawTable = {}
    for _, item in pairs(RarityTable) do
        if affilation == item.Affiliation then
            table.insert(drawTable, item)
        end
    end
    local totalWeight = 0

    for _, v in pairs(drawTable) do
        totalWeight = totalWeight + v.Rarity
    end

    local roll = unit:Random(totalWeight)
    local rollingSum = 0

    for _, drawnItem in pairs(drawTable) do
        rollingSum = rollingSum + drawnItem.Rarity
        if roll<rollingSum then
            return drawnItem.id
        end
    end
end

RarityTable = {
    {Affiliation = "Legion", id = "Sidor_Backpack", Rarity = 10},
    {Affiliation = "Legion", id = "M56_Vest", Rarity = 10},
    {Affiliation = "Legion", id = "Lifchik_Vest", Rarity = 5},
    {Affiliation = "Legion", id = "BritishCombat_Vest", Rarity = 1},
    {Affiliation = "Army", id = "Sidor_Backpack", Rarity = 10},
    {Affiliation = "Army", id = "BlackhawkOmega_Vest", Rarity = 5},
    {Affiliation = "Army", id = "Blackhawk_Rig", Rarity = 10},
}