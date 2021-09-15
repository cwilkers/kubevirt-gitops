hs = { status="Progressing", message="No status available"}
if obj.status ~= nil then
  if obj.status.phase ~= nil then
    hs.message = obj.status.phase
    if hs.message == "Running" then
      hs.status = "Healthy"
    elseif hs.message == "Failed" then
      hs.status = "Degraded"
    elseif hs.message == "Succeeded" then
      hs.status = "Suspended"
    end
  elseif obj.status.conditions ~= nil then
    for i, condition in ipairs(obj.status.conditions) do
      if condition.type == "Ready" and condition.status == "True" then
        hs.status = "Healthy"
        hs.message = "Running"
      end
    end
  end
end
return hs
