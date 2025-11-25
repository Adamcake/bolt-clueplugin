local n = 5
local modulo = 3

-- lexicographic key for a vector (used to determinise nullspace ordering)
local function vec_key(v)
  local s = ""
  for i = 1, #v do
    s = s .. string.format("%02d", v[i])  -- small, fixed-width
  end
  return s
end


local function idx(x, y)
  return (x - 1) * n + y
end

local function buildMatrix()
  local A = {}
  for i = 1, n * n do
    A[i] = {}
    for j = 1, n * n do
      A[i][j] = 0
    end
  end

  for x = 1, n do
    for y = 1, n do
      local index = idx(x, y)
      local neighbors = { { x, y }, { x - 1, y }, { x + 1, y }, { x, y - 1 }, { x, y + 1 } }
      for _, nb in ipairs(neighbors) do
        local nx, ny = nb[1], nb[2]
        if nx >= 1 and nx <= n and ny >= 1 and ny <= n then
          A[index][idx(nx, ny)] = 1
        end
      end
    end
  end
  return A
end

local function inv_mod3(a)
  if a % 3 == 1 then return 1 end
  if a % 3 == 2 then return 2 end
  error("no inverse for 0 mod 3")
end

-- Deterministic Gaussian elimination mod 3, preserving pivot order
local function solveAll(A, b)
  local N = #A
  local pivots = {}
  local free_cols = {}
  local row = 1

  for col = 1, N do
    local pivot = nil
    for r = row, N do
      if A[r][col] % modulo ~= 0 then
        pivot = r
        break
      end
    end

    if pivot then
      A[row], A[pivot] = A[pivot], A[row]
      b[row], b[pivot] = b[pivot], b[row]

      local inv = inv_mod3(A[row][col])
      for j = col, N do A[row][j] = (A[row][j] * inv) % modulo end
      b[row] = (b[row] * inv) % modulo

      for r = 1, N do
        if r ~= row then
          local factor = A[r][col]
          if factor ~= 0 then
            for c = col, N do
              A[r][c] = (A[r][c] - factor * A[row][c]) % modulo
            end
            b[r] = (b[r] - factor * b[row]) % modulo
          end
        end
      end

      pivots[col] = row
      row = row + 1
    else
      table.insert(free_cols, col)
    end
  end

  -- Build particular solution
  local x0 = {}
  for i = 1, N do x0[i] = 0 end
  for col, r in ipairs(pivots) do
    x0[col] = b[r] % modulo
  end

  -- Build nullspace basis (one per free column)
  local nullspace = {}
  for _, free_col in ipairs(free_cols) do
    local v = {}
    for i = 1, N do v[i] = 0 end
    v[free_col] = 1
    for col, r in ipairs(pivots) do
      v[col] = (-A[r][free_col]) % modulo
    end
    table.insert(nullspace, v)
  end

  return x0, nullspace
end

-- -- Compare lexicographically (prefer earlier larger moves)
local function preferTopLeft(a, b)
  for i = 1, #a do
    if a[i] ~= b[i] then
      return a[i] > b[i]
    end
  end
  return false
end

local function clone(v)
  local c = {}
  for i = 1, #v do c[i] = v[i] end
  return c
end

local function sum(v, micro_bias) -- weighted
  local s = 0
  for i = 1, #v do
    if v[i] == 1 then
      s = s + (1 * i * 0.001) + micro_bias[i]       -- cost 1
    elseif v[i] == 2 then
      s = s + (1.5 * i * 0.001) + micro_bias[i]    -- cheaper than 2 singles
    end
  end
  return s
end

local function findOptimalSolution(x0, nullspace)
  local N = #x0
  local d = #nullspace
  if d == 0 then return x0 end

  -- deterministically order nullspace basis by their lexical key (so enumeration stable)
  table.sort(nullspace, function(a, b) return vec_key(a) < vec_key(b) end)

  local best, bestScore = nil, math.huge

  -- precompute per-index micro-bias to ensure strict ordering
  local micro_bias = {}
  for i = 1, N do micro_bias[i] = i * 1e-6 end

  local function search(k, current)
    -- early pruning: if partial score already >= bestScore, abort
    local ps = sum(current, micro_bias)
    if best and ps >= bestScore then return end

    if k > d then
      -- full candidate: compute exact weighted score (same as partial_score)
      local s = ps
      if (not best) or s < bestScore or (s == bestScore and preferTopLeft(current, best)) then
        best = clone(current)
        bestScore = s
      end
      return
    end

    local v = nullspace[k]
    for coeff = 0, 2 do
      local nextv = clone(current)
      for i = 1, N do
        nextv[i] = (nextv[i] + coeff * v[i]) % modulo
      end
      search(k + 1, nextv)
    end
  end

  search(1, x0)
  return best
end

local function solve(A, b)
  local x0, nullspace = solveAll(A, b)
  return findOptimalSolution(x0, nullspace)
end

return {
  get = function(state)
    local b = {}
    for i = 1, #state do
      b[i] = (3 - (state[i] % 3)) % 3
    end
    return solve(buildMatrix(), b)
  end
}
