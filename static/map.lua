local clues = {
  threevolcanoes = { text = "[map: dig between three small volcanoes]" }
}

local lookupbyvertexcount = {
  [282] = function (event)
    local x, y, z = event:modelvertexpoint(1, 1):get()
    if x == 0 and y == 32 and z == 24 then return clues.threevolcanoes end
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
