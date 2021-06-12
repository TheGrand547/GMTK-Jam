--all enemy stuff
--foe layout, {{color triplet}, tileLocation}
require("constants")
require("astar")

function doFoeStuff(foes, p1, p2, tiles, walls)
  for i, foe in ipairs(foes) do
    if tiles[foe[2]].clicked > 0 then 
      table.remove(foes, i) 
    end
    local new = astar(foe[2], walls, p1, tiles)
    if new ~= null then foe[2] = new end
  end
end

function drawFoes(foes, tiles)
  for i, foe in ipairs(foes) do
    setFoeColor(foe)
    love.graphics.rectangle("fill", tiles[foe[2]].x * TILE_SCALE, tiles[foe[2]].y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
  end
end

function setFoeColor(foe)
    love.graphics.setColor(foe[1][1], foe[1][2], foe[1][3])
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
      love.graphics.setColor(1, 1, 0)
      elem.clicked = elem.clicked - 1
      --outline all affected tiles
      love.graphics.rectangle("line", elem.x * TILE_SCALE - 1, elem.y * TILE_SCALE - 1, SQUARE_SIDE_LENGTH + 1, SQUARE_SIDE_LENGTH + 1)
      love.graphics.setColor(.5, .5, .5)
    end
  end
end