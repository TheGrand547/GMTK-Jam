--all enemy stuff
--foe layout, {tileLocation, type, hp, bool flag}
require("constants")
require("astar")

types = {BASIC = 1, ALT_BASIC = 2, ADVANCED = 3, FAST = 4, ALT_FAST = 5, ADVANCED_FAST = 6}
-- TODO, different colors per type, end state of each one, reset foe[4] flag each time, then file -> maps, then UI polish stuff
function doFoeStuff(foes, p1, p2, tiles, walls)
  for i, foe in ipairs(foes) do
    --should be a cleaner way to do this but whatever
    if foe[2] == types.BASIC then
      basicFoe(foe, foes, i, p1, p2, tiles, walls)
    elseif foe[2] == types.ALT_BASIC then
      --go for p2 instead of p1
      basicFoe(foe, foes, i, p2, p1, tiles, walls)
    elseif foe[2] == types.ADVANCED then
      advancedFoe(foe, foes, i, p1, p2, tiles, walls)
    elseif foe[2] == types.FAST then
      basicFoe(foe, foes, i, p1, p2, tiles, walls)
      basicFoe(foe, foes, i, p1, p2, tiles, walls)
    elseif foe[2] == types.ALT_FAST then
      --go for p2 instead of p1
      basicFoe(foe, foes, i, p2, p1, tiles, walls)
      basicFoe(foe, foes, i, p2, p1, tiles, walls)
    else --advanced fast
      advancedFoe(foe, foes, i, p1, p2, tiles, walls)
      advancedFoe(foe, foes, i, p1, p2, tiles, walls)
    end
  end
end

function advancedFoe(foe, foes, i, p1, p2, tiles, walls)
  local one = heuristic(foe[1], p1)
  local two = heuristic(foe[1], p2)
  -- go to the closer of the two
  if one < two then
    basicFoe(foe, foes, i, p1, p2, tiles, walls)
  else
    basicFoe(foe, foes, i, p2, p1, tiles, walls)
  end
end

function basicFoe(foe, foes, i, p1, p2, tiles, walls)
  if tiles[foe[1]].clicked > 0 and not foe[4] then
    foe[3] = foe[3] - 1
    if foe[3] == 0 then 
      table.remove(foes, i)
      return
    end
    foe[4] = true
  end
  local new = astar(foe[1], walls, p1, tiles)
  if new ~= null then 
    foe[1] = new 
  end
end

function drawFoes(foes, tiles)
  for i, foe in ipairs(foes) do
    setFoeColor(foe)
    love.graphics.rectangle("fill", tiles[foe[1]].x * TILE_SCALE, tiles[foe[1]].y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
    drawHealth(foe, tiles)
  end
end

function drawHealth(foe, tiles) 
  for i = 1, foe[3] + 1, 1 do
    love.graphics.setColor(1, 1, .84 - (1.0 / (i + 1)))
    love.graphics.rectangle("line", tiles[foe[1]].x * TILE_SCALE + i, tiles[foe[1]].y * TILE_SCALE + i, SQUARE_SIDE_LENGTH - 2 * i, SQUARE_SIDE_LENGTH - 2 * i)
  end
end


function setFoeColor(foe)
  if foe[2] == types.BASIC  then
    love.graphics.setColor(1, 0, 0)
  elseif foe[2] == types.ALT_BASIC then
    love.graphics.setColor(1, .5, 0)
  end
end

--oh and walls for giggles
function drawWalls(walls, tiles)
  for i, wall in ipairs(walls) do
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", tiles[wall].x * TILE_SCALE, tiles[wall].y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
  end
end

--and tiles
function drawTiles(tiles)
  love.graphics.setColor(.5, .5, .5)
  for i, elem in ipairs(tiles) do
    love.graphics.rectangle("fill", elem.x * TILE_SCALE, elem.y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
    if elem.clicked > 0 then
      love.graphics.setColor(0, 1, 1)
      elem.clicked = elem.clicked - 1
      --outline the affected tiles
      love.graphics.rectangle("line", elem.x * TILE_SCALE - 1, elem.y * TILE_SCALE - 1, SQUARE_SIDE_LENGTH + 1, SQUARE_SIDE_LENGTH + 1)
      love.graphics.setColor(.5, .5, .5)
    end
  end
end