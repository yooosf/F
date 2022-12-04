--// UI Setup
local TextureToggle;
local DistanceSlider;
do
    local LastChanged = 0

    local MagSection = Variables.CatchingTab:AddSection("Texture Removed")
    local place0 = MagSection:AddToggle("Enabled", {flag = "Textures_Removed"}, function() end)

    Variables.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent then
            if input.KeyCode == place.Bind and tick() - LastChanged >= .3 then
                place0:Set(not Variables.MiscTab.Flags["Textures_Removed"], false)
            end
        end
    end)
end

local function RemoveMaterial(Part)
  if Part:IsA("BasePart") and Part.Material ~= "SmoothPlastic" then
    Part.Material = Enum.Material.SmoothPlastic
end
end

for _,Part in pairs(workspace:GetDescendants()) do
  RemoveMaterial(Part)
  game:GetService("RunService").Stepped:Wait()
end
