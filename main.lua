-- constants
local WIDTH = 10
local HEIGHT = 10

-- Called once
function love.load()
  blocks = {}
  for y=1,HEIGHT,1 do
    for x=1,WIDTH,1 do
      table.insert(blocks, {x, y})
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
      love.graphics.rectangle("fill", elem[1] * 51, elem[2] * 51, 50, 50)
      if i == player then
        love.graphics.setColor(0, 0, 0)
      end
    end
    love.graphics.print(1 / deltat, 0, 0)
end
