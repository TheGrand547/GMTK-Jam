-- Called once
function love.load()
  x = 10
  y = 10
  t = 0
end

-- Called continuously
function love.update()
  x = x + 5 * math.cos(t)
  y = y + 5 * math.sin(t)
  t = t + .5
end

-- Called continuously
function love.draw()
    love.graphics.print("Hel3lo World!", 100, 100)
    love.graphics.rectangle("fill", x, y, 40, 50)
end