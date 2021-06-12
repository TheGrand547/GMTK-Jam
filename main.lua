-- constants
local WIDTH = 10
local HEIGHT = 10
local SQUARE_SIDE_LENGTH = 50

-- Called once
function love.load()
  blocks = {}
  for y1=1,HEIGHT,1 do
    for x1=1,WIDTH,1 do
      table.insert(blocks, {x=x1, y=y1, clicked=false})
    end
  end
  love.window.requestAttention()
  love.graphics.setBackgroundColor(1, 1, 1)
  player = 1
end

-- Called continuously
function love.update(dt)
  deltat = dt
  if love.keyboard.isDown("d") and (player % WIDTH) ~= 0 then
    player = player + 1
  end
  if love.keyboard.isDown("a") and (player % WIDTH) ~= 1 then
    player = player - 1
  end
  if love.keyboard.isDown("w") and player > HEIGHT then
    player = player - WIDTH
  end
  if love.keyboard.isDown("s") and player < HEIGHT * (WIDTH - 1) then
    player = player + WIDTH
  end
end

-- Called continuously
function love.draw()
    love.graphics.setColor(0, 0, 0)
    for i,elem in ipairs(blocks) do
      -- sloppy
      if i == player then
        love.graphics.setColor(1, 0, 0)
      end
      if elem.clicked then
        love.graphics.setColor(0, 1, 0)
      end

      love.graphics.rectangle("fill", elem.x * 51, elem.y * 51, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)

      if i == player then
        love.graphics.setColor(0, 0, 0)
      end
      if elem.clicked then
        love.graphics.setColor(0, 0, 0)
        elem.clicked = false
      end
    end
    love.graphics.print(1 / deltat, 0, 0)
end

function love.mousepressed(x,y,k)
    colorGridOnClick(x, y)
end

function colorGridOnClick(x, y) 
    print("Clicked, x: " .. x .. "\t y: " .. y)
    for i,elem in ipairs(blocks) do -- I don't know if I like O(n) per click but since n is ~10 it's ok I guess
        local squareX = elem.x * 51
        local squareY = elem.y * 51
        if x > squareX and x < squareX + SQUARE_SIDE_LENGTH and y > squareY and y < squareY + SQUARE_SIDE_LENGTH then -- Checks if the mouse is on the grid
            elem.clicked = true
        end
    end
end
