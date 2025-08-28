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

return {get = function(bolt)

  local decoder = require("slider.puzzles")

  local goal = {1, 2, 3, 4, 5 , 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 0}

  local digits, _, digitheight = bolt.createsurfacefrompng("images.digits")
  local digithalfwidth = 8
  local digitwidth = digithalfwidth * 2
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

      local function printstate(state) 
        for i = 1, 25, 5 do
          print(state[i] .. " " .. state[i+1] .. " " .. state[i+2] .. " " .. state[i+3] .. " " .. state[i+4])
        end
      end

      local function imagetonumbers (this, event, firstvertex)
        local state = {}
        local statelength = 0
        local first = false
        local firstpositionx, firstpositiony
        local rows = {0, 0, 0, 0, 0}
        local cols = {0, 0, 0, 0, 0}
        local correctevent = false
        for i = firstvertex, event:vertexcount(), verticesperimage do
          local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(i)
          if aw == objectsize and ah == objectsize then
            correctevent = true
            local currentx, currenty = event:vertexxy(i)
            local f = decoder.get(event, ax, ay, aw * 4)
            if f~= nil then
              if not first then
                firstpositionx, firstpositiony = event:vertexxy(i)
                this.leftmostx = firstpositionx
                first = true
              end

              if currentx < this.leftmostx - 40 then --we started on col 2 instead of col 1
                this.leftmostx = currentx
                cols = {0, 1, 1, 1, 1}
              end --currentx < ...

              local x = math.floor((currentx - this.leftmostx) / objectsize) +1
              local y = math.floor((currenty - firstpositiony) / objectsize) +1
              -- print("we're at "..x..", "..y)
              rows[y] = rows[y] + 1
              cols[x] = cols[x] +  1

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
          -- print(holeposition)

          for i = #state, holeposition, -1 do 
            state[i+1] = state[i]
          end
          state[holeposition] = 0

        end

        -- printstate(state)
        -- print("\n")
        return state
      end

      local function valid (this)
        return this.isvalid
      end

      local function solve(this)
        if this.issolved then return this.solution end
        -- this.issolved = true

        -- print("new solver")
        this.solver = coroutine.create(
          function (start, goal, bolt)
            local timestarted = bolt.time()
            -- print("solve start " .. table.getn(start) == table.getn(goal))
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
                -- print("\"returning\"")
                coroutine.yield(reconstruct_path(cameFrom, current))
                -- return reconstruct_path(cameFrom, current)
              end

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
              if bolt.time() - timestarted >= 80000 then 
                -- print("pausing")
                coroutine.yield()
                -- print("resuming")
                timestarted = bolt.time()
              end -- too many iterations??
            end
            print("ended in disarray")
            -- return nil -- No solution found
          end

        )
        _, this.solution = coroutine.resume(this.solver, this.state, goal, bolt)
        -- print(this.solver)
        -- print("co status : " .. coroutine.status(this.solver))
        -- this.solutionindex = 1
        this.issolved = this.solution and type(this.solution) == "table" and #this.solution > 0
        if this.issolved then this.solutionindex = 1 end

      end

      local function drawstep(this, event, h)
        if this.solution[this.solutionindex  + h] ~= nil then 
          local index
          for i = 1, 25 do
            if this.solution[this.solutionindex  + h][i] == 0 then index = i break end
          end -- fori
          -- print(index)
          local x, y = event:vertexxy(firstvertex)
          local newx = this.leftmostx + ((index-1) % 5 ) * (objectsize + 4) - objecthalfsize
          local newy = y + math.floor((index-1) / 5 ) * (objectsize + 8 ) - objecthalfsize
          drawnumber(h, newx , newy)
        end
      end

      local function iscorrectevent(this, event, firstvertex)
        local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(firstvertex)
        return aw == objectsize and ah == objectsize
      end

      local function shallowtablecompare(a, b)
        if a == b then return true end
        if a == nil or b == nil then return false end
        if #a ~=#b then return false end
        for i=1,#a do
          if a[i] ~= b[i] then return false end
        end
        return true
      end

      local function isstillsolved(this, currentstate)
        if this.solution == nil or #this.solution < 1 then 
          return false 
        end
        if shallowtablecompare(currentstate, this.solution[this.solutionindex]) then 
          return true 
        end
        for i=this.solutionindex, #this.solution do 
          if shallowtablecompare(currentstate, this.solution[i]) then 
            this.solutionindex = i 
            return true
          end
        end
        for i=this.solutionindex, 1, -1 do 
          if shallowtablecompare(currentstate, this.solution[i]) then
            this.solutionindex = i
           return true 
          end
        end
        return false
      end

      local function iscompleted(state) 
        return state and type(state) == "table" and shallowtablecompare(state, goal)
      end

      local function onrender2d (this, event)
        if this.lasttime == nil then
          this.lasttime = bolt.time()
        end
        if not iscorrectevent(this, event, firstvertex) then 
          if bolt.time() - this.lasttime > 1200000 then
            print("how long has it been...")
            this.isvalid = false
          end 
          return 
        end
        this.lasttime = bolt.time()
        local onscreen = imagetonumbers(this, event, firstvertex)
        if iscompleted(onscreen) then
          this.isvalid = false
          return
        end
        local stillsolved = false
        if onscreen ~= nil and onscreen[1] ~= nil then 
          stillsolved = isstillsolved(this, onscreen) 
          if this.issolved ~= nil and not stillsolved then 
            this.solver = nil 
            this.issolved = nil
          end
        end 
        if onscreen ~= nil and onscreen[1] ~= nil and ((not this.issolved and not stillsolved) or serialize(onscreen) ~= serialize(this.state)) then
            this.state = onscreen
            this.statelength = #onscreen
            for i = 1, 25, 1 do
              if this.state[i] == nil then return end
            end -- fori
            if not this.issolved then
              if this.solver == nil then 
                this.solution = {}
                solve(this)
              else
                _, this.solution = coroutine.resume(this.solver)
                -- print(this.solver)
                -- print("co status : " .. coroutine.status(this.solver))
                this.issolved = this.solution and type(this.solution) == "table" and #this.solution > 0
                if this.issolved then this.solutionindex = 1 end
              end -- this.solver == nil
            end -- not issolved
        end -- onscreen ~=nil and .. 
        if iscorrectevent(this, event, firstvertex) then
          if this.issolved and this.solution and this.solution[this.solutionindex + 1] then
            this.solver = nil
            for h=1,4 do 
              drawstep(this, event, h)
            end -- forh
          end -- if this.issolved and this.solution ...
        end -- if iscorrectevent
      end

      local function reset (this)
        this.state = {}
        this.statelength = 0
        this.solution = {}
        this.solutionstate = {}
        this.issolved = false
        this.solutionindex = 0
        this.nextsolvetime = bolt.time() + resolveinterval
        this.solver = nil
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
        solver = nil,
        lasttime = nil,

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