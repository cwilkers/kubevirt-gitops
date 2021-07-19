hs = { status="Progressing", message="No status available"}
if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Succeeded" then
      hs.status = "Healthy"
    elseif obj.status.phase == "Failed" then
      hs.status = "Degraded"
    end
    hs.message = obj.status.phase
  end
end
return hs
