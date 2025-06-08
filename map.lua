return {get = function(bolt)
  local titleheight = 18
  local borderwidth = 5
  local linewidth = 10
  local mapdefaultsize = 260
  local chunksize = 64 --in tiles
  local chunks = {}
  local whitepixel = bolt.createsurfacefromrgba(1, 1, "\xFF\xFF\xFF\xFF")
  local marker, markerw, markerh = bolt.createsurfacefrompng("images.marker")
  marker:setalpha(0.9)

  -- custom shader for drawing lines
  local lineprogram = (function (bolt)
    local vs = bolt.createvertexshader("layout(location=0) in highp vec2 pos; void main(){gl_Position = vec4(pos,0,1);}")
    local fs = bolt.createfragmentshader("out highp vec4 col;void main(){col=vec4(1,1,1,1);}")
    return bolt.createshaderprogram(vs, fs)
  end)(bolt)
  lineprogram:setattribute(0, 4, true, true, 2, 0, 8)
  local buf = bolt.createbuffer(48)

  --ratio of on-screen pixels to map tiles, so a higher value is more zoomed-in
  local viewscales = { 0.75, 0.875, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20 }
  local viewscaleindex = 11
  local viewscalecount = #viewscales

  local maxchunks = 256 -- soft cap on the number of chunks which can be loaded at one time
  local activechunkage = 1000000 -- how old a chunk has to be to be eligible for unloading, in microseconds (= 1 second)
  local maxloadperframe = 20000 -- cap on how long can be spent loading images per frame, in microseconds (= 0.02 seconds)

  local redraw = function (map)
    local window = map.window
    local level = map.level
    local viewscale = viewscales[viewscaleindex]
    local t = bolt.time()
    window:clear(0, 0, 0, 1)
    local tilehalfwidth = (map.w / (2 * viewscale))
    local tilehalfheight = (map.h / (2 * viewscale))
    local gx1 = map.x - tilehalfwidth
    local gx2 = map.x + tilehalfwidth
    local gy1 = map.y - tilehalfheight
    local gy2 = map.y + tilehalfheight
    local chunkx1 = math.floor(gx1 / chunksize)
    local chunky1 = math.floor(gy1 / chunksize)
    local chunkx2 = math.floor(gx2 / chunksize) + 1
    local chunky2 = math.floor(gy2 / chunksize) + 1
    local drawsize = chunksize * viewscale
    for y = chunky1, chunky2 do
      for x = chunkx1, chunkx2 do
        local chunkname = string.format("%d_%d_%d", level, x, y)
        local chunk = chunks[chunkname]
        if chunk == nil then
          if t + maxloadperframe > bolt.time() then
            local image, w, h = bolt.createsurfacefrompng(string.format("layers_rs3.map_squares.-1.2.%s", chunkname))
            chunk = { image = image, w = w, h = h, lastused = t }
            chunks[chunkname] = chunk
          else
            map.pendingredraw = true
          end
        else
          chunk.lastused = t
        end
        if chunk ~= nil and chunk.image ~= nil then
          local tilediffx = (x * chunksize) - map.x
          local tilediffy = map.y - ((y + 1) * chunksize)
          local drawx = (map.w / 2) + (tilediffx * viewscale)
          local drawy = (map.h / 2) + (tilediffy * viewscale) + titleheight
          chunk.image:drawtowindow(window, 0, 0, chunk.w, chunk.h, drawx, drawy, drawsize, drawsize)
        end
      end
    end

    if map.points then
      for _, point in pairs(map.points) do
        if point.x >= (gx1 - markerw) and point.x <= (gx2 + markerw) and point.z >= (gy1 - markerh) and point.z <= (gy2 + markerh) then
          local tilediffx = point.x + 0.5 - map.x
          local tilediffy = map.y - (point.z + 0.5)
          local drawx = (map.w / 2) + (tilediffx * viewscale) - (markerw / 2)
          local drawy = (map.h / 2) + (tilediffy * viewscale) + titleheight - (markerh - 4)
          marker:drawtowindow(window, 0, 0, markerw, markerh, drawx, drawy, markerw, markerh)
        end
      end
    end

    if map.lines then
      local surface = bolt.createsurface(map.w, map.h)
      surface:settint(0.886, 0.282, 0.859)
      surface:setalpha(0.8)

      local halfwidth = linewidth / 2
      local radians90 = math.pi / 2
      for _, line in pairs(map.lines) do
        local tilediffx = line.x - map.x
        local tilediffy = map.y - line.y
        local pixelx = (map.w / 2) + (tilediffx * viewscale)
        local pixely = (map.h / 2) + (tilediffy * viewscale)

        local drawlength = (math.sqrt(math.pow((map.w / 2) - pixelx, 2) + math.pow((map.h / 2) - pixely, 2))) + map.w + map.h
        local angle = -line.direction
        local sinangle = math.sin(angle)
        local cosangle = math.cos(angle)
        local sinangle90 = math.sin(angle + radians90)
        local cosangle90 = math.cos(angle + radians90)
        local sinanglem90 = math.sin(angle - radians90)
        local cosanglem90 = math.cos(angle - radians90)
        local endx = pixelx + (drawlength * cosangle)
        local endy = pixely + (drawlength * sinangle)
        
        local x1 = (pixelx + (halfwidth * cosangle90)) * (2 / map.w) - 1
        local y1 = (pixely + (halfwidth * sinangle90)) * (2 / map.h) - 1
        local x2 = (pixelx + (halfwidth * cosanglem90)) * (2 / map.w) - 1
        local y2 = (pixely + (halfwidth * sinanglem90)) * (2 / map.h) - 1
        local x3 = (endx + (halfwidth * cosangle90)) * (2 / map.w) - 1
        local y3 = (endy + (halfwidth * sinangle90)) * (2 / map.h) - 1
        local x4 = (endx + (halfwidth * cosanglem90)) * (2 / map.w) - 1
        local y4 = (endy + (halfwidth * sinanglem90)) * (2 / map.h) - 1

        buf:setfloat32(0, x1)
        buf:setfloat32(4, y1)
        buf:setfloat32(8, x2)
        buf:setfloat32(12, y2)
        buf:setfloat32(16, x3)
        buf:setfloat32(20, y3)
        buf:setfloat32(24, x2)
        buf:setfloat32(28, y2)
        buf:setfloat32(32, x4)
        buf:setfloat32(36, y4)
        buf:setfloat32(40, x3)
        buf:setfloat32(44, y3)
        local shaderbuffer = bolt.createshaderbuffer(buf)
        lineprogram:drawtosurface(surface, shaderbuffer, 6)
        print(string.format("draw %s,%s %s,%s %s,%s %s,%s", x1, y1, x2, y2, x3, y3, x4, y4))
      end
      surface:drawtowindow(window, 0, 0, map.w, map.h, 0, titleheight, map.w, map.h)
    end

    local fullheight = map.h + titleheight
    whitepixel:settint(0.025, 0.025, 0.025)
    whitepixel:drawtowindow(window, 0, 0, 1, 1, 0, 0, borderwidth, fullheight)
    whitepixel:drawtowindow(window, 0, 0, 1, 1, map.w - borderwidth, 0, borderwidth, fullheight)
    whitepixel:drawtowindow(window, 0, 0, 1, 1, 0, fullheight - borderwidth, map.w, borderwidth)
    whitepixel:settint(0.125, 0.125, 0.125)
    whitepixel:drawtowindow(window, 0, 0, 1, 1, 0, 0, map.w, titleheight)

    -- gc
    local chunkcount = 0
    for _ in pairs(chunks) do chunkcount = chunkcount + 1 end
    if chunkcount > maxchunks then
      local removals = {}
      local i = 1
      for name, chunk in pairs(chunks) do
        if chunk.lastused + activechunkage < t then
          removals[i] = name
          i = i + 1
        end
      end
      for _, name in ipairs(removals) do
        chunks[name] = nil
      end
    end
  end

  local onswapbuffers = function (map)
    if map.pendingredraw then
      map.pendingredraw = false
      map:redraw()
    end
  end

  return {
    create = function (x, y, level)
      local window = bolt.createwindow(10, 10, mapdefaultsize, mapdefaultsize + titleheight)
      local map = { x = x, y = y, level = level, w = mapdefaultsize, h = mapdefaultsize, window = window, pendingredraw = false, redraw = redraw, onswapbuffers = onswapbuffers }
      local clickpixelx = 0
      local clickpixely = 0
      local clickmapx = 0
      local clickmapy = 0
      local dragging = false
      local dragbutton = 0
      window:onmousebutton(function (event)
        local ex, ey = event:xy()
        local button = event:button()
        if button == 1 then
          if ey < titleheight then
            window:startreposition(0, 0)
            return
          end
          local isleftedge = ex < borderwidth
          local isrightedge = ex >= map.w - borderwidth
          local isbottomedge = ey >= map.h + titleheight - borderwidth
          if isleftedge or isrightedge or isbottomedge then
            window:startreposition(isleftedge and -1 or (isrightedge and 1 or 0), isbottomedge and 1 or 0)
            return
          end
        end
        clickpixelx = ex
        clickpixely = ey
        clickmapx = map.x
        clickmapy = map.y
        dragging = true
        dragbutton = button
      end)
      window:onmousebuttonup(function (event)
        if event:button() ~= dragbutton then return end
        dragging = false
      end)
      window:onmousemotion(function (event)
        if not dragging then return end
        local lmb, rmb, mmb = event:mousebuttons()
        local buttons = { lmb, rmb, mmb }
        if not buttons[dragbutton] then
          dragging = false
          return
        end
        local ex, ey = event:xy()
        local viewscale = viewscales[viewscaleindex]
        map.x = clickmapx + ((clickpixelx - ex) / viewscale)
        map.y = clickmapy + ((ey - clickpixely) / viewscale)
        map.level = level
        map:redraw()
      end)
      window:onreposition(function (event)
        local _, _, w, h = event:xywh()
        map.w = w
        map.h = h - titleheight
        if event:didresize() then
          map:redraw()
        end
      end)
      window:onscroll(function (event)
        viewscaleindex = viewscaleindex + (event:direction() and 1 or -1)
        if viewscaleindex < 1 then viewscaleindex = 1 end
        if viewscaleindex > viewscalecount then viewscaleindex = viewscalecount end
        map:redraw()
      end)
      map:redraw()
      return map
    end,
  }
end}
