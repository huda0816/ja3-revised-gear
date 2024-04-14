function OnMsg.ClassesGenerate()
    AppendClass.InventoryItemProperties = {
        properties = {
            {
                id = "Weight",
                name = "Weight",
                editor = "number",
                default = 10,
                min = 0,
                max = 100000,
            }
        }
    }

    -- QuestItem
    QuestItem.Weight = 10
    WriterPage.Weight = 5
    WriterLetter.Weight = 10
    Pamphlets_LysRouge.Weight = 100
    Wig.Weight = 60
    MedicalReport.Weight = 30
    US_Passport.Weight = 50
    Coin.Weight = 5
    Pamphlets.Weight = 100
    WorkerDiary.Weight = 75
    WriterDiary.Weight = 75
    WeirdosMap.Weight = 15
    PaBaggzWill.Weight = 5
    VirusSample.Weight = 5
    Diesel.Weight = 3200

    QuestItemValuable.Weight = 100
    GoldenWatch.Weight = 100
    DiamondNecklace.Weight = 100

    -- Misc
    Meds.Weight = 50  -- 25kg for a stack of 500
    Parts.Weight = 10 -- 5kg for a stack of 500

    MiscItem.Weight = 100

    CombatStim.Weight = 100
    MetaviraShot.Weight = 100
    HerbalMedicine.Weight = 50

    Medicine.Weight = 500
    FirstAidKit.Weight = 500      -- max_meds_parts: 8
    Medkit.Weight = 1000          -- max_meds_parts: 12
    Reanimationsset.Weight = 1250 -- max_meds_parts: 12

    ValuableItemContainer.Weight = 5000
    WeaponShipment.Weight = 10000

    MoneyBag.Weight = 1000

    Valuables.Weight = 1000
    GoldBar.Weight = 340         -- 274.5 USD for 0.0311034768kg in 2000
    TinyDiamonds.Weight = 1      -- 500 USD 0.25 carats
    ChippedSapphire.Weight = 1   -- 350 USD 0.7 carats
    BigDiamond.Weight = 1        -- 5000 USD 1 carats
    DiamondBriefcase.Weight = 5000
    TheGreenDiamond.Weight = 621 -- Cullinan diamond 3106 carats

    TreasureMask.Weight = 1000
    TreasureGoldenDog.Weight = 1000
    TreasureTablet.Weight = 1000
    TreasureFigurine.Weight = 1000
    TreasureIdol.Weight = 1000

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

    ShapedCharge.Weight = 400
    FragGrenade.Weight = 400
    HE_Grenade.Weight = 400

    ThrowableTrapItem.Weight = 350
    -- PipeBomb
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
    WirecutterBase.Weight = 1000
    CrowbarBase.Weight = 3000

    -- crafting
    ExplosiveSubstance.Weight = 165
    TrapDetonator.Weight = 100
    Detonator.Weight = 100
    PETN.Weight = 330        -- 200 cm^3
    C4.Weight = 330          -- 200 cm^3
    TNT.Weight = 330         -- 200 cm^3
    BlackPowder.Weight = 330 -- 200 cm^3
    Combination_Detonator_Remote.Weight = 100
    Combination_Detonator_Proximity.Weight = 100
    Combination_Detonator_Time.Weight = 100
    Combination_Kompositum58.Weight = 500
    Combination_WeavePadding.Weight = 1000
    Combination_CeramicPlates.Weight = 3000
    Combination_Sharpener.Weight = 200
    Combination_BalancingWeight.Weight = 200
    FineSteelPipe.Weight = 2000
    OpticalLens.Weight = 50
    Microchip.Weight = 1

    -- Armor
    Armor.Weight = 2300           -- 6900 for 3 pieces
    TransmutedArmor.Weight = 5300 -- Armor + CeramicPlates

    GasMaskBase.Weight = 500
    Gasmaskenhelm.Weight = 1500
    NightVisionGoggles.Weight = 500

    IvanUshanka.Weight = 700

    NailsLeatherVest.Weight = 2000

    PostApoHelmet.Weight = 2200

    LightHelmet.Weight = 1000
    LightHelmet_Kompositum.Weight = 1200
    LightHelmet_WeavePadding.Weight = 1500

    FlakVest.Weight = 3500
    FlakVest_Kompositum.Weight = 4000
    FlakVest_WeavePadding.Weight = 4500
    FlakVest_CeramicPlates.Weight = 6500

    FlakArmor.Weight = 4000
    FlakArmor_Kompositum.Weight = 4500
    FlakArmor_WeavePadding.Weight = 5000
    FlakArmor_CeramicPlates.Weight = 7000

    CamoArmor_Light.Weight = 3500
    CamoArmor_Light_Kompositum.Weight = 4000

    FlakLeggings.Weight = 1800
    FlakLeggings_Kompositum.Weight = 2000
    FlakLeggings_WeavePadding.Weight = 2300

    HeavyArmorHelmet.Weight = 1800
    HeavyArmorHelmet_Kompositum.Weight = 2000
    HeavyArmorHelmet_WeavePadding.Weight = 2300

    HeavyArmorChestplate.Weight = 4500
    HeavyArmorChestplate_Kompositum.Weight = 5000
    HeavyArmorChestplate_WeavePadding.Weight = 5500
    HeavyArmorChestplate_CeramicPlates.Weight = 7500

    HeavyArmorTorso.Weight = 5500
    HeavyArmorTorso_Kompositum.Weight = 6000
    HeavyArmorTorso_WeavePadding.Weight = 6500
    HeavyArmorTorso_CeramicPlates.Weight = 8500

    HeavyArmorLeggings.Weight = 2300
    HeavyArmorLeggings_Kompositum.Weight = 2500
    HeavyArmorLeggings_WeavePadding.Weight = 2800

    KevlarHelmet.Weight = 1000
    KevlarHelmet_Kompositum.Weight = 1200
    KevlarHelmet_WeavePadding.Weight = 1500

    KevlarChestplate.Weight = 2500
    KevlarChestplate_Kompositum.Weight = 3000
    KevlarChestplate_WeavePadding.Weight = 3500
    KevlarChestplate_CeramicPlates.Weight = 5500

    KevlarVest.Weight = 3000
    KevlarVest_Kompositum.Weight = 3500
    KevlarVest_WeavePadding.Weight = 4000
    KevlarVest_CeramicPlates.Weight = 6000

    CamoArmor_Medium.Weight = 2000
    CamoArmor_Medium_Kompositum.Weight = 2500

    KevlarLeggings.Weight = 1500
    KevlarLeggings_Kompositum.Weight = 1700
    KevlarLeggings_WeavePadding.Weight = 2000

    ShamanHelmet.Weight = 1000
    ShamanTorso.Weight = 3000
    ShamanLeggings.Weight = 1500

    --MeleeWeapon
    MeleeWeapon.Weight = 250
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
    PSG1.Weight = 7500
    M24Sniper.Weight = 5400
    GoldenGun.Weight = 5200
    Winchester_Quest.Weight = 3100
    BarretM82.Weight = 13600
    Gewehr98.Weight = 4300
    Winchester1894.Weight = 3300

    --MachineGun
    MachineGun.Weight = 7000
    RPK74.Weight = 5300
    MG42.Weight = 11600
    HK21.Weight = 11400
    FNMinimi.Weight = 7500
    MG58.Weight = 11800

    -- HeavyWeapon
    HeavyWeapon.Weight = 10000
    Ordnance.Weight = 300

    Mortar.Weight = 18000
    MortarShell_Gas.Weight = 2200
    MortarShell_Smoke.Weight = 2100
    MortarShell_HE.Weight = 2300

    GrenadeLauncher.Weight = 6000
    _40mmFragGrenade.Weight = 230
    _40mmFlashbangGrenade.Weight = 170
    MGL.Weight = 6000

    RocketLauncher.Weight = 8000
    Warhead_Frag.Weight = 3500
    RPG7.Weight = 8500

    -- REV

    -- FaceItem

    -- Backpack

    -- Backpack_Combat
    -- Backpack_Retro_Large
    -- Backpack_Retro
    -- Backpack_Mule
    -- Backpack_Blackhawk
    -- Backpack_Modern

    -- LBE

    -- LBE_Basic_Army_Rig
    -- LBE_Combat_Vest
    -- LBE_SWAT_Vest
    -- LBE_Cheap_Vest
    -- LBE_Basic_Rig
    -- LBE_Modern_Army_Rig
    -- LBE_Heavy_Duty_Vest

    -- Holster

    -- Holster_Basic
    -- Holster_Extended
    -- Holster_Drop_Leg_Bag

    -- Mag

    -- LargeMag

    -- G36MagazineLarger
    -- FNMinimiMagazineLarge
    -- HKG3MagazineLarger
    -- FNMinimiMagazineLarger
    -- AK47MagazineMagLarger
    -- AA12MagazineLarge

    -- PistolMag

    -- BerettaMagazineLarge
    -- DesertEagleMagazine
    -- GlockMagazineLarge
    -- GlockMagazine
    -- DesertEagleMagazineLarge
    -- BHPMagazine
    -- BHPMagazineLarge
    -- BerettaMagazine

    -- RifleMag

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

    -- SmgMag

    -- MP40MagazineLarge
    -- UZIMagazine
    -- MP5Magazine
    -- MP40Magazine
    -- MP5MagazineLarge
    -- UZIMagazineLarge

    Msg("RevisedWeightAddedToItemProperties")
end
