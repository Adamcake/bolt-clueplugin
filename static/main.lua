-- In this plugin, a "static clue" refers to any clue whose solution is to interact with a specific
-- NPC or object, or to dig at a fixed location. In other words it's every type of clue except for
-- scan and compass. Colloquially these are often grouped into seven different categories:
-- "anagram", "coordinate", "cryptic", "emote", "simple", "skill riddle challenge", and "map".
-- This plugin has no reason to draw any distinction between those categories (except for map).
-- It simply reads the text and matches it against a list of all the possible clue texts, or, in
-- the case of a map, it bases it on the first bigicon to get drawn.

local text = require("static.text")
local map = require("static.map")

-- 512 units per tile, as per bolt docs
local tilehalfscale = 256
local tilescale = tilehalfscale * 2

local linevs =
"layout (location = 0) in vec2 vXZ;"..
"layout (location = 0) uniform vec3 vP1;"..
"layout (location = 1) uniform vec3 vP2;"..
"layout (location = 2) uniform vec2 tilescale;"..
"layout (location = 4) uniform vec2 sin_cos;"..
"layout (location = 6) uniform mat4 viewproj;"..
"out highp vec4 vScreenPos;"..
"void main() {"..
  -- wx,wy,wz is the world position of the line pointing north
  "float wx = (vP1.x + (vXZ.x / 5.0)) * tilescale.s + tilescale.t;"..
  "float wy = mix(vP1.y, vP2.y, vXZ.y);"..
  "float wz = (vP1.z + (vXZ.y * distance(vP1.xz, vP2.xz))) * tilescale.s + tilescale.t;"..
  -- rotate around p1
  "highp vec2 p1offset = vP1.xz * tilescale.s + tilescale.t;"..
  "highp vec2 c = vec2(wx, wz) - p1offset;"..
  "highp vec4 wpos = vec4(p1offset.x + (c.x * sin_cos.t) - (c.y * sin_cos.s), wy, p1offset.y + (c.y * sin_cos.t) + (c.x * sin_cos.s), 1.0);"..
  "highp vec4 p = viewproj * wpos;"..
  "vScreenPos = p;"..
  "gl_Position = p * vec4(1.0, -1.0, 1.0, 1.0);"..
"}"

local linefs =
"in highp vec4 vScreenPos;"..
"layout (location = 3) uniform highp vec4 rgba;"..
"layout (location = 5) uniform sampler2D depthtex;"..
"out highp vec4 col;"..
"void main() {"..
  "highp float depth = texture(depthtex, ((vScreenPos.st / vScreenPos.q) + vec2(1.0, 1.0)) / 2.0).r;"..
  "highp float alpha = 1.0 - (smoothstep(depth, depth + (abs(gl_DepthRange.diff) * 0.01), gl_FragCoord.z) * 0.9);"..
  "col = vec4(rgba.stp / 255.0, rgba.q * alpha / 255.0);"..
"}"

local iconvs =
"layout (location = 0) in vec2 vXY;"..
"layout (location = 0) uniform vec2 tilescale;"..
"layout (location = 1) uniform vec3 dir_scale;"..
"layout (location = 4) uniform vec3 vPos;"..
"layout (location = 5) uniform mat4 viewproj;"..
"out highp vec2 xy;"..
"out highp vec4 vScreenPos;"..
"void main() {"..
  -- simplified 2d rotation of (vXY.x, 0) around (0, 0), taking advantage of vXY already being centered on 0
  "highp vec2 center = vPos.xz * tilescale.s + tilescale.t;"..
  "highp vec4 pos = vec4(center.x + (vXY.x * cos(dir_scale.s) * dir_scale.t), vPos.y + (vXY.y * dir_scale.p), center.y + (vXY.x * sin(dir_scale.s) * dir_scale.t), 1.0);"..
  "highp vec4 p = viewproj * pos;"..
  "xy = vXY;"..
  "vScreenPos = p;"..
  "gl_Position = p * vec4(1.0, -1.0, 1.0, 1.0);"..
"}"

local iconfs =
"in highp vec2 xy;"..
"in highp vec4 vScreenPos;"..
"layout (location = 2) uniform sampler2D tex;"..
"layout (location = 3) uniform sampler2D depthtex;"..
"out highp vec4 col;"..
"void main() {"..
  "highp float depth = texture(depthtex, ((vScreenPos.st / vScreenPos.q) + vec2(1.0, 1.0)) / 2.0).r;"..
  "highp float alpha = (1.0 - step(depth, gl_FragCoord.z)) * 0.8;"..
  "highp vec4 texCol = texture(tex, (xy + vec2(1.0, 1.0)) / 2.0);"..
  "col = vec4(texCol.stp, texCol.q * alpha);"..
"}"

local valid = function (_) return true end

return {
  get = function (bolt)
    local t = text.get(bolt)
    local m = map.get(bolt)
    local zeropoint = bolt.point(0, 0, 0)

    local lineprogram = bolt.createshaderprogram(bolt.createvertexshader(linevs), bolt.createfragmentshader(linefs))
    lineprogram:setattribute(0, 1, true, false, 2, 0, 2)
    lineprogram:setuniform2f(2, tilescale, tilehalfscale)
    local linebuffer = bolt.createshaderbuffer("\xFF\x00\x01\x00\x01\x01\xFF\x00\x01\x01\xFF\x01")

    local iconprogram = bolt.createshaderprogram(bolt.createvertexshader(iconvs), bolt.createfragmentshader(iconfs))
    iconprogram:setattribute(0, 1, true, false, 2, 0, 2)
    iconprogram:setuniform2f(0, tilescale, tilehalfscale)
    local iconbuffer = bolt.createshaderbuffer("\xFF\xFF\x01\xFF\x01\x01\xFF\xFF\x01\x01\xFF\x01")

    local onrender3d = function (this, event)
      if this.indicators then
        for _, indicator in ipairs(this.indicators) do
          if indicator.type ~= "model" then goto c1 end
          if indicator.anim ~= event:animated() then goto c1 end
          if indicator.vertices ~= event:vertexcount() then goto c1 end
          local x, y, z = event:vertexpoint(1):get()
          if x ~= indicator.x1 or y ~= indicator.y1 or z ~= indicator.z1 then goto c1 end
          local point = zeropoint:transform(event:modelmatrix())
          if indicator.points == nil then
            indicator.pointcount = 1
            indicator.points = { point }
          else
            indicator.pointcount = indicator.pointcount + 1
            indicator.points[indicator.pointcount] = point
          end
          --indicator.point = zeropoint:transform(event:modelmatrix())
          ::c1::
        end
      end

      if this.hasmatrices then return end
      this.viewprojmatrix = event:viewprojmatrix()
      this.camx, this.camy, this.camz = event:cameraposition()
      this.hasmatrices = true
    end

    local drawiconwithpositions = function (this, event, x, y, z, wx, wy, image, scale)
      local t = bolt.time() - this.t1
      local heightmod = 50 * math.sin(t / 500000.0)
      local dir = math.atan2(this.camz - wy, this.camx - wx) + (math.pi / 2)
      iconprogram:setuniform3f(1, dir, image.w * scale, image.h * -scale)
      iconprogram:setuniformsurface(2, image.surface)
      iconprogram:setuniformdepthbuffer(3, event)
      iconprogram:setuniform3f(4, x, y + heightmod, z)
      iconprogram:setuniformmatrix4f(5, false, this.viewprojmatrix:get())
      iconprogram:drawtogameview(event, iconbuffer, 6)
    end

    local drawicon = function (this, event, indicator, image, scale)
      drawiconwithpositions(this, event, indicator.x, indicator.h, indicator.y, indicator.x * tilescale + tilehalfscale, indicator.y * tilescale + tilehalfscale, image, scale)
    end

    -- onrendergameview calls the functions in this table for each indicator, according to
    -- indicator.type, so there's no need to validate "type" in these functions.
    -- this.hasmatrices is also validated before calling these functions.
    local indicatortypes = {
      line = function (this, event, indicator)
        local angle = indicator.angle
        if angle == nil then
          local dir = math.atan2(indicator.y2 - indicator.y1, indicator.x2 - indicator.x1) - (math.pi / 2)
          angle = { sin = math.sin(dir), cos = math.cos(dir) }
          indicator.angle = angle
        end

        local col = indicator.col
        lineprogram:setuniform3f(0, indicator.x1, indicator.h1, indicator.y1)
        lineprogram:setuniform3f(1, indicator.x2, indicator.h2, indicator.y2)
        lineprogram:setuniform4f(3, col.r, col.g, col.b, 255)
        lineprogram:setuniform2f(4, angle.sin, angle.cos)
        lineprogram:setuniformdepthbuffer(5, event)
        lineprogram:setuniformmatrix4f(6, false, this.viewprojmatrix:get())
        lineprogram:drawtogameview(event, linebuffer, 6)
      end,

      accel = function (this, event, indicator)
        drawicon(this, event, indicator, bolt.images.accel, 2)
      end,

      dig = function (this, event, indicator)
        drawicon(this, event, indicator, bolt.images.dig, 2)
      end,

      arrow = function (this, event, indicator)
        drawicon(this, event, indicator, bolt.images.arrow, 2.5)
      end,

      up = function (this, event, indicator)
        drawicon(this, event, indicator, bolt.images.arrow, -1.5)
      end,

      topfloor = function (this, event, indicator)
        drawiconwithpositions(this, event, indicator.x, indicator.h, indicator.y, indicator.x * tilescale + tilehalfscale, indicator.y * tilescale + tilehalfscale, bolt.images.arrow, -1.5)
        drawiconwithpositions(this, event, indicator.x, indicator.h + 200, indicator.y, indicator.x * tilescale + tilehalfscale, indicator.y * tilescale + tilehalfscale, bolt.images.arrow, -1.5)
      end,

      model = function (this, event, indicator)
        if indicator.points == nil then return end
        for _, point in ipairs(indicator.points) do
          local x, y, z = point:get()
          drawiconwithpositions(this, event, (x - tilehalfscale) / tilescale, y + indicator.h, (z - tilehalfscale) / tilescale, x, z, bolt.images.arrow, 2.5)
          if indicator.speech then
            drawiconwithpositions(this, event, (x - tilehalfscale) / tilescale, y + indicator.h + 300, (z - tilehalfscale) / tilescale, x, z, bolt.images.speech, 5)
          end
        end
        indicator.points = nil
        indicator.pointcount = 0
      end,
    }

    local onrendergameview = function (this, event)
      if not this.hasmatrices then return end
      local indicators = this.indicators
      if indicators == nil then return end
      for _, indicator in ipairs(indicators) do
        local f = indicatortypes[indicator.type]
        if f ~= nil then f(this, event, indicator) end
      end
      this.hasmatrices = false
    end

    local setfunctions = function (obj)
      obj.valid = valid
      obj.onrender3d = onrender3d
      obj.onrendergameview = onrendergameview
      obj.t1 = bolt.time()
      obj.static = true
    end

    return {
      textdata = t,
      mapdata = m,
      hasmatrices = false,

      trycreatefromtext = function (this, event, backgroundindex)
        local obj = this.textdata:lookup(event, backgroundindex)
        if obj ~= nil then setfunctions(obj) end
        return obj
      end,

      trycreatefrombigicon = function (this, event)
        local obj = this.mapdata:lookup(event)
        if obj ~= nil then setfunctions(obj) end
        return obj
      end,
    }
  end
}
