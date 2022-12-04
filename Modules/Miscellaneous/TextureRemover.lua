local function RemoveMaterial(Part)
  if Part:IsA("BasePart") and Part.Material ~= "SmoothPlastic" then
    Part.Material = Enum.Material.SmoothPlastic
end
end

for _,Part in pairs(workspace:GetDescendants()) do
  RemoveMaterial(Part)
  game:GetService("RunService").Stepped:Wait()
end
