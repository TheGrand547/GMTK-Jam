-- print immediately
io.stdout:setvbuf("no")
require("player")
require("nonplayer")
require("constants")
require("util")
require("files")

function loadCurrentLevel()
  if currentLevel >= largest then
    gameOver = true
    playerTurn = false
  else
    playerPrimary, playerSecondary, primaryEnd, secondaryEnd, enemies, walls, largest = loadLevel("levels.txt", currentLevel)
    playerTurn = true
  end
end

-- Called once
function love.load()
  tiles = {}
  enemies = {}
  for y1 = 1, HEIGHT, 1 do
    for x1 = 1, WIDTH, 1 do
      table.insert(tiles, {x = x1, y = y1, clicked = 0})
    end
  end
  love.window.requestAttention()
  love.graphics.setBackgroundColor(0, 0, 0)
  currentLevel = 5
  largest = 1000
  gameOver = false
  loadCurrentLevel()
  normalFont = love.graphics.newFont(12)
  bigFont = love.graphics.newFont(50)
end

-- Called continuously
function love.update(dt)
  deltat = dt
  if playerPrimary == primaryEnd and playerSecondary == secondaryEnd and not gameOver then
    --load next level
    currentLevel = currentLevel + 1
    loadCurrentLevel()
  end
  -- no enemies left -> free movement
  if table.getn(enemies) == 0 then
    playerTurn = true
  elseif not playerTurn and not gameOver then
    doFoeStuff(enemies, playerPrimary, playerSecondary, tiles, walls)
    for i, foe in ipairs(enemies) do
      foe.flag = false
      if foe.tileLocation == playerPrimary or foe.tileLocation == playerSecondary then
        loadCurrentLevel()
      end
    end
    playerTurn = true
  end
end

function love.keypressed(key, scancode, isrepeat)
  if playerTurn and not isrepeat then
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
    local old = playerPrimary
    if key == "d" and (playerPrimary % WIDTH) ~= 0 then
      playerPrimary = playerPrimary + 1
    end
    if key == "a" and (playerPrimary % WIDTH) ~= 1 then
      playerPrimary = playerPrimary - 1
    end
    if key == "w" and playerPrimary > WIDTH then
      playerPrimary = playerPrimary - WIDTH
    end
    if key == "s" and playerPrimary <= HEIGHT * (WIDTH - 1) then
      playerPrimary = playerPrimary + WIDTH
    end
    if isInTable(walls, playerPrimary) or playerPrimary == playerSecondary then  
      playerPrimary = old 
    end
    if old ~= playerPrimary then 
      playerTurn = false 
    end
  end
end

-- Called continuously
function love.draw()
  drawTiles(tiles)
  --draw primary player
  drawPrimaryPlayer(tiles[playerPrimary])
  --draw secondary player
  drawSecondPlayer(tiles[playerSecondary])
  --draw enemies
  drawFoes(enemies, tiles)
  --draw walls
  drawWalls(walls, tiles)
  --draw end conditions
  drawEnd(primaryEnd, secondaryEnd, tiles)
  --draw fps
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(normalFont)
  love.graphics.print(math.floor(1 / deltat), 0, 0)
  love.graphics.print("Get the green and blue squres to the outlines of the same color, avoid the other squares.", 20, 0)
  love.graphics.print("WASD movement, space to switch, when switching you damage everything between you", 20, 20)
  if gameOver then
    love.graphics.setFont(bigFont)
    love.graphics.print("You have completed the \ngame, good job as \nI didn't really\n test this far", 0, 100)
  end
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

function centerFromBlock(index)
  local x = 0
  local y = 0
  if tiles[index] ~= nil then
    x = tiles[index].x * TILE_SCALE + TILE_SCALE / 2
    y = tiles[index].y * TILE_SCALE + TILE_SCALE / 2
  end
  return x, y
end
