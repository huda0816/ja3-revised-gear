UndefineClass('FaceItem_Combat_Goggles')
DefineClass.FaceItem_Combat_Goggles = {
	__parents = { "FaceItem" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "FaceItem",
	ScrapParts = 2,
	Icon = "Mod/ii6mKUf/Items/FaceItems/Face_combat_goggles.png",
	ItemType = "Armor",
	DisplayName = T(133813476634, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles DisplayName]] "Combat Goggles"),
	DisplayNamePlural = T(711946176668, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles DisplayNamePlural]] "Combat Goggles"),
	Description = T(640711670812, --[[ModItemInventoryItemCompositeDef FaceItem_Combat_Goggles Description]] "Those goggles help in bad weather conditions"),
	Cost = 599,
	CanAppearInShop = true,
	RestockWeight = 70,
	CanBeConsumed = false,
	PocketL_amount = 1,
	PocketML_amount = 1,
	Slot = "FaceItem",
	DamageReduction = 1,
	AdditionalReduction = 1,
	ProtectedBodyParts = set( "Head" ),
	TannedGoggles = true,
	DustStormModifier = 50,
	FireStormModifier = 50,
}

