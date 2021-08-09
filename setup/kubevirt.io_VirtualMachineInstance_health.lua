hs = { status="Progressing", message="No status available"}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    for i, condition in ipairs(obj.status.conditions) do
      if condition.type == "Ready" and condition.status == "True" then
        hs.status = "Healthy"
        hs.message = "Status is Ready"
      end
    end
  end
  if obj.status.phase ~= nil then
    hs.message = obj.status.phase
  end
end
return hs
