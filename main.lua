-- Called once
function love.load()
  blocks = {}
  for x=1,10,1 do
    for y=1,10,1 do
      table.insert(blocks, {x * 51, y * 51})
    end
  end
  love.window.requestAttention()
  love.graphics.setBackgroundColor(1, 1, 1)
end

-- Called continuously
function love.update(dt)
  deltat = dt
end

-- Called continuously
function love.draw()
    love.graphics.setColor(0, 0, 0)
    --love.graphics.rectangle("fill", x, y, 50, 50)
    for i,elem in ipairs(blocks) do
      love.graphics.rectangle("fill", elem[1], elem[2], 50, 50)
    end
    love.graphics.print(1 / deltat, 0, 0)
end