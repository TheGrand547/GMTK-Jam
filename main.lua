-- print immediately
io.stdout:setvbuf("no")

-- constants
local WIDTH = 10
local HEIGHT = 10
local SQUARE_SIDE_LENGTH = 51
local TILE_SCALE = SQUARE_SIDE_LENGTH + 1

-- Called once
function love.load()
  blocks = {}
  for y1 = 1, HEIGHT, 1 do
    for x1 = 1, WIDTH, 1 do
      table.insert(blocks, {x = x1, y = y1, clicked = 0})
    end
  end
  love.window.requestAttention()
  love.graphics.setBackgroundColor(1, 1, 1)
  playerPrimary = 1
  playerSecondary = 2
end

-- Called continuously
function love.update(dt)
  deltat = dt
  if love.keyboard.isDown("d") and (playerPrimary % WIDTH) ~= 0 then
    playerPrimary = playerPrimary + 1
  end
  if love.keyboard.isDown("a") and (playerPrimary % WIDTH) ~= 1 then
    playerPrimary = playerPrimary - 1
  end
  if love.keyboard.isDown("w") and playerPrimary > HEIGHT then
    playerPrimary = playerPrimary - WIDTH
  end
  if love.keyboard.isDown("s") and playerPrimary <= HEIGHT * (WIDTH - 1) then
    playerPrimary = playerPrimary + WIDTH
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" and isrepeat == false then
    local temp = playerPrimary
    playerPrimary = playerSecondary
    playerSecondary = temp
    local x1, y1 = centerFromBlock(playerSecondary)
    local x2, y2 = centerFromBlock(playerPrimary)
    local angle = math.atan2(y2 - y1, x2 - x1)
    local x, y = x1, y1
    while temp ~= playerPrimary and temp ~= nil do
      blocks[temp].clicked = 5
      x = x + 5 * math.cos(angle)
      y = y + 5 * math.sin(angle)
      temp = blockFromPoint(x, y)
    end
  end
end


-- Called continuously
function love.draw()
    for i, elem in ipairs(blocks) do
      love.graphics.setColor(0, 0, 0)
      -- sloppy
      if i == playerPrimary then
        love.graphics.setColor(1, 0, 0)
      elseif i == playerSecondary then
        love.graphics.setColor(0, 0, 1)
      elseif elem.clicked > 0 then
        love.graphics.setColor(0, 1, 0)
      end

      love.graphics.rectangle("fill", elem.x * TILE_SCALE, elem.y * TILE_SCALE, SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH)
      
      if elem.clicked > 0 then
        elem.clicked = elem.clicked - 1
      end
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(1 / deltat, 0, 0)
end

function love.mousepressed(x, y, k)
    colorGridOnClick(x, y)
end

function colorGridOnClick(x, y) 
    local index = blockFromPoint(x, y)
    if index ~= nil then
      print("Clicked, x: " .. x .. "\t y: " .. y)
      blocks[index].clicked = 10
    end
end

--index in blocks corresponding to that point on the grid if it's a valid point, nil otherwise
function blockFromPoint(x, y)
  local index = math.floor(y / TILE_SCALE - 1) * WIDTH + math.floor(x / TILE_SCALE)
  if x >= TILE_SCALE and x <= (WIDTH + 1) * TILE_SCALE and y >= TILE_SCALE and y <= (HEIGHT + 1) * TILE_SCALE and blocks[index] ~= nil then
      return index
  end
  return nil
end

--there is a bug here and i can't for the life of me find it, it's exceptionally painful as this messes up my line calculations >:(
--if you fix one thing fix this, so that the proper lines(and thus the eventual checks) can be made without me spending years finding this error
function centerFromBlock(index)
  local x = 0
  local y = 0
  if blocks[index] ~= nil then
    x = blocks[index].x * TILE_SCALE + TILE_SCALE / 2
    y = blocks[index].y * TILE_SCALE + TILE_SCALE / 2
  end
  return x, y
end
