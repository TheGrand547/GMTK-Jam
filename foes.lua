--all enemy stuff
--foe layout, {{color triplet}, x, y}
require("constants")


function doFoeStuff(foes)
  print("that's a lotta gamers")
end

function drawFoes(foes)
  for i, foe in ipairs(foes) do
    setFoeColor(foe)
    love.graphics.rectangle("fill", foe[2] * TILE_SCALE, foe[3] * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
  end
end

function setFoeColor(foe)
    love.graphics.setColor(foe[1][1], foe[1][2], foe[1][3])
end
