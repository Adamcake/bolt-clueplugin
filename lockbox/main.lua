
return {get = function(bolt)

  local decoder = require("lockbox.recognise")
  local solver = require("lockbox.solver")

  local digits = bolt.images.digits
  local digithalfwidth = 19.5
  local digithalfheight = digits.h / 2
  local digitwidth = 39
  local objectsize = 32
  local objecthalfsize = 16

  -- draws an integer on the screen centered on (x,y), assuming it will be a digit 1-9
  local function drawnumber (n, x, y)
    local scale = 0.75
    local startx = x - (digithalfwidth * scale)
    local starty = y - (digithalfheight * scale)
    digits.surface:drawtoscreen(digitwidth * n, 0, digitwidth, digits.h, startx, starty, digitwidth * scale, digits.h * scale)
  end

  return {
    create = function (event, firstvertex)
      local verticesperimage = event:verticesperimage()

      local function imagetonumbers (this, event, firstvertex)
        local state = {}
        local statelength = 0
        local correctevent = false

        for i = firstvertex, event:vertexcount(), verticesperimage do
          local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(i)
          if aw == objectsize and ah == objectsize then
            correctevent = true
            local currentx, currenty = event:vertexxy(i)
            local f = decoder.get(event, ax, ay, aw * 4)
            if f~= nil then
              statelength = statelength + 1
              state[statelength] = f 
              if statelength == 25 then 
                return state
              end
              -- drawnumber(state[statelength] , currentx-objecthalfsize, currenty-objecthalfsize)
            else 
              print("A tile was not recognised")
              return nil
            end -- f nil 
          end -- aw == objectsize
        end
        return state
      end

      local function onrender2d (this, event)
        local state = imagetonumbers(this, event, firstvertex)
        local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(firstvertex)
        if aw == objectsize and ah == objectsize then
            if state ~= nil then 
              this.solution = solver.get(state)
            end
            if this.solution == nil then return end
            for index=1, #this.solution do
              if this.solution[index] ~= 0 then 
                local x, y = event:vertexxy(firstvertex)
                local newx = x + ((index-1) % 5 ) * (objectsize + 6) - objecthalfsize
                local newy = y + math.floor((index-1) / 5 ) * (objectsize + 6 ) - objecthalfsize
                drawnumber(3 - this.solution[index], newx , newy)
              end
            end
          else 
            if bolt.time() - this.lasttime > 1200000 then
              this.isvalid = false
            end 
        end
      end

      local function valid (this)
        return this.isvalid
      end

      local function reset (this)
        this.state = {}
        this.statelength = 0
        this.solution = nil
        this.solutionstate = {}
        this.issolved = false
        this.solutionindex = 0
        this.solver = nil
        this.lasttime = bolt.time()
      end

      local object = {
        isvalid = true,
        nextsolvetime = nil,
        state = {},
        statelength = 0,
        solution = nil,
        solutionindex = 0,
        solvingstate = {},
        issolved = false,
        leftmostx = 0,
        solver = nil,
        finished = false,
        lasttime = bolt.time(),

        valid = valid,
        onrender2d = onrender2d,
        reset = reset,
      }
      imagetonumbers(object, event, firstvertex)
      return object
    end,
  }
end}
