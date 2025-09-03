local clues = {
  -- hard
  dwf = { text = "[map: search a crate in the centre of the dark warriors' fortress]" },
  fortforinthry = { text = "[map: search a crate outside the gate of fort forinthry]" },
  legendsguild = { text = "[map: dig near some benches outside the legends' guild]" },
  observatory = { text = "[map: search a crate in a house northeast of the observatory]" },
  threevolcanoes = { text = "[map: dig between three small volcanoes in the wilderness]" },
  westardougne = { text = "[map: dig in a house in west ardougne]" },
  yanillecorner = { text = "[map: dig behind a house in the southeast corner of yanille]" },
}

local lookupbyvertexcount = {
  [6] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == -20 and y == 0 and z == 32 then return clues.observatory end
    if x == -20 and y == 0 and z == 68 then return clues.dwf end
    return nil
  end,
  [30] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == -20 and y == 0 and z == 60 then return clues.yanillecorner end
    return nil
  end,
  [72] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == -72 and y == 32 and z == -20 then return clues.legendsguild end
    return nil
  end,
  [84] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == -32 and y == 1 and z == -128 then return clues.westardougne end
    return nil
  end,
  [282] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == 0 and y == 32 and z == 24 then return clues.threevolcanoes end
    return nil
  end,
  [300] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == 68 and y == 1 and z == -336 then return clues.fortforinthry end
    return nil
  end,
}

return {
  get = function (bolt)
    return {
      lookupbyvertexcount = lookupbyvertexcount,

      -- try to resolve a renderbigicon event to a solution object from the "clues" table
      lookup = function (this, event)
        if event:modelcount() ~= 1 then return nil end
        local f = this.lookupbyvertexcount[event:modelvertexcount(1)]
        if f == nil then return nil end
        return f(event)
      end,
    }
  end,
}
