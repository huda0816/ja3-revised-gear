function UnitProperties:GetInventoryMaxSlots()
  local inventorySlots = 6
  local LBE = self:GetItemInSlot("Inventory", nil, 1, 1)
  if IsKindOf(LBE, "LBE") then
      inventorySlots = inventorySlots + LBE.InventorySlots
  end
  return IsMerc(self) and inventorySlots or self.max_dead_slot_tiles 
end


function LBECorrectSlot()

end


local tile_size = 90
local tile_size_rollover = 110

TileConfig = {
  Type = "Small",
  Size = "Small",
}

function XInventoryTile:Init()
  local k =1
  local emptyImage = "UI/Inventory/T_Backpack_Slot_Small_Empty.tga"
  local hoverImage = "UI/Inventory/T_Backpack_Slot_Small_Hover.tga"
  local imageBase ="UI/Inventory/T_Backpack_Slot_Small.tga"
  if TileConfig.Size == "Large" then
      k = 2
      emptyImage = "UI/Inventory/T_Backpack_Slot_Large_Empty.tga"
      hoverImage = "UI/Inventory/T_Backpack_Slot_Large_Hover.tga"
      imageBase ="UI/Inventory/T_Backpack_Slot_Large.tga"
  end
  local image = XImage:new({
    MinWidth = tile_size * k,
    MaxWidth = tile_size * k,
    MinHeight = tile_size * k,
    MaxHeight = tile_size * k,
    Id = "idBackImage",
    Image = emptyImage,
    ImageColor = 4291018156
  }, self)
  if self.slot_image then
    local imgslot = XImage:new({
      MinWidth = tile_size*k,
      MaxWidth = tile_size*k,
      MinHeight = tile_size*k,
      MaxHeight = tile_size*k,
      Dock = "box",
      Id = "idEqSlotImage",
      ImageFit = "width"
    }, self)
    imgslot:SetImage(self.slot_image)
    image:SetImage(imageBase)
    image:SetImageColor(RGB(255, 255, 255))
  end
  local rollover_image = XImage:new({
    MinWidth = tile_size_rollover*k,
    MaxWidth = tile_size_rollover*k,
    MinHeight = tile_size_rollover*k,
    MaxHeight = tile_size_rollover*k,
    Id = "idRollover",
    Image = hoverImage,
    ImageColor = 4291018156,
    Visible = false
  }, self)
  rollover_image:SetVisible(false)
end

function Inventory:GetSlotDataDim(slot_name)
  --print(self:GetItemInSlot(slot_name, false, 1, 1))
  local slot_data = self:GetSlotData(slot_name)
  local width = slot_data.width
  local height = slot_data.height
  local max_tiles = self:GetMaxTilesInSlot(slot_name)
  local last_row_width = width
  if max_tiles < width * height then
    local rem = max_tiles % width
    height = max_tiles / width + (rem == 0 and 0 or 1)
    last_row_width = rem == 0 and width or rem
  end
  return width, height, last_row_width
end

function XInventorySlot:Setslot_name(slot_name)
  local context = self:GetContext()
  if not context then
    return
  end
  self.tiles = {}
  TileConfig.Type = "Small"
  TileConfig.Size = "Small"
  self.slot_name = slot_name
  local slot_data = context:GetSlotData(slot_name)
  local width, height, last_row_width = context:GetSlotDataDim(slot_name)
  

--CREATE LBE SLOT----------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

  --CREATE SUPPORT SLOTS----------------------------------------------------------------------------------------------------------
  if context.unitdatadef_id and (slot_name == "Inventory") then
      local row = 1
      local column = 1
      for i = 1, width do self.tiles[i] = {} end
      --CREATE LBE SLOT----------------------------------------------------------------------------------------------------------
      TileConfig.Type  = "LBE"
      TileConfig.Size = "Small"
      local tile = self:SpawnTile(slot_name, column, row)
      if tile then
        tile:SetContext(context)
        tile:SetGridX(column)
        tile:SetGridY(row)
        tile.idBackImage:SetTransparency(self.image_transparency)
        if slot_data.enabled == false then
          tile:SetEnabled(false)
        end
        tile.Type = TileConfig.Type
        self.tiles[column][row] = tile
      end

      --CREATE HOLSTER SLOT----------------------------------------------------------------------------------------------------------
      column = 2
      TileConfig.Type  = "Shoulder"
      TileConfig.Size = "Large"
      for i = column, column+1 do
          local tile = self:SpawnTile(slot_name, i, row)
          if tile then
              tile:SetContext(context)
              tile:SetGridX(i)
              tile:SetGridY(row)
              tile.idBackImage:SetTransparency(self.image_transparency)
              if slot_data.enabled == false then
              tile:SetEnabled(false)
              end
              tile.Type = TileConfig.Type
              self.tiles[i][row] = tile
          end
      end  

      --CREATE DEFAULT POCKETS----------------------------------------------------------------------------------------------------------
      column = 4

      TileConfig.Type  = "PocketL"
      TileConfig.Size = "Small"
      local tile = self:SpawnTile(slot_name, column, row)
      if tile then
        tile:SetContext(context)
        tile:SetGridX(column)
        tile:SetGridY(row)
        tile.idBackImage:SetTransparency(self.image_transparency)
        if slot_data.enabled == false then
          tile:SetEnabled(false)
        end
        tile.Type = TileConfig.Type
        self.tiles[column][row] = tile
      end

      column = 5

      TileConfig.Type  = "PocketS"
      TileConfig.Size = "Small"
      for i = column, width do
          local tile = self:SpawnTile(slot_name, i, row)
          if tile then
              tile:SetContext(context)
              tile:SetGridX(i)
              tile:SetGridY(row)
              tile.idBackImage:SetTransparency(self.image_transparency)
              if slot_data.enabled == false then
              tile:SetEnabled(false)
              end
              tile.Type = TileConfig.Type
              self.tiles[i][row] = tile
          end
      end  
      column = 1 
      row = 2
      --CREATE INVENTORY SLOTS----------------------------------------------------------------------------------------------------------
      TileConfig.Type = "Small"
      TileConfig.Size = "Small"
      for i = 1, width do
        for j = row, height do
          if j ~= height or i <= last_row_width then
            local tile = self:SpawnTile(slot_name, i, j)
            if tile then
              tile:SetContext(context)
              tile:SetGridX(i)
              tile:SetGridY(j)
              tile.idBackImage:SetTransparency(self.image_transparency)
              if slot_data.enabled == false then
                tile:SetEnabled(false)
              end
              tile.Type = TileConfig.Type
              self.tiles[i][j] = tile
            end
          end
        end
      end
  else
      for i = 1, width do
          TileConfig.Type = "PocketS"
          TileConfig.Size = "Small"
          self.tiles[i] = {}
          for j = 1, height do
          if j ~= height or i <= last_row_width then
              local tile = self:SpawnTile(slot_name, i, j)
              if tile then
              tile:SetContext(context)
              tile:SetGridX(i)
              tile:SetGridY(j)
              tile.idBackImage:SetTransparency(self.image_transparency)
              if slot_data.enabled == false then
                  tile:SetEnabled(false)
              end
              tile.Type = TileConfig.Type
              self.tiles[i][j] = tile
              end
          end
          end
      end
  end
  self.item_windows = {}
  self.rollover_windows = {}
  self:InitialSpawnItems()
end

function XInventoryTile:OnDropEnter(drag_win, pt, drag_source_win)
  local drag_item = InventoryDragItem
  local mouse_text
  local slot = self:GetInventorySlotCtrl()
  if slot.slot_name=="Inventory" then
      local fits, reason = ItemFitsTile(drag_item, self)
      if not fits then mouse_text = reason
  end
  else
      mouse_text = InventoryGetMoveIsInvalidReason(slot.context, InventoryStartDragContext)
      local wnd, under_item = slot:FindItemWnd(pt)
      if under_item == drag_item then
          under_item = false
      end
      local is_reload = IsReload(drag_item, under_item)
      local ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, slot:GetContext(), slot.slot_name, under_item, is_reload)
  end

  if not mouse_text then
    mouse_text = action_name or ""
    if InventoryIsCombatMode() and ap_cost and 0 < ap_cost then
      mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
    end
  end
  InventoryShowMouseText(true, mouse_text)
  HighlightDropSlot(self, true, pt, drag_win)
  HighlightAPCost(InventoryDragItem, true, self)
end

function XInventorySlot:DragDrop_MoveItem(pt, target, check_only)
  if not InventoryDragItem then
    return "no item being dragged"
  end
  if not (target and InventoryIsValidTargetForUnit(self.context) and InventoryIsValidTargetForUnit(InventoryStartDragContext)) or not InventoryIsValidGiveDistance(self.context, InventoryStartDragContext) then
    return "not valid target"
  end
  local item = InventoryDragItem
  local dest_slot = target.slot_name
  local _, pt = self:GetNearestTileInDropSlot(pt)
  local _, dx, dy = target:FindTile(pt)
  if not dx then
    return "no target tile"
  end
  local tile = target.tiles[dx][dy]

  if target.slot_name == "Inventory" then
      local fits, reason = ItemFitsTile(item, tile)
      if not fits then return reason end
  end
  local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)
  if item.LargeItem then
    dx = dx - sdx
    if IsEquipSlot(dest_slot) then
      dx = 1
    end
  end
  local dest_container = target:GetContext()
  local src_container = InventoryStartDragContext
  local under_item = dest_container:GetItemInSlot(dest_slot, nil, dx, dy)
  local src_slot_name = InventoryStartDragSlotName
  local use_alternative_swap_pos = IsEquipSlot(dest_slot) and not IsEquipSlot(src_slot_name) and not not under_item
  local args = {
    item = item,
    src_container = src_container,
    src_slot = src_slot_name,
    dest_container = dest_container,
    dest_slot = dest_slot,
    dest_x = dx,
    dest_y = dy,
    check_only = check_only,
    exec_locally = false,
    alternative_swap_pos = use_alternative_swap_pos
  }
  local r1, r2, sync_unit = MoveItem(args)
  if r1 or not check_only then
    PlayFXOnMoveItemResult(r1, item, dest_slot, sync_unit)
  end
  if not r1 and not check_only and (not r2 or r2 ~= "no change") then
    self:Gossip(item, src_container, target, ssx, ssy, dx, dy)
  end
  return r1, r2
end

function ItemFitsTile(item, tile)
  if IsKindOfClasses(item, "AssualtRifle", "SniperRifle", "MachineGun", "Shotgun") then
      if tile.Type == "Shoulder" then return true
      else return false, "Doesn't fit here" end
  end
  if IsKindOf(item, "Pistol") then
      if tile.Type == "PistolHolster" or tile.Type == "PocketL" then return true
      else return false, "Doesn't fit here" end
  end
  if IsKindOfClasses(item, "LBE") then
      if tile.Type == "LBE" or tile.Type == "PocketL" then return true
      else return false, "Doesn't fit here" end
  end
  return true, "Doesn't fit here"
end

function CreateLargeTile(tileSet)
end