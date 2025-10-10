local N = 5

local function visible_from_left(arr)
  local maxh, cnt = 0, 0
  for i=1,#arr do
    if arr[i] > maxh then
      maxh = arr[i]; cnt = cnt + 1
    end
  end
  return cnt
end

local function visible_from_right(arr)
  local maxh, cnt = 0, 0
  for i=#arr,1,-1 do
    if arr[i] > maxh then
      maxh = arr[i]; cnt = cnt + 1
    end
  end
  return cnt
end

local perms = {}
local used = {}
for i=1,N do used[i] = false end
local cur = {}
local function gen(k)
  if k > N then
    local copy = {}
    for i=1,N do copy[i] = cur[i] end
    perms[#perms+1] = copy
    return
  end
  for v=1,N do
    if not used[v] then
      used[v] = true
      cur[k] = v
      gen(k+1)
      used[v] = false
    end
  end
end
gen(1)

local perm_infos = {}
for i, p in ipairs(perms) do
  perm_infos[i] = {
    perm = p,
    left = visible_from_left(p),
    right = visible_from_right(p)
  }
end

local function solve(top, bottom, left, right, max_solutions)
  max_solutions = max_solutions or 1
  -- Candidate rows per row index based on left/right clues
  local candidates = {}
  for r = 1, N do
    candidates[r] = {}
    for i, info in ipairs(perm_infos) do
      if (left[r] == 0 or left[r] == info.left) and (right[r] == 0 or right[r] == info.right) then
        candidates[r][#candidates[r]+1] = info.perm
      end
    end
    if #candidates[r] == 0 then
      return {} -- no solutions
    end
  end

  local solutions = {}
  local grid = {}
  for i=1,N do grid[i] = {} end

  local col_used = {}
  for c=1,N do col_used[c] = {} end

  local function partial_feasible(placed_rows)
  for c = 1, N do
    local seen = {}
    for r = 1, placed_rows do
      local v = grid[r][c]
      if seen[v] then return false end
      seen[v] = true
    end
  end
  return true
end

  local function place_row(row_index)
    if #solutions >= max_solutions then return end
    if row_index > N then
      for c=1,N do
        local col = {}
        for r=1,N do col[r] = grid[r][c] end
        if top[c] ~= 0 and visible_from_left(col) ~= top[c] then return end
        if bottom[c] ~= 0 and visible_from_right(col) ~= bottom[c] then return end
      end
      local sol = {}
      for r=1,N do
        sol[r] = {}
        for c=1,N do sol[r][c] = grid[r][c] end
      end
      solutions[#solutions+1] = sol
      return
    end

    for _, rowperm in ipairs(candidates[row_index]) do
      local ok = true
      for c=1,N do
        local v = rowperm[c]
        if col_used[c][v] then
          ok = false; break
        end
      end
      if not ok then goto continue end

      for c=1,N do
        local v = rowperm[c]
        grid[row_index][c] = v
        col_used[c][v] = true
      end

      if partial_feasible(row_index) then
        place_row(row_index + 1)
        if #solutions >= max_solutions then
          for c=1,N do
            local v = rowperm[c]
            col_used[c][v] = nil
            grid[row_index][c] = nil
          end
          return
        end
      end

      for c=1,N do
        local v = rowperm[c]
        col_used[c][v] = nil
        grid[row_index][c] = nil
      end

      ::continue::
    end
  end

  place_row(1)
  return solutions
end

return{
  get = function(top, bottom, left, right)
    return solve(top, bottom, left, right, 1)[1]
  end
}
