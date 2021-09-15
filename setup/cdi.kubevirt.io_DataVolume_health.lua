hs = { status="Progressing", message="No status available"}
if obj.status ~= nil then
  if obj.status.phase ~= nil then
    hs.message = obj.status.phase
    if hs.message == "Succeeded" then
      hs.status = "Healthy"
    elseif hs.message == "Failed" or hs.message == "Unknown" then
      hs.status = "Degraded"
    elseif hs.message == "Paused" then
      hs.status = "Suspended"
    end
  end
end
return hs
