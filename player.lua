require("constants")
-- player drawing
function drawPrimaryPlayer(block)
  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", block.x * TILE_SCALE, block.y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
end

function drawSecondPlayer(block)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", block.x * TILE_SCALE, block.y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
end
