local DynamicJump = {}

local PowerSlider;
do
    local DynamicSection = Variables.Physics:AddSection("Dynamic Jump")
    local place0 = DynamicSection:AddToggle("Enabled", {flag = "Dynamic_Enabled"}, function() end)
    PowerSlider = DynamicSection:AddSlider("Minimum", 50, 100, 50, {flag = "Dynamic_Minimum"}, function() end) 
end


DynamicJump.Bypassed = false 

function DynamicJump:BypassAnti_Cheat()
    if DynamicJump.Bypassed == false then
        DynamicJump.Bypassed = true 
        for i,v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
                for k, x in pairs(debug.getconstants(v)) do
                    if x and tonumber(x) and tonumber(x) > 49 and tonumber(x) < 51 then
                        debug.setconstant(v, k, 120)
                    end
                end
            end
        end
    end
end 

do
    game:GetService("RunService").RenderStepped:Connect(function()
        if Variables.Physics.Flags["Dynamic_Enabled"] then
            DynamicJump:BypassAnti_Cheat()
            if workspace:FindFirstChild("Football") then
                local H = Variables.Character and Variables.Character:WaitForChild("Humanoid")
                local H2 = Variables.Character and Variables.Character:WaitForChild("Head")
                if H and H2 then
                    local H2 = math.abs((H2.Position.Y - workspace:FindFirstChild("Football").Position.Y))
                    local JP = workspace:CalculateJumpPower(workspace.Gravity, H2)
                    JP = math.clamp(JP, 50, PowerSlider.Value)
                    H.JumpPower = JP 
                end
            end
        end
    end) 
end


return DynamicJump
