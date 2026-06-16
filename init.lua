
--init

local S = minetest.get_translator(minetest.get_current_modname())

local glass
local glass_fragment = ""
local glass_break_sound
local glass_tools = {
  ["glass_tools:pick_glass"] = true,
  ["glass_tools:axe_glass"] = true,
  ["glass_tools:shovel_glass"] = true,
  ["glass_tools:sword_glass"] = true
}

if minetest.get_modpath("default") then
  glass = "default:glass"
  glass_break_sound = default.node_sound_glass_defaults().dug
elseif minetest.get_modpath("mcl_sounds") then
  glass = "mcl_core:glass"
  glass_break_sound = mcl_sounds.node_sound_glass_defaults().dug
end

if minetest.get_modpath("vessels") then
  glass_fragment = "vessels:glass_fragments"
end

local function glass_tool_break(player)
  if player and player:is_player() then
    local player_name = player:get_player_name()

    if glass_break_sound then
      minetest.sound_play(glass_break_sound.name, {to_player = player_name, gain = glass_break_sound.gain or 1.0})
    end

    if 1 == math.random(1, 4) then
      player:set_hp(player:get_hp() - math.random(1, 3))

      return glass_fragment .. " 1"
    end

    return ""
  end

  return ""
end

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
  if itemstack and glass_tools[itemstack:get_name()] then
    if player and player:is_player() then
      if 1 == math.random(1, 8) then
        local player_name = player:get_player_name()

        if glass_break_sound then
          minetest.sound_play(glass_break_sound.name, {to_player = player_name, gain = glass_break_sound.gain or 1.0})
        end

        player:set_hp(player:get_hp() - math.random(1, 2))

        return glass_fragment .. " " .. math.random(1, 2)
      end
    end
  end
end)

minetest.register_tool("glass_tools:pick_glass", {
	description = S("Glass Pickaxe"),
	inventory_image = "glass_tools_pick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {},
		damage_groups = {fleshy = 4},
	},
	groups = {pickaxe = 1},
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing and pointed_thing.type ~= "nothing" then
      return glass_tool_break(user)
    end
  end
})

minetest.register_tool("glass_tools:axe_glass", {
	description = S("Glass Axe"),
	inventory_image = "glass_tools_axe.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level = 0,
		groupcaps = {},
		damage_groups = {fleshy = 3},
	},
	groups = {axe = 1},
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing and pointed_thing.type ~= "nothing" then
      return glass_tool_break(user)
    end
  end
})

minetest.register_tool("glass_tools:shovel_glass", {
	description = S("Glass Shovel"),
	inventory_image = "glass_tools_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {},
		damage_groups = {fleshy = 3},
	},
	groups = {shovel = 1},
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing and pointed_thing.type ~= "nothing" then
      return glass_tool_break(user)
    end
  end
})

minetest.register_tool("glass_tools:sword_glass", {
	description = S("Glass Sword"),
	inventory_image = "glass_tools_sword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {},
		damage_groups = {fleshy = 5},
	},
	groups = {sword = 1},
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing and pointed_thing.type ~= "nothing" then
      return glass_tool_break(user)
    end
  end
})

if glass then
  minetest.register_craft({
    output = "glass_tools:pick_glass 1",
    recipe = {
      {glass, glass, glass},
      {"", "group:stick", ""},
      {"", "group:stick", ""}
    }
  })

  minetest.register_craft({
    output = "glass_tools:axe_glass 1",
    recipe = {
      {glass, glass, ""},
      {glass, "group:stick", ""},
      {"", "group:stick", ""}
    }
  })

  minetest.register_craft({
    output = "glass_tools:shovel_glass 1",
    recipe = {
      {"", glass, ""},
      {"", "group:stick", ""},
      {"", "group:stick", ""}
    }
  })

  minetest.register_craft({
    output = "glass_tools:sword_glass 1",
    recipe = {
      {"", glass, ""},
      {"", glass, ""},
      {"", "group:stick", ""}
    }
  })
end
