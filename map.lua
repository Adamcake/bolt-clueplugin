return {get = function(bolt)
  local titleheight = 18
  local borderwidth = 5
  local mapdefaultsize = 260
  local chunksize = 64 --in tiles
  local chunks = {}
  local whitepixel = bolt.createsurfacefromrgba(1, 1, "\xFF\xFF\xFF\xFF")

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
            goto c1
          end
        else
          chunk.lastused = t
        end
        if chunk.image ~= nil then
          local tilediffx = (x * chunksize) - map.x
          local tilediffy = map.y - ((y + 1) * chunksize)
          local drawx = (map.w / 2) + (tilediffx * viewscale)
          local drawy = (map.h / 2) + (tilediffy * viewscale) + titleheight
          chunk.image:drawtowindow(window, 0, 0, chunk.w, chunk.h, drawx, drawy, drawsize, drawsize)
        end
      end
    end
    ::c1::
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
        map.pendingredraw = true
      end)
      window:onreposition(function (event)
        local _, _, w, h = event:xywh()
        map.w = w
        map.h = h - titleheight
        if event:didresize() then
          map.pendingredraw = true
        end
      end)
      window:onscroll(function (event)
        viewscaleindex = viewscaleindex + (event:direction() and 1 or -1)
        if viewscaleindex < 1 then viewscaleindex = 1 end
        if viewscaleindex > viewscalecount then viewscaleindex = viewscalecount end
        map.pendingredraw = true
      end)
      map:redraw()
      return map
    end,
  }
end}
