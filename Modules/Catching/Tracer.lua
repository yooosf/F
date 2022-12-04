local Tracer = {}

--// UI Setup
--// UI Setup
do
    local TracerSection = Variables.CatchingTab:AddSection("Tracer")
    TracerSection:AddToggle("Enabled", {flag = "Tracer_Enabled"}, function() end)
end

function Tracer:AttachBall(Ball)
    local RootPart = Variables.Character and Variables.Character.PrimaryPart
    if RootPart then
        if Ball then
            local Tracer = Drawing.new("Line")
            Tracer.Visible = false
            Tracer.Color = Color3.fromRGB(255, 0, 0)
            Tracer.Thickness = 1
            Tracer.Transparency = 1

            local TextLabel = Drawing.new("Text")
            TextLabel.Text = ""
            TextLabel.Transparency = 1
            TextLabel.Visible = false 
            TextLabel.Color = Color3.fromRGB(255, 0, 0)
            TextLabel.Size = 25

            local con; con = game:GetService("RunService").RenderStepped:Connect(function()
                if RootPart.Parent ~= nil and Ball.Parent ~= nil then
                    local Vector, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Ball.Position)
                    local Vector2_, OnScreen2 = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    local Distance = (RootPart.Position - Ball.Position).Magnitude 

                    if OnScreen and OnScreen2 then
                        Tracer.From = Vector2.new(Vector2_.X, Vector2_.Y)
                        Tracer.To = Vector2.new(Vector.X, Vector.Y)
                        Tracer.Visible = true 
                        TextLabel.Visible = true 

                        TextLabel.Text = tostring(math.round(Distance)) .. " studs away"
                        TextLabel.Position = Vector2.new(Vector.X, Vector.Y)
                        
                        if Distance <= Variables.MagDistance then
                            TextLabel.Color = Color3.fromRGB(0, 255, 0)
                            Tracer.Color = Color3.fromRGB(0, 255, 0)
                        else
                            TextLabel.Color = Color3.fromRGB(255, 0, 0)
                            Tracer.Color = Color3.fromRGB(255, 0, 0)
                        end
                    else
                        Tracer.Visible = false
                        TextLabel.Visible = false 
                    end
                else
                    con:Disconnect()
                    Tracer.Visible = false
                    TextLabel.Visible = false 
                end
            end)
        end
    end
end

do
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Football" and Variables.CatchingTab.Flags["Tracer_Enabled"] then
            Tracer:AttachBall(child)
        end
    end)
end

return Tracer 
