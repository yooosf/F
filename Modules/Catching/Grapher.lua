local Grapher = {}

--// UI Setup
do
    local GrapherSection = Variables.CatchingTab:AddSection("Grapher")
    GrapherSection:AddToggle("Enabled", {flag = "Grapher_Enabled"}, function() end)
end

Grapher.Marker = Instance.new("Part")
Grapher.Marker.Anchored = true
Grapher.Marker.Transparency = .8
Grapher.Marker.Color = Color3.fromRGB(255, 0, 0)
Grapher.Marker.CanCollide = false
Grapher.Marker.Name = "Marker"

Grapher.Params = RaycastParams.new()
Grapher.Params.IgnoreWater = true 
Grapher.Params.FilterType = Enum.RaycastFilterType.Whitelist

Grapher.CastStep = 3 / 60

Grapher.LastSavedPower = 60

function Grapher:GetCollidables()
    local Collidables = {}
    
    for _, BasePart in ipairs(workspace:GetDescendants()) do
        if BasePart:IsA("BasePart") and BasePart.CanCollide == true then
            table.insert(Collidables, BasePart)
        end
    end
    return Collidables
end

function Grapher:WipeMarkers()
    for i,v in pairs(workspace:GetChildren()) do
        if v.Name == "Marker" then v:Destroy() end
    end
end

function Grapher:GetLanding(origin, velocity, c)
    local Elapsed = 0
    local LastPos = origin
    
    self.Params.FilterDescendantsInstances = self:GetCollidables()
    
    local Football_Highlight;

    if c then
        Football_Highlight = Instance.new("Highlight", game.CoreGui)
        Football_Highlight.Adornee = c 
        Football_Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Football_Highlight.Enabled = true  
    end

    while true do
        Elapsed += Grapher.CastStep

        local nPos = origin + velocity * Elapsed - Vector3.new(0, .5 * 28 * Elapsed ^ 2, 0)
        
        local Marker = self.Marker:Clone(); Marker.Parent = workspace; Marker.Position = nPos
        if c and Football_Highlight and c.Parent ~= workspace or c and not c:FindFirstChildOfClass("BodyForce") then
            Football_Highlight:Destroy()
            self:WipeMarkers()
            break
        end

        task.wait()
    end
end

do
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Football" and child:IsA("BasePart") and Variables.CatchingTab.Flags["Grapher_Enabled"] then
            local tempCon; tempCon = child:GetPropertyChangedSignal("Velocity"):Connect(function()
                Grapher:GetLanding(child.Position, child.Velocity, child)
                tempCon:Disconnect()
            end)
        end
    end)     

    --[[
    Variables.Client.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "BallGui" then
            task.spawn(function()
                while true do if Variables.CatchingTab.Flags["Grapher_Enabled"] then
                    if child.Parent ~= Variables.Client.PlayerGui then break end 
                    local Frame = child:FindFirstChild("Frame")
                    local Display = Frame and Frame:FindFirstChild("Disp")
                    local Power = Display and tonumber(Display.Text)
                    if Power ~= nil then
                        Grapher.LastSavedPower = Power
                    end 

                    Grapher:GetLanding(Variables.Character:FindFirstChild("Head").Position, ((Variables.Client:GetMouse().Hit.Position - Variables.Character:FindFirstChild("Head").Position).Unit * Grapher.LastSavedPower))
                    task.wait(.2)
                    Grapher:WipeMarkers()
                    task.wait()
                end
                end
            end)
        end
    end)
    --]]
end


return Grapher 
