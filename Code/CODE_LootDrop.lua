function OnMsg.UnitDied(unit)
	if unit.role == "Beast" then
		return
	end
    local target = RevisedLBEConfig.LBEDropChance
    local roll = unit:Random(100)
    if unit then
        if roll < target then
            local drawItemId = REV_DrawLBE(unit)
            local LBE = PlaceInventoryItem(drawItemId)
            unit:AddItem("InventoryDead", LBE)
        end
    end
end

function REV_DrawLBE(unit)
    local affilation = unit.Affiliation
    local drawTable = {}
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
            return drawnItem.id
        end
    end
end


-- Legion, Rebel:
-- Holster_Basic
-- Holster_Drop_Leg_Bag
-- LBE_Basic_Rig_3
-- LBE_Cheap_Vest_3
-- LBE_Combat_Vest_3
-- Backpack_Retro
-- Backpack_Retro_Large
-- Backpack_Combat
-- Holster_Knives

-- Army
-- Holster_Basic
-- Holster_Drop_Leg_Bag
-- LBE_Basic_Army_Rig_3
-- LBE_Modern_Army_Rig_3
-- LBE_Combat_Vest_3
-- LBE_Heavy_Duty_Vest_3
-- Backpack_Retro
-- Backpack_Mule
-- Backpack_Combat
-- Backpack_Modern
-- FaceItem_Combat_Goggles
-- Holster_Knives

-- Adonis
-- Holster_Basic
-- Holster_Drop_Leg_Bag
-- LBE_Modern_Army_Rig_3
-- LBE_Heavy_Duty_Vest_3
-- Backpack_Combat
-- Backpack_Modern
-- FaceItem_Combat_Goggles
-- Holster_Knives

-- SuperSoldiers
-- LBE_SWAT_Vest_3
-- Holster_Drop_Leg_Bag
-- Backpack_Blackhawk
-- Holster_Extended
-- FaceItem_Combat_Goggles
-- Holster_Knives

LBERarityTable = {
    {Affiliation = "Legion", id = "Holster_Basic", Rarity = 6},
    {Affiliation = "Legion", id = "Holster_Drop_Leg_Bag", Rarity = 4},
	{Affiliation = "Legion", id = "Holster_Knives", Rarity = 4},
	{Affiliation = "Legion", id = "LBE_Basic_Rig_3", Rarity = 8},
	{Affiliation = "Legion", id = "LBE_Cheap_Vest_3", Rarity = 10},
	{Affiliation = "Legion", id = "LBE_Combat_Vest_3", Rarity = 6},
	{Affiliation = "Legion", id = "Backpack_Retro", Rarity = 10},
	{Affiliation = "Legion", id = "Backpack_Retro_Large", Rarity = 6},
	{Affiliation = "Legion", id = "Backpack_Combat", Rarity = 4},
	{Affiliation = "Rebel", id = "Holster_Basic", Rarity = 6},
	{Affiliation = "Rebel", id = "Holster_Drop_Leg_Bag", Rarity = 4},
	{Affiliation = "Rebel", id = "Holster_Knives", Rarity = 4},
	{Affiliation = "Rebel", id = "LBE_Basic_Rig_3", Rarity = 8},
	{Affiliation = "Rebel", id = "LBE_Cheap_Vest_3", Rarity = 6},
	{Affiliation = "Rebel", id = "LBE_Combat_Vest_3", Rarity = 6},
	{Affiliation = "Rebel", id = "Backpack_Retro", Rarity = 10},
	{Affiliation = "Rebel", id = "Backpack_Retro_Large", Rarity = 6},
	{Affiliation = "Rebel", id = "Backpack_Combat", Rarity = 4},
	{Affiliation = "Army", id = "Holster_Basic", Rarity = 6},
	{Affiliation = "Army", id = "Holster_Drop_Leg_Bag", Rarity = 6},
	{Affiliation = "Army", id = "Holster_Knives", Rarity = 4},
	{Affiliation = "Army", id = "LBE_Basic_Army_Rig_3", Rarity = 10},
	{Affiliation = "Army", id = "LBE_Modern_Army_Rig_3", Rarity = 8},
	{Affiliation = "Army", id = "LBE_Basic_Rig_3", Rarity = 8},
	{Affiliation = "Army", id = "LBE_Combat_Vest_3", Rarity = 6},
	{Affiliation = "Army", id = "LBE_Heavy_Duty_Vest_3", Rarity = 6},
	{Affiliation = "Army", id = "Backpack_Retro", Rarity = 4},
	{Affiliation = "Army", id = "Backpack_Mule", Rarity = 4},
	{Affiliation = "Army", id = "Backpack_Combat", Rarity = 6},
	{Affiliation = "Army", id = "Backpack_Modern", Rarity = 8},
	{Affiliation = "Army", id = "FaceItem_Combat_Goggles", Rarity = 4},
	{Affiliation = "Adonis", id = "Holster_Basic", Rarity = 6},
	{Affiliation = "Adonis", id = "Holster_Drop_Leg_Bag", Rarity = 6},
	{Affiliation = "Adonis", id = "Holster_Knives", Rarity = 4},
	{Affiliation = "Adonis", id = "LBE_Modern_Army_Rig_3", Rarity = 10},
	{Affiliation = "Adonis", id = "LBE_Heavy_Duty_Vest_3", Rarity = 8},
	{Affiliation = "Adonis", id = "Backpack_Combat", Rarity = 8},
	{Affiliation = "Adonis", id = "Backpack_Modern", Rarity = 10},
	{Affiliation = "Adonis", id = "FaceItem_Combat_Goggles", Rarity = 6},
	{Affiliation = "SuperSoldiers", id = "LBE_SWAT_Vest_3", Rarity = 10},
	{Affiliation = "SuperSoldiers", id = "Holster_Drop_Leg_Bag", Rarity = 5},
	{Affiliation = "SuperSoldiers", id = "Holster_Knives", Rarity = 4},
	{Affiliation = "SuperSoldiers", id = "Backpack_Blackhawk", Rarity = 10},
	{Affiliation = "SuperSoldiers", id = "Holster_Extended", Rarity = 5},
	{Affiliation = "SuperSoldiers", id = "FaceItem_Combat_Goggles", Rarity = 6},
}
