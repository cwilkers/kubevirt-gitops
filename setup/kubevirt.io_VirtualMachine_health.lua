hs = { status="Progressing", message="No status available"}
if obj.status ~= nil then
  if obj.status.printableStatus ~= nil then
    hs.message = obj.status.printableStatus
    if hs.message == "Running" then
      hs.status = "Healthy"
    elseif hs.message == "Stopped" or hs.message == "Paused" then
      hs.status = "Suspended"
    elseif hs.message == "Unknown" then
      hs.status = "Degraded"
    end
  elseif obj.status.ready ~= nil then
    hs.status = "Healthy"
    hs.message = "Running"
  end
end
return hs
