local blue = { r = 30, g = 130, b = 252 }
local yellow = { r = 249, g = 245, b = 14 }
local grey = { r = 150, g = 150, b = 150 }

local clues = {
  -- hard
  dwf = { text = "[map: search a crate in the centre of the dark warriors' fortress]" },
  fortforinthry = { text = "[map: search a crate outside the gate of fort forinthry]" },
  legendsguild = { text = "[map: dig near some benches outside the legends' guild]" },
  observatory = {
    text = "[map: search a crate in a house northeast of the observatory]",
    x = 2457,
    y = 3182,
    level = 0,
    radius = 1,
    indicators = {
      { type = "line", col = yellow, x1 = 2443, y1 = 3180, x2 = 2447, y2 = 3176, h1 = 121, h2 = 185 },
      { type = "line", col = blue, x1 = 2447, y1 = 3176, x2 = 2457, y2 = 3166, h1 = 185, h2 = 185 },
      { type = "line", col = grey, x1 = 2457, y1 = 3166, x2 = 2459, y2 = 3166, h1 = 185, h2 = 705 },
      { type = "line", col = grey, x1 = 2459, y1 = 3166, x2 = 2459, y2 = 3168, h1 = 705, h2 = 1169 },
      { type = "line", col = blue, x1 = 2459, y1 = 3168, x2 = 2459, y2 = 3178, h1 = 1169, h2 = 2577 },
      { type = "line", col = grey, x1 = 2459, y1 = 3178, x2 = 2457, y2 = 3182, h1 = 2577, h2 = 2489 },
      { type = "arrow", x = 2457, y = 3182, h = 3169 },
    },
  },
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
