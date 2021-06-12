-- print immediately
io.stdout:setvbuf("no")

-- constants
local WIDTH = 10
local HEIGHT = 10
local SQUARE_SIDE_LENGTH = 50
local TILE_SCALE = 51

-- Called once
function love.load()
  blocks = {}
  for y1 = 1, HEIGHT, 1 do
    for x1 = 1, WIDTH, 1 do
      table.insert(blocks, {x = x1, y = y1, clicked = false})
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

      love.graphics.rectangle("fill", elem.x * TILE_SCALE, elem.y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)

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

function love.mousepressed(x, y, k)
    colorGridOnClick(x, y)
end

function colorGridOnClick(x, y) 
    local index = blockFromPoint(x, y)
    if index ~= nil then
      print("Clicked, x: " .. x .. "\t y: " .. y)
      blocks[index].clicked = true
    end
end

--index in blocks corresponding to that point on the grid if it's a valid point, nil otherwise
function blockFromPoint(x, y)
  local index = math.floor(y / TILE_SCALE - 1) * WIDTH + math.floor(x / TILE_SCALE)
  if x > TILE_SCALE and x <= WIDTH * TILE_SCALE and y > TILE_SCALE and y < HEIGHT * TILE_SCALE and blocks[index] ~= nil then
      return index
  end
  return nil
end