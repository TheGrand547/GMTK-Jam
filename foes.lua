--all enemy stuff
--foe layout, {{color triplet}, tileLocation}
require("constants")
require("astar")

function doFoeStuff(foes, p1, p2, tiles, walls)
  for i, foe in ipairs(foes) do
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