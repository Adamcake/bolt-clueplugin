local n = 5
local modulo = 3

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

local function solve(A, b)
  local N = #A
  local x = {}
  for i = 1, N do x[i] = 0 end

  local row = 1
  for col = 1, N do
    local pivot = row
    while pivot <= N and A[pivot][col] % modulo == 0 do pivot = pivot + 1 end

    if pivot <= N then
      A[row], A[pivot] = A[pivot], A[row]
      b[row], b[pivot] = b[pivot], b[row]

      local inv = 1
      while (A[row][col] * inv) % modulo ~= 1 do inv = inv + 1 end
      for j = col, N do A[row][j] = (A[row][j] * inv) % modulo end
      if b[row] == nil then return nil end
      b[row] = (b[row] * inv) % modulo

      for r = 1, N do
        if r ~= row then
          local factor = A[r][col]
          for c = col, N do
            A[r][c] = (A[r][c] - factor * A[row][c]) % modulo
          end
          b[r] = (b[r] - factor * b[row]) % modulo
        end
      end
      row = row + 1
    end
  end

  for r = row, N do
    local allZero = true
    for c = 1, N do
      if A[r][c] % modulo ~= 0 then
        allZero = false
        break
      end
    end
    -- if allZero and b[r] % modulo ~= 0 then
    --   print("No solution exists")
    -- end
  end

  for i = 1, N do x[i] = b[i] % modulo end
  return x
end

return {
  get = function(state)
    return solve(buildMatrix(), state)
  end
}
