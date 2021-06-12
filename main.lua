-- print immediately
io.stdout:setvbuf("no")
require("player")
require("foes")
require("constants")
require("astar")
-- Called once
function love.load()
  tiles = {}
  enemies = {}
  walls = {} -- wall element is just {tile}
  table.insert(enemies, {{0, 0, 1}, 6})
  for y1 = 1, HEIGHT, 1 do
    for x1 = 1, WIDTH, 1 do
      table.insert(tiles, {x = x1, y = y1, clicked = 0})
    end
  end
  love.window.requestAttention()
  love.graphics.setBackgroundColor(0, 0, 0)
  playerPrimary = 1
  playerSecondary = 2
  playerTurn = true
end

-- Called continuously
function love.update(dt)
  deltat = dt
  -- no enemies left -> free movement
  if table.getn(enemies) == 0 then
    playerTurn = true
  elseif playerTurn == false then
    doFoeStuff(enemies)
    playerTurn = true
  end
end

function love.keypressed(key, scancode, isrepeat)
  if playerTurn == true and isrepeat == false then
    if key == "space" then
      playerTurn = false
      local temp = playerPrimary
      playerPrimary = playerSecondary
      playerSecondary = temp
      local x1, y1 = centerFromBlock(playerSecondary)
      local x2, y2 = centerFromBlock(playerPrimary)
      local angle = math.atan2(y2 - y1, x2 - x1)
      local x, y = x1, y1
      local offset = 1
      while temp ~= playerPrimary and temp ~= nil do
        tiles[temp].clicked = 1.5 * offset
        x = x + 5 * math.cos(angle)
        y = y + 5 * math.sin(angle)
        local scratch = blockFromPoint(x, y)
        if scratch ~= temp then
          offset = offset + 1
          temp = scratch
        end
      end
    end
    if key == "d" and (playerPrimary % WIDTH) ~= 0 then
      playerPrimary = playerPrimary + 1
      playerTurn = false
    end
    if key == "a" and (playerPrimary % WIDTH) ~= 1 then
      playerPrimary = playerPrimary - 1
      playerTurn = false
    end
    if key == "w" and playerPrimary > HEIGHT then
      playerPrimary = playerPrimary - WIDTH
      playerTurn = false
    end
    if key == "s" and playerPrimary <= HEIGHT * (WIDTH - 1) then
      playerPrimary = playerPrimary + WIDTH
      playerTurn = false
    end
  end
end

-- Called continuously
function love.draw()
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
    
    --draw primary player
    drawPrimaryPlayer(tiles[playerPrimary])
    --draw secondary player
    drawSecondPlayer(tiles[playerSecondary])
    --draw enemies
    drawFoes(enemies)
    --draw time
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(1 / deltat, 0, 0)
end

function love.mousepressed(x, y, k)
    colorGridOnClick(x, y)
end

function colorGridOnClick(x, y) 
    local index = blockFromPoint(x, y)
    if index ~= nil then
      print("Clicked, x: " .. x .. "\t y: " .. y)
      tiles[index].clicked = 10
    end
end

--index in tiles corresponding to that point on the grid if it's a valid point, nil otherwise
function blockFromPoint(x, y)
  local index = math.floor(y / TILE_SCALE - 1) * WIDTH + math.floor(x / TILE_SCALE)
  if x >= TILE_SCALE and x <= (WIDTH + 1) * TILE_SCALE and y >= TILE_SCALE and y <= (HEIGHT + 1) * TILE_SCALE and tiles[index] ~= nil then
      return index
  end
  return nil
end

--there is a bug here and i can't for the life of me find it, it's exceptionally painful as this messes up my line calculations >:(
--if you fix one thing fix this, so that the proper lines(and thus the eventual checks) can be made without me spending years finding this error
function centerFromBlock(index)
  local x = 0
  local y = 0
  if tiles[index] ~= nil then
    x = tiles[index].x * TILE_SCALE + TILE_SCALE / 2
    y = tiles[index].y * TILE_SCALE + TILE_SCALE / 2
  end
  return x, y
end
