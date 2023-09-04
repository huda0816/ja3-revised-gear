function BuildLBE(xTileObj,LBE)
    local column = 1
    local row = 2

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

function Unit:CreateSlotTypes()
    if not IsMerc(self) then return end
    
    local types = {}
    for i=1,6 do types[i]={} end
    types[1][1] = "LBE"
    types[2][1] = "PocketS"
    types[3][1] = "PocketS"
    types[4][1] = "PocketM"
    types[5][1] = "PocketL"
    types[6][1] = "Backpack"
  
    local LBE = self:GetItemInSlot("Inventory", nil, 1, 1)
    if IsKindOf(LBE, "LBE") then
        local column = 1
        local row = 2

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
    end
  
    self.inventory_slots["Inventory"].slot_types = types
  end
