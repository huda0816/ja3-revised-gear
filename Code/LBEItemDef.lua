UndefineClass("LBE")
DefineClass.LBE = {
    __parents = {
      "InventoryItem"
    },
    Weight = 1,
    PocketS = 1,
    PocketM = 1,
    PocketL = 1,
    LargeMag = 3,
    PistolMag = 3,
    PistolHolster = 1,
    PocketU = 0,
    InventorySlots = 10
}

UndefineClass("Backpack")
DefineClass.Backpack = {
    __parents = {
      "InventoryItem"
    },
    Weight = 1,
    PocketU = 3,
    PocketS = 0,
    PocketM = 0,
    PocketL = 0,
    LargeMag = 0,
    PistolMag = 0,
    PistolHolster = 0,
    InventorySlots = 3
}

function ItemFitsTile(item, type, column)
    if item.LargeItem and (column == 6 or column ==1) then return false, "Doesn't fit here" end
    if  type == "PocketU" then return true end

    if IsKindOf(item, "Ammo") then
        if type == "PocketS" or type == "PocketM" or type == "PocketL" or type == "LargeMag" or type == "PistolMag" then return true
        else return false, "Doesn't fit here" end
    end

    if IsKindOfClasses(item, "InventoryStack") then
        if type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end

    if IsKindOfClasses(item, "Backpack") then
        if type == "Backpack" or type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end

    if IsKindOfClasses(item, "AssualtRifle", "SniperRifle", "MachineGun", "Shotgun") then
        if type == "Shoulder" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "GasMask") then
        if type == "PocketM" or type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Wirecutter") then
        if type == "PocketM" or type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Armor") then
        if type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Medkit") then
        if type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Magazine") then
        if type == "PocketL" or type == "LargeMag" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Valuables") then
        if type == "PocketM" or type == "PocketL" or type == "LargeMag" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "Knife") then
        if type == "PocketS" or type == "PocketM" or type == "PocketL" or type == "LargeMag" or type == "PistolMag" then return true
        else return false, "Doesn't fit here" end
    end

    if IsKindOfClasses(item, "Crowbar") then
        if type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end

    if IsKindOfClasses(item, "Mag") then
        if item.Type == "Rifle" then
            if type == "PocketM" or type == "PocketL" or type == "LargeMag" then return true end
        elseif item.Type == "Pistol" then
            if type == "PocketS" or type == "PocketM" or type == "PocketL" or type == "LargeMag" or type == "PistolMag" then return true end
        elseif item.Type == "Large" then
            if type == "PocketL" then return true end
        else return false, "Doesn't fit here" end
        return false, "Doesn't fit here"
    end
    if IsKindOfClasses(item, "Grenade") then
        if type == "PocketM" or type == "PocketL" or type == "LargeMag" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOf(item, "Pistol") then
        if type == "PistolHolster" or type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    if IsKindOfClasses(item, "LBE") then
        if type == "LBE" or type == "PocketL" then return true
        else return false, "Doesn't fit here" end
    end
    return true
  end