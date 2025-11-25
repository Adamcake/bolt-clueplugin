return {
  get = function(bolt)
    local decoder = require("towers.decoder")
    local solver = require("towers.solver")

    local digits = bolt.images.digits
    local digithalfwidth = 19.5
    local digithalfheight = digits.h / 2
    local digitwidth = 39
    local objectsize = 44
    local objecthalfsize = 22

    -- draws an integer on the screen centered on (x,y), assuming it will be a digit 1-9
    local function drawnumber(n, x, y)
      local scale = 0.75
      local startx = x - (digithalfwidth * scale)
      local starty = y - (digithalfheight * scale)
      digits.surface:drawtoscreen(digitwidth * n, 0, digitwidth, digits.h, startx, starty, digitwidth * scale,
        digits.h * scale)
    end

    local function correctevent(aw, ah)
      return (aw == 18 or aw == 16 or aw == 14) and ah == 30
    end

    return {
      create = function(event, firstvertex)
        local verticesperimage = event:verticesperimage()

        local function imagetonumbers(this, event, firstvertex)
          this.filled_in_positions = {}
          this.filled_in = 0
          local state = {}
          local statelength = 0
          local newfirstvertex = firstvertex

          for i = firstvertex, event:vertexcount(), verticesperimage do
            local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(i)
            if correctevent(aw, ah) then
              local currentx, currenty = event:vertexxy(i)
              local f = decoder.get(event, ax, ay)
              if f ~= nil then
                newfirstvertex = i
                this.left_x = currentx
                this.top_y = currenty
                break
              end
            end
          end

          -- we have to save the top left position of the board itself so we know where to draw the solution
          for i = newfirstvertex, event:vertexcount(), verticesperimage * 2 do
            local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(i)
            if correctevent(aw, ah) then
              local currentx, currenty = event:vertexxy(i)
              local f = decoder.get(event, ax, ay)
              if f ~= nil then
                if currentx < this.left_x then
                  this.left_x = currentx
                end
                if currenty < this.top_y then
                  this.top_y = currenty
                end
                this.filled_in = this.filled_in + 1
                this.filled_in_positions[this.filled_in] = {[1] = currentx-3, [2] = currenty-4, [3] = f}
                -- statelength = statelength + 1
                state[this.filled_in] = f
                -- drawnumber(f, currentx , currenty )
                -- if statelength == 20 then break end
              else
                print("A number was not recognised")
                return nil
              end -- f nil
            end
          end

          -- the order of the numbers is: right downwards ; left downwards; bottom right to the right; top to the right
          -- once the user starts to fill in numbers, they are the same images as the numbers on the outline. 
          -- still, the last 20 numbers seem to be the hints
          local index = #this.filled_in_positions - 20
          this.right = {state[index + 1], state[index + 2], state[index + 3], state[index + 4], state[index + 5]}
          this.left = {state[index + 6], state[index + 7], state[index + 8], state[index + 9], state[index + 10]}
          this.bottom = {state[index + 11], state[index + 12], state[index + 13], state[index + 14], state[index + 15]}
          this.top = {state[index + 16], state[index + 17], state[index + 18], state[index + 19], state[index + 20]}

          this.filled_in = index

          return newfirstvertex
        end

        local function onrender2d(this, event)
          local newfirstvertex = imagetonumbers(this, event, firstvertex) or firstvertex
          local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(newfirstvertex)
          if correctevent(aw, ah) then
            this.lasttime = bolt.time()
            this.solution = solver.get(this.top, this.bottom, this.left, this.right)

            local taken = {}
            for fi=1, this.filled_in do
              local x = math.floor((this.filled_in_positions[fi][1] - this.left_x) / objectsize ) +1
              local y = math.floor((this.filled_in_positions[fi][2] - this.top_y) / objectsize) +1
              if taken[x] == nil then
                taken[x] = {}
              end
              taken[x][y] = this.filled_in_positions[fi][3]
            end

            if this.solution ~= nil then 
              for i=1, #this.solution do
                local position_y = this.top_y - 10 + (i * 44)
                for j=1, #this.solution[i] do
                  local position_x = this.left_x - 10 + (j * 44)
                  local filled = false
                  
                  if taken[j] == nil or taken[j][i] == nil or taken[j][i] ~= this.solution[i][j] then
                    drawnumber(this.solution[i][j], position_x, position_y)
                  end
                end
              end
            end
          else
            if bolt.time() - this.lasttime > 120000 then
              this.isvalid = false
            end
          end
        end

        local function valid(this)
          return this.isvalid
        end

        local function reset(this)
          this.solution = nil
          this.solutionstate = {}
          this.issolved = false
          this.solutionindex = 0
          this.nextsolvetime = bolt.time() + resolveinterval
          this.solver = nil
          this.top_y = 0
          this.left_x = 0
          this.lasttime = bolt.time()
          this.filled_in = 0
          this.filled_in_positions = {}
        end

        local object = {
          isvalid = true,
          left = {},
          right = {},
          top = {},
          bottom = {},
          solution = nil,
          solver = nil,
          lasttime = bolt.time(),
          finished = false,
          top_y = 0,
          left_x = 0,
          filled_in = 0,
          filled_in_positions = {},

          valid = valid,
          onrender2d = onrender2d,
          reset = reset,
        }
        imagetonumbers(object, event, firstvertex)
        return object
      end,
    }
  end
}
