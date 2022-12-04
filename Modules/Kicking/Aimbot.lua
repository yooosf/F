local Aimbot = {}

do
    local AimbotSection = Variables.Kicking:AddSection("Aimbot")
    AimbotSection:AddToggle("Enabled", {flag = "KickerAimbot_Enabled"}, function() end)
end

function Aimbot:GetAccuracyArrow(Arrows)
    local Y = 0
    local Arrow1 = nil

    for _, Arrow in pairs(Arrows) do
        if Arrow.Position.Y.Scale > Y then
            Y = Arrow.Position.Y.Scale
            Arrow1 = Arrow 
        end
    end

    return Arrow1
end

Variables.Client.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "KickerGui" and Variables.Kicking.Flags["KickerAimbot_Enabled"] then
        local KickerGui = child 
        local Meter = KickerGui:FindFirstChild("Meter")
        local Cursor = Meter:FindFirstChild("Cursor")
        local Arrows = {}
        
        for i,v in pairs(Meter:GetChildren()) do
            if string.find(v.Name:lower(), "arrow") then
                table.insert(Arrows, v)
            end
        end 

        repeat task.wait() until Cursor.Position.Y.Scale < 0.02
        mouse1click()
        repeat task.wait() until Cursor.Position.Y.Scale >= Aimbot:GetAccuracyArrow(Arrows).Position.Y.Scale + (.03 / (100 / 100))
        mouse1click()
    end
end)


return Aimbot
