-- ==========================================================
-- Fibonacci Heap (minimal)
-- ==========================================================
local FibHeap = {}
FibHeap.__index = FibHeap

function FibHeap.new()
    return setmetatable({min = nil, n = 0}, FibHeap)
end

local function new_node(key, value)
    return {
        key = key, value = value, degree = 0, mark = false,
        parent = nil, child = nil, left = nil, right = nil
    }
end

function FibHeap:insert(key, value)
    local node = new_node(key, value)
    node.left = node
    node.right = node
    if not self.min then
        self.min = node
    else
        -- insert into root list
        node.right = self.min.right
        node.left = self.min
        self.min.right.left = node
        self.min.right = node
        if key < self.min.key then
            self.min = node
        end
    end
    self.n = self.n + 1
    return node
end

function FibHeap:link(y, x)
    y.left.right = y.right
    y.right.left = y.left
    y.parent = x
    if not x.child then
        x.child = y
        y.left = y
        y.right = y
    else
        y.left = x.child
        y.right = x.child.right
        x.child.right.left = y
        x.child.right = y
    end
    x.degree = x.degree + 1
    y.mark = false
end

function FibHeap:consolidate()
    local A = {}
    local roots = {}
    local x = self.min
    if x then
        repeat
            table.insert(roots, x)
            x = x.right
        until x == self.min
    end
    for _, w in ipairs(roots) do
        local x = w
        local d = x.degree
        while A[d] do
            local y = A[d]
            if x.key > y.key then
                x, y = y, x
            end
            self:link(y, x)
            A[d] = nil
            d = d + 1
        end
        A[d] = x
    end
    self.min = nil
    for _, a in pairs(A) do
        if not self.min then
            self.min = a
            a.left = a
            a.right = a
        else
            a.left = self.min
            a.right = self.min.right
            self.min.right.left = a
            self.min.right = a
            if a.key < self.min.key then
                self.min = a
            end
        end
    end
end

function FibHeap:extract_min()
    local z = self.min
    if z then
        if z.child then
            local c = z.child
            repeat
                local nextc = c.right
                c.parent = nil
                c.left.right = c.right
                c.right.left = c.left
                c.left = self.min
                c.right = self.min.right
                self.min.right.left = c
                self.min.right = c
                c = nextc
            until c == z.child
        end
        z.left.right = z.right
        z.right.left = z.left
        if z == z.right then
            self.min = nil
        else
            self.min = z.right
            self:consolidate()
        end
        self.n = self.n - 1
    end
    return z and z.value or nil, z and z.key or nil
end

local function table_copy(tbl)
  local copy = {}
  for i = 1, #tbl do copy[i] = tbl[i] end
  return copy
end

local function serialize(state)
  return table.concat(state, ",")
end

local function manhattan(state, goal)
  local dist = 0
  for i = 1, 25 do
    local val = state[i]
    if val ~= 0 then
      local goalIndex = 0
      for j = 1, 25 do
        if goal[j] == val then goalIndex = j break end
      end
      local x1, y1 = ((i - 1) % 5), math.floor((i - 1) / 5)
      local x2, y2 = ((goalIndex - 1) % 5), math.floor((goalIndex - 1) / 5)
      dist = dist + math.abs(x1 - x2) + math.abs(y1 - y2)
    end
  end
  return dist
end

local function get_neighbors(state)
  local neighbors = {}
  local index
  for i = 1, 25 do
    if state[i] == 0 then index = i break end
  end
  local x, y = (index - 1) % 5, math.floor((index - 1) / 5)
  local moves = {
    {x = x - 1, y = y}, {x = x + 1, y = y},
    {x = x, y = y - 1}, {x = x, y = y + 1}
  }
  for _, m in ipairs(moves) do
    if m.x >= 0 and m.x < 5 and m.y >= 0 and m.y < 5 then
      local newIndex = m.y * 5 + m.x + 1
      local newState = table_copy(state)
      newState[index], newState[newIndex] = newState[newIndex], newState[index]
      table.insert(neighbors, newState)
    end
  end
  return neighbors
end

local function reconstruct_path(cameFrom, current)
  local path = {current}
  while cameFrom[serialize(current)] do
    current = cameFrom[serialize(current)]
    table.insert(path, 1, current)
  end
  return path
end

local function solve_24_puzzle(start, goal)
  print("solve start " .. table.getn(start) == table.getn(goal))
  local openSet = FibHeap.new()
  openSet:insert(manhattan(start, goal), start)

  local cameFrom = {}
  local gScore = {[serialize(start)] = 0}
  local visited = {}

  while openSet.n > 0 do
    local current, _ = openSet:extract_min()
    -- if manhattan(current, goal) == 0 then
    --   print("manhattan 0")
    --   return reconstruct_path(cameFrom, current)
    -- end
    local currentKey = serialize(current)

    if currentKey == serialize(goal) then
      return reconstruct_path(cameFrom, current)
    end
    -- if gScore[currentKey] > 46 then return nil end -- too many iterations??

    visited[currentKey] = true
    -- print("visited "..  currentKey)
    for _, neighbor in ipairs(get_neighbors(current)) do
      local neighborKey = serialize(neighbor)
      if not visited[neighborKey] then 
        local tentative_gScore = gScore[currentKey] + 1
        if not gScore[neighborKey] or tentative_gScore < gScore[neighborKey] then
          cameFrom[neighborKey] = current
          gScore[neighborKey] = tentative_gScore
          local fScore = tentative_gScore + manhattan(neighbor, goal)
          openSet:insert(fScore, neighbor)
        end
      end
    end
  end
  return nil -- No solution found
end

return {get = function(bolt)

  local decoder = require("slider.puzzles")

  local goal = {1, 2, 3, 4, 5 , 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 0}

  local digits, _, digitheight = bolt.createsurfacefrompng("images.digits")
  local digithalfwidth = 8
  local digitwidth = digithalfwidth * 2
  local runedecorvertexid = 175
  local objecthalfsize = 24
  local objectsize = 49
  local resolveinterval = 200000 -- 0.2 seconds
  local clickresolvedelay = 1000000 -- 1 second

    -- draws an integer on the screen centered on (x,y), assuming it will be 1 or 2 digits
  local function drawnumber (n, x, y)
    local doubledigit = n > 9
    local startx = x - (doubledigit and digitwidth or digithalfwidth)
    local starty = y - (digitheight / 2)
    if doubledigit then
      digits:drawtoscreen(digitwidth * math.floor(n / 10), 0, digitwidth, digitheight, startx, starty, digitwidth, digitheight)
      digits:drawtoscreen(digitwidth * (n % 10), 0, digitwidth, digitheight, startx + digitwidth, starty, digitwidth, digitheight)
    else
      digits:drawtoscreen(digitwidth * n, 0, digitwidth, digitheight, startx, starty, digitwidth, digitheight)
    end
  end

  return {
    create = function (event, firstvertex, x, y, x2, y2)
      local verticesperimage = event:verticesperimage()

      local function imagetonumbers (this, event, firstvertex)
        local state = {}
        local statelength = 0
        local hole = false
        local first = false
        local firstpositionx, firstpositiony
        local previousx, previousy
        local rightmostblockx = 0
        local rows = {0, 0, 0, 0, 0}
        local cols = {0, 0, 0, 0, 0}
        local correctevent = false
        for i = firstvertex, event:vertexcount(), verticesperimage do
          local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(i)
          if aw == objectsize and ah == objectsize then
            correctevent = true
            local currentx, currenty = event:vertexxy(i)
            local f = decoder.get(event:texturedata(ax, ay + 11, aw * 4))
            if f~= nil then
              if not first then
                firstpositionx, firstpositiony = event:vertexxy(i)
                this.leftmostx = firstpositionx
                previousx, previousy = firstpositionx, firstpositiony
                rightmostblockx = firstpositionx
                first = true
              end

              if currentx < this.leftmostx - 40 then --we started on col 2 instead of col 1
                  this.leftmostx = currentx
                  cols = {0, 1, 1, 1, 1}
              end --currentx < ...

              local x = math.floor((currentx - this.leftmostx) / objectsize) +1
              local y = math.floor((currenty - firstpositiony) / objectsize) +1
              print("we're at "..x..", "..y)
              rows[y] = rows[y] + 1
              cols[x] = cols[x] +  1

              previousx = currentx
              previousy = currenty
              statelength = statelength + 1
              state[statelength] = f + 1
              -- drawnumber(state[statelength] , currentx-objecthalfsize, currenty-objecthalfsize)
            else 
              print("A tile was not recognised")
              return nil
            end -- f nil 
          end --aw == objectsize ...
        end -- for

        if correctevent then
          local shortrow, shortcol
          for i=1,#rows do
            if rows[i] == 4 then shortrow = i end
            if cols[i] == 4 then shortcol = i end
          end

          local holeposition = (shortrow-1) * 5 + shortcol
          print(holeposition)

          for i = #state, holeposition, -1 do 
            state[i+1] = state[i]
          end
          state[holeposition] = 0

        end

        for j=1, #state,5 do
          print(state[j] .. " " .. state[j+1] .. " " .. state[j+2] .. " " .. state[j+3] .. " " .. state[j+4])
        end -- forj
        print("\n")
        return state
      end

      local function valid (this)
        return this.isvalid
      end

      local function solve(this)
        if this.issolved then return this.solution end
        this.issolved = true
        this.solution = solve_24_puzzle(this.state, goal)
        this.solutionindex = 1
        this.issolved = not not this.solution
      end

      local function incrementsolutionindex(this, state)
        for i=this.solutionindex, #this.solution do
          if this.solution[i] ~= nil and serialize(this.solution[i]) == serialize(state) then 
            return i
          end
        return -1
        end
      end

      local function onrender2d (this, event)
        local state = imagetonumbers(this, event, firstvertex)
        if state ~= nil and state[1] ~= nil and serialize(state) ~= serialize(this.state) then
          local newseriesindex = incrementsolutionindex(this, state)
          if newseriesindex == -1 then 
            this.issolved = false
            this.state = state
            this.statelength = #state
            for i = 1, 25, 1 do
              if this.state[i] == nil then return end
            end -- fori
            for i = 1, 25, 5 do
              print(this.state[i] .. " " .. this.state[i+1] .. " " .. this.state[i+2] .. " " .. this.state[i+3] .. " " .. this.state[i+4])
            end -- fori
            if not this.issolved then
              solve(this)
            end -- not issolved
          else 
            this.solutionindex = newseriesindex
          end -- newseriesindex
        end
        local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(firstvertex)
        if aw == objectsize and ah == objectsize then
          if this.solution and this.solution[2] then
            for i=1, #this.solution-1 do
              for j=1, #this.solution[i],5 do
                print(this.solution[i][j] .. " " .. this.solution[i][j+1] .. " " .. this.solution[i][j+2] .. " " .. this.solution[i][j+3] .. " " .. this.solution[i][j+4])
              end -- forj
            end -- fori
            
            for h=1,4 do 
              if this.solution[this.solutionindex + h] ~= nil then 
                local index
                for i = 1, 25 do
                  if this.solution[this.solutionindex + h][i] == 0 then index = i break end
                end -- fori
                -- print(index)
                local x, y = event:vertexxy(firstvertex)
                local newx = this.leftmostx + ((index-1) % 5 ) * (objectsize + 4) - objecthalfsize
                local newy = y + math.floor((index-1) / 5 ) * (objectsize + 8 ) - objecthalfsize
                drawnumber(h, newx , newy)
              end
            end -- forh
          end -- if this.solution...
        end -- if aw == objectsize ... 
      end

      local function reset (this)
        this.state = {}
        this.statelength = 0
        this.solution = {}
        this.solutionstate = {}
        this.issolved = false
        this.solutionindex = 0
        this.nextsolvetime = bolt.time() + resolveinterval
      end

      local object = {
        isvalid = true,
        nextsolvetime = nil,
        state = {},
        statelength = 0,
        solution = {},
        solutionindex = 0,
        solutionstate = {},
        issolved = false,
        leftmostx = 0,

        valid = valid,
        onrender2d = onrender2d,
        solve = solve,
        reset = reset,
      }
      imagetonumbers(object, event, firstvertex)
      return object
    end,
  }
end}