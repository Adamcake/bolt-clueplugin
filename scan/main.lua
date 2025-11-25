return {get = function(bolt)
  local points = require("scan.points")

  local vs = bolt.createvertexshader(
    "layout(location=0) in highp vec2 pos;"..
    "out highp vec2 vpos;"..
    "void main() {"..
      "vpos = pos;"..
      "gl_Position = vec4(pos, 0.0, 1.0);"..
    "}"
  )
  local fs = bolt.createfragmentshader(
    "in highp vec2 vpos;"..
    "out highp vec4 col;"..
    "layout(location=0) uniform float factor;"..
    "void main() {"..
      "float angle = (atan(vpos.y, vpos.x) / radians(360.0)) + 0.25;"..
      "angle = mix(angle + 1.0, angle, step(0.0, angle));"..
      "float distfactor = 1.0 - ((abs(1.0 - (length(vpos) / 0.85)) * 25.0) - 1.5);"..
      "float anglefactor = step(angle, clamp(factor, 0.0, 1.0));"..
      "col = vec4(74.0 / 255.0, 1.0, 80.0 / 255.0, distfactor * anglefactor);"..
    "}"
  )
  local program = bolt.createshaderprogram(vs, fs)
  -- triangle 1: (-1,-1), (1,-1), (1,1)
  -- triangle 2: (-1,-1), (1,1), (-1,1)
  local shaderbuffer = bolt.createshaderbuffer("\xFF\xFF\x01\xFF\x01\x01\xFF\xFF\x01\x01\xFF\x01")
  -- layout(location=0), width of each number is 1, they're signed, they're not floats, there are 2 per attribute
  -- (because it's a vec2), offset from the start is 0 bytes, and stride between each attribute is 2 bytes.
  program:setattribute(0, 1, true, false, 2, 0, 2)

  local meerkats = false -- todo: set this from somewhere
  local checkinvertalmicros = 100000 -- a tenth of a second
  local statechangegraceperiod = 1200000 -- two game ticks
  local zeropoint = bolt.point(0, 0, 0)
  local markeractive = bolt.images.markeractive
  local markerinactive = bolt.images.markerinactive

  -- checks if the first vertex's model position matches the one shared by all 3 ring models.
  -- assumes there is at least one vertex
  local function modelmatchesrings (event)
    local x, y, z = event:vertexpoint(1):get()
    return x == 220 and y == 36 and z == 128
  end

  -- vertex count of 3D models for pulse, blue one-ring, orange two-ring and red three-ring, in that order
  local vertexcases3d = {
    [576] = 1,
    [864] = 2,
    [1728] = 3,
  }

  local function create (bolt, location)
    local pointlist, scanrange = points.get(location)
    if meerkats then
      scanrange = scanrange + 5
    end
    markerinactive.surface:setalpha(0.75)
    return {
      modelfound = false,
      renderviewproj = nil,
      lastringx = nil,
      lastringz = nil,
      checkframe = false,
      nextchecktime = bolt.time(),
      pointlist = pointlist,
      scanrange = scanrange,
      surfacemaybeloading = bolt.createsurface(markeractive.w, markeractive.h),

      onrender3d = function (this, event)
        local vertexcount = event:vertexcount()
        local modeltype = vertexcases3d[vertexcount]
        if modeltype then
          if not modelmatchesrings(event) then return end
          this.renderviewproj = event:viewprojmatrix()
          this.modelfound = true
          if not this.checkframe then return end
    
          markeractive.surface:setalpha((modeltype == 3) and 0.8 or 1)
          local ringworldpoint = zeropoint:transform(event:modelmatrix())
          local x, y, z = ringworldpoint:get()
          this.lastringx = x / 512.0
          this.lastringz = z / 512.0
          local time = bolt.time()
          
          for i, point in pairs(this.pointlist) do
            local dist = math.max(math.abs(point.x + 0.5 - this.lastringx), math.abs(point.z + 0.5 - this.lastringz))
            local disttype -- number of rings we'd expect to have right now if this was the correct dig spot
            if dist <= (this.scanrange + 0.5) then
              disttype = 3
            elseif dist <= ((this.scanrange * 2) + 0.5) then
              disttype = 2
            else
              disttype = 1
            end
            -- checking for state changes, states are as follows:
            -- -1: eliminated
            -- 0:  one-ring distance, one-ring model
            -- 1:  two-ring distance, two-ring model
            -- 2:  three-ring distance, three-ring model
            -- 3:  point is closer than model suggests
            -- 4:  point is further than model suggests
            if (point.state < 0) then goto continue end
            local state = ({
              [1] = {
                [1] = 0,
                [2] = 4,
                [3] = 4,
              },
              [2] = {
                [1] = 3,
                [2] = 1,
                [3] = 4,
              },
              [3] = {
                [1] = 3,
                [2] = 3,
                [3] = 2,
              },
            })[disttype][modeltype]
            if point.state ~= state then
              point.state = state
              point.laststatechange = time
            elseif (state >= 3) and (time - point.laststatechange >= statechangegraceperiod) then
              point.state = -1
              point.laststatechange = time
            end
            ::continue::
          end
        end
      end,

      onswapbuffers = function (this, event)
        local t = bolt.time()
        if this.checkframe then
          this.modelfound = false
          this.checkframe = false
        else
          if t >= this.nextchecktime then
            this.checkframe = true
            this.nextchecktime = this.nextchecktime + checkinvertalmicros
            if this.nextchecktime < t then
              -- prevents us from falling behind and doing loads of checks in a row while
              -- nextchecktime catches up to the real time
              this.nextchecktime = t
            end
          end
        end

        if not this.renderviewproj then return end

        local gx, gy, gw, gh = bolt.gameviewxywh()
        for i, point in pairs(this.pointlist) do
          local p = bolt.point((point.x + 0.5) * 512.0, point.y, (point.z + 0.5) * 512.0)
          local px, py, pdist = p:transform(this.renderviewproj):aspixels()
          if pdist > 0.0 and pdist <= 1.0 and px >= gx and py >= gy and px <= (gx + gw) and py <= (gy + gh) then
            if point.state < 0 then
              -- eliminated point
              local scale = 0.6
              local imgradius = 16 * scale
              local imgsize = 32 * scale
              markerinactive.surface:drawtoscreen(0, 0, markerinactive.w, markerinactive.h, px - imgradius, py - imgradius, imgsize, imgsize)
            elseif (point.state == 1 or point.state == 2 or point.state == 3) and (t - point.laststatechange) <= (statechangegraceperiod * 1.5) then
              -- "loading" point
              local scale = 1
              local imgradius = 16 * scale
              local imgsize = 32 * scale
              this.surfacemaybeloading:clear()
              markeractive.surface:drawtosurface(this.surfacemaybeloading, 0, 0, markeractive.w, markeractive.h, 0, 0, markeractive.w, markeractive.h)
              program:setuniform1f(0, (t - point.laststatechange) / statechangegraceperiod)
              program:drawtosurface(this.surfacemaybeloading, shaderbuffer, 6)
              this.surfacemaybeloading:drawtoscreen(0, 0, markeractive.w, markeractive.h, px - imgradius, py - imgradius, imgsize, imgsize)
            else
              -- normal non-eliminated point
              local scale = 0.75
              local imgradius = 16 * scale
              local imgsize = 32 * scale
              markeractive.surface:drawtoscreen(0, 0, markeractive.w, markeractive.h, px - imgradius, py - imgradius, imgsize, imgsize)
            end
          end
        end
      end,

      valid = function (this)
        return this.modelfound
      end
    }
  end

  -- table of the 9th row of pixel data from the sixth letter of the scan clue text. each value is a function which,
  -- when called with f(bolt, render2devent), returns a scan object or nil.
  -- the purpose of this is to optimise text-matching, so that, instead of a large number of if-else cases,
  -- most of the variance is handled by a lookup table, which is O(1). generally, each function queries just enough
  -- information to uniquely identify the scan location, rather than trying to parse the whole string.
  -- the reason it operates on the sixth letter is because it's the most varied between different texts
  -- (16 different cases out of 24 possible texts.)
  local locationsixthlettercases = {
    ["\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x88\xff\xff\xff\x88\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'a' => 'Brimh[a]ven Dungeon' OR 'The He[a]rt of Gielinor' OR 'Isafd[a]r' OR 'The cr[a]ter in the Wilderness'
      -- check the width of the fourth character: m=20 H=16 f=8 c=14
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 6) + 1)
      if w == 8 then return create(bolt, "isafdar") end
      if w == 14 then return create(bolt, "wildernesscrater") end
      if w == 16 then return create(bolt, "heartofgielinor") end
      if w == 20 then return create(bolt, "brimhavendungeon") end
      return nil
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'c' => 'Varro[c]k and the Grand Exchange'
      return create(bolt, "varrock")
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xdd\xff\xff\xff\xdd\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'd' => 'Prifd[d]inas'
      return create(bolt, "prifddinas")
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xbb\xff\xff\xff\xbb\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'e' => 'Darkm[e]yer' OR 'The de[e]pest levels of the Wilderness' OR 'Haunt[e]d Woods'
      -- check the width of the fifth letter: m=20 e=14 t=10
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 8) + 1)
      if w == 10 then return create(bolt, "hauntedwoods") end
      if w == 14 then return create(bolt, "deepwilderness") end
      if w == 20 then return create(bolt, "darkmeyer") end
      return nil
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xaa\xff\xff\xff\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xcc\xff\xff\xff\xcc\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'g' => 'Kelda[g]rim'
      return create(bolt, "keldagrim")
    end,
    ["\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xaa\xff\xff\xff\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'h' => 'Menap[h]os'
      return create(bolt, "menaphos")
    end,
    ["\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'i' => 'Zanar[i]s' OR 'Scann[i]ng...'
      -- check the width of the fifth letter: r=8 n=14
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 8) + 1)
      if w == 8 then return create(bolt, "zanaris") end
      return nil
    end,
    ["\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'l' => 'Taver[l]ey Dungeon' or 'The Is[l]ands That Once Were Turtles'
      -- check the width of the fifth letter: r=8 s=12
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 8) + 1)
      if w == 8 then return create(bolt, "taverleydungeon") end
      if w == 12 then return create(bolt, "tortleislands") end
      return nil
    end,
    ["\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x33\xff\xff\xff\x33\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'n' => 'Freme[n]nik Isles of Jatizso and Neitiznot' OR 'Freme[n]nik Slayer Dungeons'
      -- make sure there are at least 11 characters in the batch
      if event:vertexcount() < event:verticesperimage() * 22 then return nil end
      -- check the width of the eleventh letter: s=12 l=6
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 20) + 1)
      if w == 6 then return create(bolt, "fremslayerdungeon") end
      if w == 12 then return create(bolt, "fremislands") end
      return nil
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x66\xff\xff\xff\x66\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'o' => 'Falad[o]r'
      return create(bolt, "falador")
    end,
    ["\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x55\xff\xff\xff\x55\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'r' => 'East o[r] West Ardougne'
      return create(bolt, "ardougne")
    end,
    ["\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 's' => 'Dorge[s]h-Kaan' OR 'The Lo[s]t Grove' OR 'The de[s]ert, east of the Elid and north of Nardah'
      -- check the width of the ninth letter: K=14 r=8 t=10
      local _, _, w, _, _, _ = event:vertexatlasdetails((event:verticesperimage() * 16) + 1)
      if w == 14 then return create(bolt, "dorgeshkaan") end
      if w == 8 then 
        local x,y,z = bolt.playerposition():get()
        print("{ x = " .. math.floor(x/512) .. ", y = " .. math.floor(y / 512) .. ", z = " .. math.floor(z / 512) .. ", floor = 1 },")
        return create(bolt, "lostgrove")
        end
      if w == 10 then return create(bolt, "eastdesert") end
      return nil
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 't' => 'Pisca[t]oris Hunter Area'
      return create(bolt, "piscatoris")
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xee\xff\xff\xff\xee\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\x55\xff\xff\xff\x55\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'v' => 'The ca[v]es beneath Lumbridge Swamp'
      return create(bolt, "lumbridgeswampcaves")
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- 'z' => 'Khara[z]i Jungle'
      return create(bolt, "kharazi")
    end,
    ["\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00"] = function (bolt, event)
      -- apostrophe (probably - it's just a row of 4 transparent pixels) => 'Mos Le'Harmless'
      return create(bolt, "mosleharmless")
    end,
  }

  -- event is render2d
  local function trycreate (bolt, event)
    -- make sure there are at least 7 characters in the batch
    if event:vertexcount() < event:verticesperimage() * 14 then return nil end

    -- as there are two images per letter, multiplying by 0 would relate to the index of the first letter, and
    -- in this case, multiplying by 10 relates to the index of the sixth letter, which is the one we want.
    local ax, ay, aw, ah, _, _ = event:vertexatlasdetails((event:verticesperimage() * 10) + 1)
    if ah < 10 then return nil end
    local data = event:texturedata(ax, ay + 9, aw * 4)
    local f = locationsixthlettercases[data]
    if f == nil then return nil end
    return f(bolt, event)
  end

  return {create = create, trycreate = trycreate}
end}
