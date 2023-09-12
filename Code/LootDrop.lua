function OnMsg.UnitDied(unit)
    local target = tonumber(CurrentModOptions['RevisedLBEDropChance'])
    local roll = unit:Random(100)
    if unit then
        print(target)
        print(roll)
        print(roll < target)
        if roll < target then
            print("here")
            local drawItemId = DrawLBE(unit)
            local LBE = PlaceInventoryItem(drawItemId)
            unit:AddItem("InventoryDead", LBE)
        end
    end
end

function DrawLBE(unit)
    local affilation = unit.Affiliation
    local drawTable = {}
    print(drawTable)
    for _, item in pairs(LBERarityTable) do
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
            print(drawnItem)
            return drawnItem.id
        end
    end
end

LBERarityTable = {
    {Affiliation = "Legion", id = "Sidor_Backpack", Rarity = 10},
    {Affiliation = "Legion", id = "Vietnam_Backpack", Rarity = 7},
    {Affiliation = "Legion", id = "M56_Vest", Rarity = 10},
    {Affiliation = "Legion", id = "Lifchik_Vest", Rarity = 5},
    {Affiliation = "Legion", id = "FrenchCCE_Vest", Rarity = 3},
    {Affiliation = "Legion", id = "BritishCombat_Vest", Rarity = 1},
    {Affiliation = "Army", id = "Sidor_Backpack", Rarity = 10},
    {Affiliation = "Army", id = "BlackhawkOmega_Vest", Rarity = 3},
    {Affiliation = "Army", id = "Blackhawk_Rig", Rarity = 10},
    {Affiliation = "Army", id = "Bergen_Backpack", Rarity = 5},
    {Affiliation = "Army", id = "Blackhawk_Backpack", Rarity = 3},
    {Affiliation = "Army", id = "BlackhawkPhoenix_Backpack", Rarity = 5},
}