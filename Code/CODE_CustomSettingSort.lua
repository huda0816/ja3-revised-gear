-- Original author: Tobias from abandoned "Custom Settings" mod. (Slightly modified)

-- generates a sort order table for all items in the game
function CS_SortOrder(return_names)
	local arr = PresetArray("InventoryItemCompositeDef")
	local sorted = {}

	-- used to make it easier to change the way items are sorted
	local Rule = function(selector_func, ...)
		local sort = {}
		-- remove items from arr using a selector func
		sort, arr = table.isplit(arr, function(i, obj) return selector_func(obj) end)

		-- create proxys for all items
		sort = table.map(sort, function(v)
			local x = {}
			setmetatable(x, { __index = v })

			-- add transformed data here
			x.display_name = x:GetProperty("DisplayName") or Untranslated(x.id)

			return x
		end)

		-- sort removed items according to provided sorters
		for _, sorter in ipairs(table.pack(...)) do
			if type(sorter) == "function" then
				table.stable_sort(sort, sorter)
			elseif type(sorter) == "string" then
				if sorter == "display_name_asc" then
					-- use localized item names and language based sorting
					TSort(sort, function(x) return x.display_name end)
				end
			end
		end

		-- finally add them to sorted
		for _, v in ipairs(sort) do
			table.insert(sorted, getmetatable(v).__index)
		end
	end

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- Sorting rules
	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	-- Personal items (name)
	Rule(function(i) return string.find(i.group, "^Personal") end,
		"display_name_asc")

	-- Resources (ResourceItem first, then by name)
	Rule(function(i) return i.group == "Resources" end,
		"display_name_asc",
		function(a, b)
			return ((a.object_class == "ResourceItem") and 1 or 0) >
				((b.object_class == "ResourceItem") and 1 or 0)
		end)

	-- Upgrade (name)
	Rule(function(i) return i.group == "Upgrade" end,
		"display_name_asc")

	-- Magazines (name)
	Rule(function(i) return i.group == "Magazines" end,
		"display_name_asc")

	-- Ammo (caliber)
	Rule(function(i) return i.group == "Ammo" end,
		function(a, b) return a.Caliber < b.Caliber end)

	-- Ammo - Ordnance (name)
	Rule(function(i) return i.group == "Ammo - Ordnance" end,
		"display_name_asc")

	-- Grenades (name)
	Rule(function(i) return string.find(i.group, "^Grenade") end,
		"display_name_asc")

	-- Other - Meds (name)
	Rule(function(i) return i.group == "Other - Meds" end,
		"display_name_asc")

	-- Other - Tools (name)
	Rule(function(i) return i.group == "Other - Tools" end,
		"display_name_asc")

	-- Armor (name, put transmuted armors before other of same class)
	Rule(function(i) return string.find(i.group, "^Armor") end,
		function(a, b)
			return ((a.object_class == "TransmutedArmor") and 1 or 0) >
				((b.object_class == "TransmutedArmor") and 1 or 0)
		end,
		"display_name_asc")

	-- Firearm (name)
	Rule(function(i) return string.find(i.group, "^Firearm") end,
		"display_name_asc")

	-- Melee weapon (name)
	Rule(function(i) return string.find(i.group, "^MeleeWeapon") end,
		"display_name_asc")

	-- Valuables (name)
	Rule(function(i) return i.group == "Valuables" end,
		"display_name_asc")

	-- Quest (name)
	Rule(function(i) return string.find(i.group, "^Quest") end,
		"display_name_asc")

	-- Beasts (name)
	Rule(function(i) return i.group == "Beasts" end,
		"display_name_asc")

	-- Catch all (name)
	Rule(function(i) return true end, "display_name_asc")

	if return_names == nil then
		-- return the generated table
		local items = table_kvmap_adv(sorted, "id", function(k, v, i) return i end)
		return items
	else
		-- option to visualize the sort order of items
		local max_lengths = {}

		local update_max_length = function(name, len)
			max_lengths[name] = (len > (max_lengths[name] or 0)) and len or (max_lengths[name] or 0)
		end

		-- get display columns with calculated string max lengths
		local items = table.map(sorted, function(v)
			local name = TDevModeGetEnglishText(v.DisplayName, false, "no_assert")
			name = (name ~= "Missing text") and name or v.id

			local obj = {
				["group"] = v.group or "Unknown",
				["object_class"] = v.object_class,
				["name"] = name,
			}

			for k, v in pairs(obj) do
				update_max_length(k, #tostring(v))
			end

			return obj
		end)

		-- generate the monospace table
		local strs = table.map(items, function(v)
			return string.format(
				table.concat(
					table.map({ "group", "object_class", "name" },
						function(k) return "%- " .. (max_lengths[k]) .. "s" end), "  "),
				v.group, v.object_class, v.name)
		end)

		return strs
	end
end

function table_kvmap_adv(t, f_k, f_v)
	local new = {}
	local f_k_isFunc = (type(f_k) == "function")
	local f_v_isFunc = (type(f_v) == "function")

	local i = 1
	for k, v in pairs(t) do
		local _k = f_k_isFunc and f_k(k, v, i) or v[f_k]
		local _v = (f_v_isFunc and f_v(k, v, i)) or v[f_v]
		new[_k] = _v
		i = i + 1
	end
	return new
end

local CS_SortLookupTable = nil

function CS_Sort(container)
	-- check gv_SatelliteView to make sure we are in satellite view
	-- check gv_SectorInventory to make sure there is a sector inventory
	-- (does not need to be open, if nil or false, definitely not open)
	if gv_SatelliteView == false then
		return
	end

	local container = container or gv_SectorInventory

	if not container then
		return
	end

	local inventory = container.Inventory

	-- IsKindOf will return nil or true, so make sure to not check for false
	if IsKindOf(container, "SectorStash") ~= true then
		return
	end

	-- get sector stash items and clear the generated Inventory
	local items = container:GetItems()
	local sector_id = container.sector_id

	table.clear(inventory)

	if #items <= 0 then
		return
	end

	-- generate the sort order lookup table
	local class_sortorder = CS_SortLookupTable
	if class_sortorder == nil then
		class_sortorder = CS_SortOrder()
		CS_SortLookupTable = class_sortorder
	end

	-- sort items
	local not_in_dict = 99999
	table.stable_sort(items, function(a, b)
		local a_order = class_sortorder[a.class] or not_in_dict
		local b_order = class_sortorder[b.class] or not_in_dict

		if a_order == b_order then
			if a.class == b.class then
				-- by stack size
				local is_stack = IsKindOf(a, "InventoryStack")
				if is_stack then
					return a.Amount > b.Amount
				end

				-- by item condition
				return a.Condition > b.Condition
			end

			-- this should not happen
			return a.class < b.class
		end

		-- by sort order
		return a_order < b_order
	end)

	-- re-populate the sector inventory (this is just a virtual table, the items are stored elsewhere)
	for _, item in ipairs(items) do
		-- call Inventory.AddItem to generate positions
		Inventory.AddItem(container, "Inventory", item)
	end

	InventoryUIRespawn()
end

function CS_Merge()
	local container = gv_SectorInventory

	local cdata, sector_inventory, idx = container:GetVirtualContainerData()

	local items = container:GetItems() or empty_table

	local vitems = cdata and cdata[3] or empty_table

	if #vitems > 0 or #items > 0 then
		-- local vitems = cdata[3] or empty_table

		-- transfer amounts
		for i = 1, #items do
			if IsKindOf(items[i], "InventoryStack") then
				for j = i + 1, #items do
					if items[i].class == items[j].class then
						local persisting = table.find_value(vitems, items[i]) and i or j
						local removing = persisting == i and j or i

						local transferAmount = Min(items[persisting].MaxStacks - items[persisting].Amount,
							items[removing].Amount)
						items[persisting].Amount = items[persisting].Amount + transferAmount
						items[removing].Amount = items[removing].Amount - transferAmount
					end
				end
			end
		end

		local orgItems = #items
		-- remove items that are left with Amount<=0
		for i = orgItems, 1, -1 do
			if items[i].Amount and items[i].Amount <= 0 then
				local item = table.remove(items, i)

				if table.find_value(vitems, item) then
					table.remove_value(vitems, item)
				end

				for _, sectorInv in ipairs(sector_inventory) do
					if table.find_value(sectorInv[3], item) then
						table.remove_value(sectorInv[3], item)
					end
				end

				DoneObject(item)

				Inventory.RemoveItem(container, "Inventory", item)
			end
		end

		CS_Sort(gv_SectorInventory)

		InventoryUIRespawn()
	end
end
