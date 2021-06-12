function isInTable(table, value)
  for i, e in ipairs(table) do
    if e == value then return true end
  end
  return false
end