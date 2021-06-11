-- Called once
function love.load()
  blocks = {}
  x = 300
  y = 300
  t = 0
  deltat = 0
  love.window.requestAttention()
  love.graphics.setBackgroundColor(1, 1, 0)
end

-- Called continuously
function love.update(dt)
  x = x + 100 * math.cos(t) * dt
  y = y + 100 * math.sin(t) * dt 
  t = t + 10 * math.pi / 360
  deltat = dt
end

-- Called continuously
function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x, y, 40, 50)
    love.graphics.print(1 / deltat, 100, 100)
end