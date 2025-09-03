-- In this plugin, a "static clue" refers to any clue whose solution is to interact with a specific
-- NPC or object, or to dig at a fixed location. In other words it's every type of clue except for
-- scan and compass. Colloquially these are often grouped into seven different categories:
-- "anagram", "coordinate", "cryptic", "emote", "simple", "skill riddle challenge", and "map".
-- This plugin has no reason to draw any distinction between those categories (except for map).
-- It simply reads the text and matches it against a list of all the possible clue texts, or, in
-- the case of a map, it bases it on the first bigicon to get drawn.

local text = require("static.text")
local map = require("static.map")

return {
  get = function (bolt)
    local t = text.get(bolt)
    local m = map.get(bolt)
    return {
      textdata = t,
      mapdata = m,

      trycreatefromtext = function (this, event, backgroundindex)
        return this.textdata:lookup(event, backgroundindex)
      end,

      trycreatefrombigicon = function (this, event)
        return this.mapdata:lookup(event)
      end,
    }
  end
}
