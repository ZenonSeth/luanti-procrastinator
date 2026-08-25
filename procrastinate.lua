local CHANCE = tonumber(core.settings:get("procrastinator_chance")) or 0.15

local place_excuses = {
  "I'll do it later.",
  "Let me finish something else first.",
  "Five more minutes...",
  "Yeah, not feeling it right now.",
  "Maybe tomorrow.",
  "I work better under pressure anyway.",
  "I'm too tired.",
  "Yeah, no. No thanks.",
  "Don't rush me, I'm thinking!",
  "Ask me again after lunch.",
  "I'm on a break.",
  "That spot looks tired, let it rest.",
  "Ugh, fine.. actually no.",
  "I need to stretch first.",
  "I'll add it to my to-do list.",
}

local dig_excuses = {
  "It's fine where it is.",
  "I'll dig it out tomorrow.",
  "Not in the mood to dig right now.",
  "That node deserves to live.",
  "Let's not and say we did.",
  "I'll get to it eventually.",
  "Ehh. Some other day.",
  "Don't rush me, I'm thinking!",
  "Digging is a big commitment.",
  "That node has rights too.",
  "One does not simply dig on command.",
  "Ask again later, I'm busy with.. something.",
  "I need to think about this one.",
  "Nah, I'm good.",
}

local function wrap_on_place(original_on_place)
  return function(itemstack, placer, pointed_thing)
    if math.random() < CHANCE then
      if placer and placer:is_player() then
        procrastinator.show_popup(placer:get_player_name(),
          place_excuses[math.random(#place_excuses)])
      end
      return itemstack
    end
    return original_on_place(itemstack, placer, pointed_thing)
  end
end

local function wrap_can_dig(original_can_dig)
  return function(pos, player)
    if math.random() < CHANCE then
      if player and player:is_player() then
        procrastinator.show_popup(player:get_player_name(),
          dig_excuses[math.random(#dig_excuses)])
      end
      return false
    end
    if original_can_dig then
      return original_can_dig(pos, player)
    end
    return true
  end
end

core.register_on_mods_loaded(function()
  for name, def in pairs(core.registered_nodes) do
    local overrides = {}
    if def.on_place then
      overrides.on_place = wrap_on_place(def.on_place)
    end
    overrides.can_dig = wrap_can_dig(def.can_dig)
    core.override_item(name, overrides)
  end
end)
