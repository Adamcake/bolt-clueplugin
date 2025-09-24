return {get = function(bolt)
  local points = require("compass.points")
  local checkintervalmicros = 100000 -- tenth of a second
  local markeractive = bolt.images.markeractive

  local anglediffminimum = 0.2 -- 0.2 radians = about 11 degrees. no particular reason, just a small but significant angle
  local radians360 = math.pi * 2
  local maxscanpoints = 3
  local minframes = 5 -- minimum number of check-frames the player position and arrow angle must stay the same for the reading to be valid
  local tilefactor = 512

  local function create (bolt, onaddline)
    -- returns the difference between two angles, accounting for (literal) edge-cases,
    -- e.g. the difference between 1 degree and 359 degrees would return 2, not 358.
    local function radiandiff (a, b)
      local amod = a % radians360
      local bmod = b % radians360
      if amod > bmod then
        return math.min(amod - bmod, (bmod + radians360) - amod)
      else
        return math.min(bmod - amod, (amod + radians360) - bmod)
      end
    end

    local function onrender3d (this, event)
      this.renderviewproj = event:viewprojmatrix()
      this.hasrecentmatrices = true
    end

    local function onrenderbigicon (this, event)
      if event:modelcount() == 1 and event:modelvertexcount(1) == 93 then
        this.lastrendercompasspoint = true
        return
      elseif this.lastrendercompasspoint and event:modelcount() == 1 and event:modelvertexcount(1) == 42 then
        this.arrowfound = true
        if not this.arrowfoundpreviousframe then
          this.unchangedframes = 0
          this.lastangle = nil
        end
        local t = bolt.time()
        if t >= this.nextchecktime then
          local transform = event:modelmodelmatrix(1)
          local x1, y1, _ = bolt.point(0, 6, 0):transform(transform):get()
          local x2, y2, _ = bolt.point(0, 6, 1):transform(transform):get()
          local arrowdirection = math.atan2(y2 - y1, x2 - x1)
          local lastx, _, lastz = bolt.playerposition():get()

          local changed = arrowdirection ~= this.lastangle or lastx ~= this.lastx or lastz ~= this.lasty
          if changed then
            this.lastangle = arrowdirection
            this.lastx = lastx
            this.lasty = lastz
            this.unchangedframes = 0
          else
            this.unchangedframes = this.unchangedframes + 1
          end

          if this.unchangedframes >= minframes and this.scancount < maxscanpoints then
            local use = true
            for _, s in ipairs(this.scanpoints) do
              if radiandiff(s.direction, arrowdirection) < anglediffminimum then
                use = false
                break
              end
            end

            if use then
              local i = this.scancount + 1
              this.scanpoints[i] = {x = lastx / tilefactor, y = lastz / tilefactor, direction = arrowdirection}
              this.scancount = i
              onaddline()
            end
          end

          this.nextchecktime = this.nextchecktime + checkintervalmicros
          if this.nextchecktime < t then
            this.nextchecktime = t
          end
        end
      end
      this.lastrendercompasspoint = false
    end

    local function onswapbuffers (this, event)
      if this.hasrecentmatrices then
        local gx, gy, gw, gh = bolt.gameviewxywh()
        for i, point in pairs(this.pointlist) do
          local p = bolt.point((point.x + 0.5) * tilefactor, point.y, (point.z + 0.5) * tilefactor)
          local px, py, pdist = p:transform(this.renderviewproj):aspixels()
          if pdist > 0.0 and pdist <= 1.0 and px >= gx and py >= gy and px <= (gx + gw) and py <= (gy + gh) then
            local scale = 0.75
            local imgradius = 16 * scale
            local imgsize = 32 * scale
            markeractive.surface:drawtoscreen(0, 0, markeractive.w, markeractive.h, px - imgradius, py - imgradius, imgsize, imgsize)
          end
        end
      end

      this.hasrecentmatrices = false
      this.renderviewproj = nil
      this.lastrendercompasspoint = false
      this.arrowfoundpreviousframe = this.arrowfound
      this.arrowfound = false
    end

    local function valid (this)
      return this.arrowfoundpreviousframe
    end

    return {
      pointlist = points.get(),
      scanpoints = {},
      scancount = 0,
      nextchecktime = bolt.time(),
      hasrecentmatrices = false,
      lastrendercompasspoint = false,
      arrowfound = false,
      arrowfoundpreviousframe = false,

      lastx = 0,
      lasty = 0,
      lastangle = nil,
      unchangedframes = 0,

      onrender3d = onrender3d,
      onrenderbigicon = onrenderbigicon,
      onswapbuffers = onswapbuffers,
      valid = valid,
    }
  end
  return {create = create}
end}
