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
  if TileConfig.Type == "LargeMag" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Mag.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Mag.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Mag.png"
  elseif TileConfig.Type == "LBE" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_LBE.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_LBE.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_LBE.png"
  elseif TileConfig.Type == "PistolMag" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_MagPistol.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_MagPistol.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_MagPistol.png"
  elseif TileConfig.Type == "PistolHolster" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PistolHolster.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PistolHolster.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PistolHolster.png"
  elseif TileConfig.Type == "PocketS" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketS.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketS.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketS.png"
  elseif TileConfig.Type == "PocketM" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketM.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketM.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketM.png"
  elseif TileConfig.Type == "PocketL" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketL.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketL.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_PocketL.png"
  elseif TileConfig.Type == "Backpack" then
    emptyImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Backpack.png"
    hoverImage = "Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Backpack.png"
    imageBase ="Mod/ii6mKUf/Images/T_Backpack_Slot_Small_Backpack.png"
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

function XInventorySlot:Setslot_name(slot_name)
  local context = self:GetContext()
  --print(context:GetItemInSlot("Inventory", nil, 1, 1))
  local LBE = context:GetItemInSlot("Inventory", nil, 1, 1)
  local Backpack = context:GetItemInSlot("Inventory", nil, 6, 1)
  if not context then
    return
  end
  self.tiles = {}
  TileConfig.Type = "PocketU"
  TileConfig.Size = "Small"
  self.slot_name = slot_name
  local slot_data = context:GetSlotData(slot_name)
  local width, height, last_row_width = context:GetSlotDataDim(slot_name)
  


  --CREATE SUPPORT SLOTS----------------------------------------------------------------------------------------------------------
  if context.session_id and (slot_name == "Inventory") then
    local row = 1
    local column = 1
    for i = 1, width do self.tiles[i] = {} end
    --CREATE LBE SLOT----------------------------------------------------------------------------------------------------------
    TileConfig.Type = "LBE"
    TileConfig.Size = "Small"
    BuildPocket(self, column, row)
    column = column +1


    --CREATE DEFAULT POCKETS----------------------------------------------------------------------------------------------------------
    for i = 1,2 do
      TileConfig.Type = "PocketS"
      TileConfig.Size = "Small"
      BuildPocket(self, column, row)
      column = column +1
    end

    TileConfig.Type = "PocketM"
    TileConfig.Size = "Small"
    BuildPocket(self, column, row)
    column = column +1

    TileConfig.Type = "PocketL"
    TileConfig.Size = "Small"
    BuildPocket(self, column, row)
    column = column +1

    TileConfig.Type = "Backpack"
    TileConfig.Size = "Small"
    BuildPocket(self, column, row)
    column = column +1
    --CREATE LBE----------------------------------------------------------------------------------------------------------
    if LBE then
      column, row = BuildLBE(self, LBE, column, row)
    end

    --CREATE BACKPACK----------------------------------------------------------------------------------------------------------
    if Backpack then
      BuildLBE(self, Backpack, column, row)
    end
  else
      for i = 1, width do
          TileConfig.Type = "PocketU"
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
  local _, dx, dy = slot:FindTile(pt)
  if slot.slot_name=="Inventory" then
      local fits, reason = ItemFitsTile(drag_item, self.Type, dx)
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
      local fits, reason = ItemFitsTile(item, tile.Type, dx)
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

function Inventory:FindEmptyPosition(slot_name, item, local_changes)
  local slot_data = self:GetSlotData(slot_name)
  
  local space = {}
  local width, height, last_row_width = self:GetSlotDataDim(slot_name)
  for i = 1, width do
    space[i] = {}
  end
  local free_space = self:GetMaxTilesInSlot(slot_name)
  local fe = local_changes and local_changes.force_empty
  self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top, space)
    local item_width = slot_item:GetUIWidth()
    local item_height = slot_item:GetUIHeight()
    for i = left, left + item_width - 1 do
      for j = top, top + item_height - 1 do
        if not fe or not fe[xxhash(i, j)] then
          space[i][j] = true
        else
          free_space = free_space + 1
        end
      end
    end
    free_space = free_space - item_width * item_height
  end, space)
  if last_row_width ~= width then
    for i = last_row_width + 1, width do
      space[i][height] = true
    end
  end
  if slot_name == "Inventory" and IsMerc(self) and self.session_id then
    local slot_types = CreateSlotTypes(self)
    if slot_types then
      for i = 1, width do
        for j = 1, height do
          if not ItemFitsTile(item, slot_types[i][j]) then
            space[i][j]=true
          end
        end
      end
    end
  end


  local iwidth = item:GetUIWidth()
  local iheight = item:GetUIHeight()
  if free_space < iwidth * iheight then
    return
  end
  local x, y = 1, 1
  local raw_width = width
  while x <= raw_width and height >= y and raw_width >= x + iwidth - 1 and height >= y + iheight - 1 do
    local full = false
    for i = x, x + iwidth - 1 do
      for j = y, y + iheight - 1 do
        if not space[i] or space[i][j] or local_changes and local_changes[xxhash(i, j)] then
          full = true
          break
        end
      end
      if full then
        break
      end
    end
    if not full then
      return x, y
    end
    x = x + 1
    if raw_width < x or raw_width < x + iwidth - 1 then
      x = 1
      y = y + 1
      if y == height then
        raw_width = last_row_width
      end
    end
  end
end

function XInventorySlot:OnDragDrop(target, drag_win, drop_res, pt)
  local result, result2 = self:DragDrop_MoveItem(pt, target)
  local sync_err = result == "NetStartCombatAction refused to start"
  for _, unit in pairs(g_Units) do
    if IsMerc(unit) then
        CheckItemsInWrongSlots(unit)
      end
  end
  self:ClearDragState(drag_win)
  if sync_err or result2 == "no change" then
    InventoryUIRespawn()
  end


end

