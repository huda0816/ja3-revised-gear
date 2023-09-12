function BuildLBE(xTileObj,LBE, column, row)
    for i = 1, LBE.LargeMag do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "LargeMag"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PistolMag do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PistolMag"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PistolHolster do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PistolHolster"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PocketS do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PocketS"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PocketM do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PocketM"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PocketL do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PocketL"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    for i = 1, LBE.PocketU do
        if column == 7 then
            column = 1
            row = row + 1
        end
        TileConfig.Type = "PocketU"
        TileConfig.Size = "Small"
        BuildPocket(xTileObj, column, row)
        column = column +1
    end
    return column, row
end

function BuildPocket(xTileObj, column, row)
    local tile =  xTileObj:SpawnTile("Inventory", column, row)
    if tile then
      tile:SetContext(xTileObj:GetContext())
      tile:SetGridX(column)
      tile:SetGridY(row)
      tile.idBackImage:SetTransparency( xTileObj.image_transparency)
      tile.Type = TileConfig.Type
      xTileObj.tiles[column][row] = tile
    end
end

function CreateSlotTypes(unit)
    if not IsMerc(unit) then return end

    local types = {}
    for i=1,6 do types[i]={} end
    types[1][1] = "LBE"
    types[2][1] = "PocketS"
    types[3][1] = "PocketS"
    types[4][1] = "PocketU"
    types[5][1] = "PocketU"
    types[6][1] = "Backpack"
  
    local LBE = unit:GetItemInSlot("Inventory", nil, 1, 1)
    local column = 1
    local row = 2
    if IsKindOf(LBE, "LBE") then

        for i = 1, LBE.LargeMag do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "LargeMag"
            column = column +1
        end
        for i = 1, LBE.PistolMag do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PistolMag"
            column = column +1
        end
        for i = 1, LBE.PistolHolster do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PistolHolster"
            column = column +1
        end
        for i = 1, LBE.PocketS do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketS"
            column = column +1
        end
        for i = 1, LBE.PocketM do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketM"
            column = column +1
        end
        for i = 1, LBE.PocketL do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketL"
            column = column +1
        end
        for i = 1, LBE.PocketU do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketU"
            column = column +1
        end
    end

    local Backpack = unit:GetItemInSlot("Inventory", nil, 6, 1)

    if IsKindOf(Backpack, "Backpack") then
        for i = 1, Backpack.LargeMag do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "LargeMag"
            column = column +1
        end
        for i = 1, Backpack.PistolMag do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PistolMag"
            column = column +1
        end
        for i = 1, Backpack.PistolHolster do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PistolHolster"
            column = column +1
        end
        for i = 1, Backpack.PocketS do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketS"
            column = column +1
        end
        for i = 1, Backpack.PocketM do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketM"
            column = column +1
        end
        for i = 1, Backpack.PocketL do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketL"
            column = column +1
        end
        for i = 1, Backpack.PocketU do
            if column == 7 then
                column = 1
                row = row + 1
            end
            types[column][row] = "PocketU"
            column = column +1
        end
    end
  
    return types
  end
