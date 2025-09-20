local blue = { r = 30, g = 130, b = 252 }
local yellow = { r = 249, g = 245, b = 14 }
local grey = { r = 150, g = 150, b = 150 }

local clues = {
  -- hard
  dwf = { text = "[map: search a crate in the centre of the dark warriors' fortress]" },
  fortforinthry = {
    text = "[map: search a crate outside the gate of fort forinthry]",
    x = 3312,
    y = 3528,
    level = 0,
    radius = 1,
    indicators = {
      { type = "line", col = yellow, x1 = 3293, y1 = 3544, x2 = 3303, y2 = 3534, h1 = 713, h2 = 473 },
      { type = "line", col = blue, x1 = 3303, y1 = 3534, x2 = 3311, y2 = 3526, h1 = 473, h2 = 705 },
      { type = "line", col = grey, x1 = 3311, y1 = 3526, x2 = 3311, y2 = 3527, h1 = 705, h2 = 649 },
      { type = "line", col = grey, x1 = 3311, y1 = 3527, x2 = 3312, y2 = 3527, h1 = 649, h2 = 665 },
      { type = "arrow", x = 3312, y = 3528, h = 1445 },
    },
  },
  legendsguild = {
    text = "[map: dig near some benches outside the legends' guild]",
    x = 2722,
    y = 3338,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = yellow, x1 = 2728, y1 = 3346, x2 = 2722, y2 = 3338, h1 = 2177, h2 = 1073 },
      { type = "arrow", x = 2722, y = 3338, h = 2273 },
      { type = "dig", x = 2722, y = 3338, h = 2673 },
    },
  },
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
  threevolcanoes = {
    text = "[map: dig between three small volcanoes in the wilderness]",
    x = 3021,
    y = 3912,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = yellow, x1 = 3052, y1 = 3951, x2 = 3042, y2 = 3941, h1 = 1865, h2 = 2049 },
      { type = "line", col = blue, x1 = 3042, y1 = 3941, x2 = 3032, y2 = 3931, h1 = 2049, h2 = 1249 },
      { type = "line", col = blue, x1 = 3032, y1 = 3931, x2 = 3030, y2 = 3929, h1 = 1249, h2 = 1865 },
      { type = "line", col = blue, x1 = 3030, y1 = 3929, x2 = 3028, y2 = 3927, h1 = 1865, h2 = 2161 },
      { type = "line", col = blue, x1 = 3028, y1 = 3927, x2 = 3023, y2 = 3922, h1 = 2161, h2 = 2289 },
      { type = "line", col = blue, x1 = 3023, y1 = 3922, x2 = 3022, y2 = 3921, h1 = 2289, h2 = 2657 },
      { type = "line", col = grey, x1 = 3022, y1 = 3921, x2 = 3022, y2 = 3919, h1 = 2657, h2 = 2753 },
      { type = "line", col = grey, x1 = 3022, y1 = 3919, x2 = 3022, y2 = 3916, h1 = 2753, h2 = 2473 },
      { type = "line", col = grey, x1 = 3022, y1 = 3916, x2 = 3022, y2 = 3913, h1 = 2473, h2 = 2457 },
      { type = "arrow", x = 3021, y = 3912, h = 3657 },
      { type = "dig", x = 3021, y = 3912, h = 4057 },
    },
  },
  westardougne = {
    text = "[map: dig in a house in west ardougne]",
    x = 2488,
    y = 3308,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = grey, x1 = 2538, y1 = 3306, x2 = 2536, y2 = 3306, h1 = 1233, h2 = 1209 },
      { type = "line", col = blue, x1 = 2536, y1 = 3306, x2 = 2526, y2 = 3306, h1 = 1209, h2 = 1193 },
      { type = "line", col = grey, x1 = 2526, y1 = 3306, x2 = 2510, y2 = 3302, h1 = 1193, h2 = 1305 },
      { type = "line", col = grey, x1 = 2510, y1 = 3302, x2 = 2508, y2 = 3302, h1 = 1305, h2 = 1305 },
      { type = "line", col = blue, x1 = 2508, y1 = 3302, x2 = 2498, y2 = 3302, h1 = 1305, h2 = 1161 },
      { type = "line", col = yellow, x1 = 2498, y1 = 3302, x2 = 2488, y2 = 3309, h1 = 1161, h2 = 1145 },
      { type = "arrow", x = 2488, y = 3308, h = 2325 },
      { type = "dig", x = 2488, y = 3308, h = 2725 },
    },
  },
  yanillecorner = {
    text = "[map: dig behind a house in the southeast corner of yanille]",
    x = 2616,
    y = 3077,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = grey, x1 = 2575, y1 = 3089, x2 = 2582, y2 = 3096, h1 = 1001, h2 = 985 },
      { type = "line", col = grey, x1 = 2582, y1 = 3096, x2 = 2587, y2 = 3096, h1 = 985, h2 = 985 },
      { type = "line", col = blue, x1 = 2587, y1 = 3096, x2 = 2597, y2 = 3096, h1 = 985, h2 = 985 },
      { type = "line", col = yellow, x1 = 2597, y1 = 3096, x2 = 2607, y2 = 3086, h1 = 985, h2 = 985 },
      { type = "line", col = blue, x1 = 2607, y1 = 3086, x2 = 2615, y2 = 3078, h1 = 985, h2 = 985 },
      { type = "arrow", x = 2616, y = 3077, h = 2165 },
      { type = "dig", x = 2616, y = 3077, h = 2565 },
    },
  },
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
