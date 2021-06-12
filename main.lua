-- constants
local width = 10
local height = 10

-- Called once
function love.load()
  blocks = {}
  for y=1,width,1 do
    for x=1,height,1 do
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
  if love.keyboard.isDown("d") then
    player = player + 1
  end
  if love.keyboard.isDown("a") then
    player = player - 1
  end
  if love.keyboard.isDown("w") then
    player = player - width
  end
  if love.keyboard.isDown("s") then
    player = player + height
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
