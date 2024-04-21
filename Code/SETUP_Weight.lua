function OnMsg.ClassesGenerate()
	AppendClass.InventoryItem = {
		properties = {
			{
				id = "Weight",
				name = "Weight",
				editor = "number",
				default = 10,
				min = 0,
				max = 100000,
				template = true,
				category = "General"
			}
		}
	}

	-- QuestItem
	QuestItem.Weight = 300
	WriterPage.Weight = 10
	WriterLetter.Weight = 10
	Wig.Weight = 100
	MedicalReport.Weight = 30
	US_Passport.Weight = 50
	Coin.Weight = 10
	Pamphlets.Weight = 300
	Pamphlets_LysRouge.Weight = 300
	WorkerDiary.Weight = 300
	WriterDiary.Weight = 300
	WeirdosMap.Weight = 30
	PaBaggzWill.Weight = 10
	VirusSample.Weight = 10
	Diesel.Weight = 3200

	QuestItemValuable.Weight = 100
	GoldenWatch.Weight = 100
	DiamondNecklace.Weight = 100

	-- Misc
	Meds.Weight = 100 -- 50kg for a stack of 500
	Parts.Weight = 100 -- 50kg for a stack of 500

	MiscItem.Weight = 100

	CombatStim.Weight = 100
	MetaviraShot.Weight = 100
	HerbalMedicine.Weight = 50

	Medicine.Weight = 1000
	FirstAidKit.Weight = 1000  -- max_meds_parts: 8
	Medkit.Weight = 5000       -- max_meds_parts: 12 -- it is more than the meds as it is used to perform surgeries.
	Reanimationsset.Weight = 5000 -- max_meds_parts: 12

	ValuableItemContainer.Weight = 5000
	WeaponShipment.Weight = 10000

	MoneyBag.Weight = 2000 -- not just the money, but the bag too

	Valuables.Weight = 300
	GoldBar.Weight = 340      -- 274.5 USD for 0.0311034768kg in 2000
	TinyDiamonds.Weight = 10  -- 500 USD 0.25 carats
	ChippedSapphire.Weight = 10 -- 350 USD 0.7 carats
	BigDiamond.Weight = 20    -- 5000 USD 1 carats
	DiamondBriefcase.Weight = 5000
	TheGreenDiamond.Weight = 621 -- Cullinan diamond 3106 carats

	TreasureMask.Weight = 2000
	TreasureGoldenDog.Weight = 2000
	TreasureTablet.Weight = 2000
	TreasureFigurine.Weight = 2000
	TreasureIdol.Weight = 2000

	Ted.Weight = 250
	Trophy.Weight = 50
	Cookie.Weight = 10

	SkillMag_Health.Weight = 300
	SkillMag_Agility.Weight = 300
	SkillMag_Dexterity.Weight = 300
	SkillMag_Strength.Weight = 300
	SkillMag_Wisdom.Weight = 300
	SkillMag_Leadership.Weight = 300
	SkillMag_Marksmanship.Weight = 300
	SkillMag_Mechanical.Weight = 300
	SkillMag_Explosives.Weight = 300
	SkillMag_Medical.Weight = 300

	StatBoostItem.Weight = 100 -- this seems to be not used

	-- Grenades
	Grenade.Weight = 400
	Flare.Weight = 250

	ConcussiveGrenade_Mine.Weight = 400
	ConcussiveGrenade.Weight = 400

	Molotov.Weight = 700

	SmokeGrenade.Weight = 500
	ToxicGasGrenade.Weight = 500
	TearGasGrenade.Weight = 500

	ShapedCharge.Weight = 1000
	FragGrenade.Weight = 600
	HE_Grenade.Weight = 600

	ThrowableTrapItem.Weight = 600
	PipeBomb.Weight = 1100
	-- TimedTNT
	-- ProximityTNT
	-- RemoteTNT
	-- TimedC4
	-- ProximityC4
	-- RemoteC4
	-- TimedPETN
	-- ProximityPETN
	-- RemotePETN

	--Flare Gun
	FlareGun.Weight = 500
	FlareAmmo.Weight = 100

	-- tools
	ToolItem.Weight = 300
	LockpickBase.Weight = 300
	WirecutterBase.Weight = 500
	CrowbarBase.Weight = 6000

	-- crafting
	ExplosiveSubstance.Weight = 500
	TrapDetonator.Weight = 100
	Detonator.Weight = 100
	PETN.Weight = 500     -- 200 cm^3
	C4.Weight = 500       -- 200 cm^3
	TNT.Weight = 500      -- 200 cm^3
	BlackPowder.Weight = 300 -- 200 cm^3
	Combination_Detonator_Remote.Weight = 100
	Combination_Detonator_Proximity.Weight = 100
	Combination_Detonator_Time.Weight = 100
	Combination_Kompositum58.Weight = 500
	Combination_WeavePadding.Weight = 500
	Combination_CeramicPlates.Weight = 3000
	Combination_Sharpener.Weight = 200
	Combination_BalancingWeight.Weight = 200
	FineSteelPipe.Weight = 1000
	OpticalLens.Weight = 50
	Microchip.Weight = 10

	-- Armor
	Armor.Weight = 3300        -- 9900 for 3 pieces
	TransmutedArmor.Weight = 6300 -- Armor + CeramicPlates

	GasMaskBase.Weight = 500
	Gasmaskenhelm.Weight = 1500
	NightVisionGoggles.Weight = 500

	IvanUshanka.Weight = 700

	NailsLeatherVest.Weight = 2000

	PostApoHelmet.Weight = 2200

	LightHelmet.Weight = 1300
	LightHelmet_Kompositum.Weight = 1600
	LightHelmet_WeavePadding.Weight = 1800

	FlakVest.Weight = 4000
	FlakVest_Kompositum.Weight = 4300
	FlakVest_WeavePadding.Weight = 4500
	FlakVest_CeramicPlates.Weight = 7000

	FlakArmor.Weight = 4500
	FlakArmor_Kompositum.Weight = 4800
	FlakArmor_WeavePadding.Weight = 5000
	FlakArmor_CeramicPlates.Weight = 7500

	CamoArmor_Light.Weight = 4000
	CamoArmor_Light_Kompositum.Weight = 4300

	FlakLeggings.Weight = 1800
	FlakLeggings_Kompositum.Weight = 2100
	FlakLeggings_WeavePadding.Weight = 2300

	HeavyArmorHelmet.Weight = 1800
	HeavyArmorHelmet_Kompositum.Weight = 2100
	HeavyArmorHelmet_WeavePadding.Weight = 2300

	HeavyArmorChestplate.Weight = 6000
	HeavyArmorChestplate_Kompositum.Weight = 6300
	HeavyArmorChestplate_WeavePadding.Weight = 6500
	HeavyArmorChestplate_CeramicPlates.Weight = 9000

	HeavyArmorTorso.Weight = 7000
	HeavyArmorTorso_Kompositum.Weight = 7300
	HeavyArmorTorso_WeavePadding.Weight = 7500
	HeavyArmorTorso_CeramicPlates.Weight = 10000

	HeavyArmorLeggings.Weight = 2300
	HeavyArmorLeggings_Kompositum.Weight = 2600
	HeavyArmorLeggings_WeavePadding.Weight = 2800

	KevlarHelmet.Weight = 1000
	KevlarHelmet_Kompositum.Weight = 1300
	KevlarHelmet_WeavePadding.Weight = 1500

	KevlarChestplate.Weight = 3500
	KevlarChestplate_Kompositum.Weight = 3800
	KevlarChestplate_WeavePadding.Weight = 4000
	KevlarChestplate_CeramicPlates.Weight = 6500

	KevlarVest.Weight = 4000
	KevlarVest_Kompositum.Weight = 4300
	KevlarVest_WeavePadding.Weight = 4500
	KevlarVest_CeramicPlates.Weight = 7000

	CamoArmor_Medium.Weight = 4000
	CamoArmor_Medium_Kompositum.Weight = 4300

	KevlarLeggings.Weight = 1500
	KevlarLeggings_Kompositum.Weight = 1800
	KevlarLeggings_WeavePadding.Weight = 2000

	ShamanHelmet.Weight = 1000
	ShamanTorso.Weight = 3000
	ShamanLeggings.Weight = 1500

	--MeleeWeapon
	MeleeWeapon.Weight = 300
	-- Knife
	-- Knife_Balanced
	-- Knife_Sharpened
	EndlessKnives.Weight = 1000
	GutHookKnife.Weight = 350
	MacheteWeapon.Weight = 1000
	-- Machete
	-- Machete_Sharpened
	TheThing.Weight = 1200
	PierreMachete.Weight = 800

	-- Firearm
	Firearm.Weight = 2500

	-- Pistol
	Pistol.Weight = 850
	Bereta92.Weight = 1000
	HiPower.Weight = 950
	Glock18.Weight = 630
	DesertEagle.Weight = 2100

	Revolver.Weight = 1400
	ColtPeacemaker.Weight = 1200
	ColtAnaconda.Weight = 1600
	TexRevolver.Weight = 1337

	--Shotgun
	Shotgun.Weight = 3500
	DoubleBarrelShotgun.Weight = 3500
	M41Shotgun.Weight = 4000
	Auto5.Weight = 3500
	AA12.Weight = 6000
	Auto5_quest.Weight = 3100

	--SubmachineGun
	SubmachineGun.Weight = 2700
	AKSU.Weight = 2700
	MP40.Weight = 4000
	MP5K.Weight = 2500
	MP5.Weight = 2900
	M4Commando.Weight = 2700
	LionRoar.Weight = 3100
	UZI.Weight = 3500

	--AssaultRifle
	AssaultRifle.Weight = 3500
	AK47.Weight = 4300
	FAMAS.Weight = 3600
	M16A2.Weight = 3900
	FNFAL.Weight = 4300
	M14SAW.Weight = 4100
	AR15.Weight = 3000
	AK74.Weight = 3100
	Galil.Weight = 4500
	AUG.Weight = 3800
	G36.Weight = 3400
	Galil_FlagHill.Weight = 4100

	--SniperRifle
	SniperRifle.Weight = 5000
	DragunovSVD.Weight = 4300
	PSG1.Weight = 7200
	M24Sniper.Weight = 5400
	GoldenGun.Weight = 5200
	Winchester_Quest.Weight = 3100
	BarretM82.Weight = 13600
	Gewehr98.Weight = 4300
	Winchester1894.Weight = 3300

	--MachineGun
	MachineGun.Weight = 7000
	RPK74.Weight = 4700
	MG42.Weight = 11600
	HK21.Weight = 7900
	FNMinimi.Weight = 7100
	MG58.Weight = 11800

	-- HeavyWeapon
	HeavyWeapon.Weight = 10000
	Ordnance.Weight = 300

	-- Assuming that it is a 60mm mortar
	Mortar.Weight = 21000
	MortarShell_Gas.Weight = 1600
	MortarShell_Smoke.Weight = 1600
	MortarShell_HE.Weight = 1900

	GrenadeLauncher.Weight = 6000
	_40mmFragGrenade.Weight = 230
	_40mmFlashbangGrenade.Weight = 170
	MGL.Weight = 5500

	RocketLauncher.Weight = 8000
	Warhead_Frag.Weight = 2600
	RPG7.Weight = 7000

	-- REV

	FaceItem.Weight = 500

	Backpack.Weight = 2000

	-- Backpack_Combat
	-- Backpack_Retro_Large
	-- Backpack_Retro
	-- Backpack_Mule
	-- Backpack_Blackhawk
	-- Backpack_Modern

	LBE.Weight = 1000

	-- LBE_Basic_Army_Rig
	-- LBE_Combat_Vest
	-- LBE_SWAT_Vest
	-- LBE_Cheap_Vest
	-- LBE_Basic_Rig
	-- LBE_Modern_Army_Rig
	-- LBE_Heavy_Duty_Vest

	Holster.Weight = 500

	-- Holster_Basic
	-- Holster_Extended
	-- Holster_Drop_Leg_Bag

	-- Mag

	LargeMag.Weight = 300

	-- G36MagazineLarger
	-- FNMinimiMagazineLarge
	-- HKG3MagazineLarger
	-- FNMinimiMagazineLarger
	-- AK47MagazineMagLarger
	-- AA12MagazineLarge

	PistolMag.Weight = 100

	-- BerettaMagazineLarge
	-- DesertEagleMagazine
	-- GlockMagazineLarge
	-- GlockMagazine
	-- DesertEagleMagazineLarge
	-- BHPMagazine
	-- BHPMagazineLarge
	-- BerettaMagazine

	RifleMag.Weight = 200

	-- G36MagazineQuick
	-- STANAGMagazineLarge
	-- AK47MagazineMagLarge
	-- FNFALMagazine
	-- GalilMagazineLarge
	-- HKG3Magazine
	-- AA12Magazine
	-- M14MagazineLarge
	-- AUGMagazineLarge
	-- M14Magazine
	-- SVDMagazine
	-- GalilMagazine
	-- STANAGMagazine
	-- FAMASMagazine
	-- BarretM82Magazine
	-- AK47Magazine
	-- AK74MagazineLarge
	-- BarretM82MagazineLarge
	-- HKG3MagazineLarge
	-- FNFALMagazineLarge
	-- AUGMagazine
	-- G36MagazineLarge
	-- AK74Magazine

	SmgMag.Weight = 150

	-- MP40MagazineLarge
	-- UZIMagazine
	-- MP5Magazine
	-- MP40Magazine
	-- MP5MagazineLarge
	-- UZIMagazineLarge

	-- items where the weight is debateable for people who want to carry everything with them from town to town
	if CurrentModOptions['RevisedLighterItems'] then
		PETN.Weight = 330 -- 200 cm^3
		C4.Weight = 330 -- 200 cm^3
		TNT.Weight = 330 -- 200 cm^3

		ThrowableTrapItem.Weight = 350
		PipeBomb.Weight = 350

		Meds.Weight = 50 -- 25kg for a stack of 500
		Parts.Weight = 10 -- 5kg for a stack of 500

		MiscItem.Weight = 100

		CombatStim.Weight = 100
		MetaviraShot.Weight = 100
		HerbalMedicine.Weight = 50

		Medicine.Weight = 500
		FirstAidKit.Weight = 500 -- max_meds_parts: 8
		Medkit.Weight = 1000     -- max_meds_parts: 12
		Reanimationsset.Weight = 1250 -- max_meds_parts: 12

		MoneyBag.Weight = 1000

		TreasureMask.Weight = 1000
		TreasureGoldenDog.Weight = 1000
		TreasureTablet.Weight = 1000
		TreasureFigurine.Weight = 1000
		TreasureIdol.Weight = 1000

		CrowbarBase.Weight = 3000
	end

	Msg("RevisedWeightAddedToItemProperties")
end
