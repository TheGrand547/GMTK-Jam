--file concerning loading of stuff
require("nonplayer")

function loadLevel(name, level)
  --NO SPACES
  --first line is: player1Start,player2Start,player1End,player2End,
  --second line is: wallPosition1,wallPosition2,...
  --third line is: start+type,start+type,...
  --with type being the enemy type and start being their location
  local player = 0
  local player2 = 0
  local end1 = 0
  local end2 = 0
  local foes = {} 
  local walls = {}
  local current = 0
  for line in love.filesystem.lines(name) do
    if current >= level * 3 and current < (level + 1) * 3 then
      local split = mysplit(line,",")
      if current % 3 == 0 then
        --player stuff
        player = tonumber(split[1])
        player2 = tonumber(split[2])
        end1 = tonumber(split[3])
        end2 = tonumber(split[4])
      elseif current % 3 == 1 then
        --walls
        for i, str in ipairs(split) do
          table.insert(walls, tonumber(str))
        end
      else
        --baddy stuff
        for i, str in ipairs(split) do
          local subtable = mysplit(str, "+")
          table.insert(foes, makeFoe(tonumber(subtable[1]), tonumber(subtable[2])))
        end
      end

    end
    current = current + 1 
  end
  return player, player2, end1, end2, foes, walls, math.floor(current / 3)
end

--https://stackoverflow.com/a/7615129
function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end