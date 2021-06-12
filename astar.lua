--it is a* time fellas
require("constants")
require("util")

--returns the the location of the next place to go
--based on the wikipedia pseudocode implementation
function astar(start, walls, target, tiles)
  local untested = {start} --ones to be tested
  local history = {} --
  
  local gScore = {}
  local fScore = {}
  gScore[start] = 0
  fScore[start] = heuristic(start, target)
  while #untested > 0 do
    --fine current min, and remove from the untested list
    local current = findMin(untested, fScore)
    if current == target then
      return makePath(current, history)
    end
    for i, tile in ipairs(adjacent(current)) do
      local tempScore = gScore[current] + 1
      if gScore[tile] == nil or tempScore < gScore[tile] then
        history[tile] = current
        gScore[tile] = tempScore
        fScore[tile] = gScore[tile] + heuristic(tile, target)
        if not isInTable(untested, tile) and not isInTable(walls, tile) then
          table.insert(untested, tile)
        end
      end
    end
  end
  return nil
end

function makePath(start, map)
  if map[map[start]] ~= nil then
    return makePath(map[start], map)
  end
  return start
end

function adjacent(tile)
  local list = {}
  if (tile % WIDTH) ~= 1 then
    table.insert(list, tile - 1)
  end
  if (tile % WIDTH) ~= 0 then
    table.insert(list, tile + 1)
  end
  if tile > WIDTH then
    table.insert(list, tile - WIDTH)
  end
  if tile <= HEIGHT * (WIDTH - 1) then
    table.insert(list, tile + WIDTH)
  end
  return list
end

function heuristic(tile, target)
  local xdif = math.abs((tile % WIDTH) - (target % WIDTH))
  local ydif = math.abs(math.floor(target / WIDTH) - math.floor(tile / WIDTH))
  if xdif > ydif then return xdif end
  return ydif
end

function findMin(list, scores)
  local max = nil
  local index = nil
  for i, element in ipairs(list) do
    if max == nil or scores[element] < scores[max] then
      max = element
      index = i
    end
  end
  if index ~= nil then table.remove(list, index) end
  return max
end