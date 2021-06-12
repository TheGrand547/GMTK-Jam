--it is a* time fellas
require("constants")

--returns the the location of the next place to go
--based on the wikipedia pseudocode implementation
function astar(start, walls, target, tiles)
  local untested = {start} --ones to be tested
  local history = {} --
  
  local gScore = {}
  local fScores = {}
  testScores[start] = 0
  while #untested > 0 do
    local current = 
    if current == target then
      return makePath(current, history)
    end
    
  end
  return nil
end

function makePath(start, map)
  if map[start] != nil
    return makePath(map[start], map)
  end
  return nil
end

function adjacent(tile)
  local list = {}
  if (tile % WIDTH) ~= 1 then
    print("well gamers")
  end
  return list
end

function heuristic(tile)
  return nil
end