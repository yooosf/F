local Mags = {
    Using = false
}

--// UI Setup
local MagToggle;
local DistanceSlider;
do
    local LastChanged = 0

    local MagSection = Variables.CatchingTab:AddSection("Mags")
    local place0 = MagSection:AddToggle("Enabled", {flag = "Mags_Enabled"}, function() end)
    getgenv().Variables.MagDistance = 8
    DistanceSlider = MagSection:AddSlider("Distance", 1, 40, 8, {flag = "Mags_Distance"}, function() 
        getgenv().Variables.MagDistance = DistanceSlider.Value
    end) 
    local place = MagSection:AddBind("Toggle key", Enum.KeyCode.Q, {flag = "Mags_ToggleKey"}, function() 
        LastChanged = tick()
    end)

    Variables.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent then
            if input.KeyCode == place.Bind and tick() - LastChanged >= .3 then
                place0:Set(not Variables.CatchingTab.Flags["Mags_Enabled"], false)
            end
        end
    end)
end

--// Bootup

do
    local cached = {}

    function hookconnections(obj, connection, _function)
        local connection = obj[connection]
        for i,v in pairs(getconnections(connection)) do
            v:Disable()
            local old = v.Function
            connection:Connect(_function, old)
        end
    end 

    
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, Football in pairs(workspace:GetChildren()) do
            if not cached[Football] then
                cached[Football] = {} 
                hookconnections(Football, "AncestryChanged", function()
                    return nil 
                end)
            end
        end
    end)
      

    task.spawn(function()
        while true do
            if game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Vector3Value") then
                game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Vector3Value").Value = Vector3.new()
            end

            task.wait() 
        end
    end)
end

function Mags:Validated()
    return Variables.ReplicatedStorage:WaitForChild("Values"):WaitForChild("Fumble").Value ~= true and Variables.ReplicatedStorage:WaitForChild("Values"):WaitForChild("Status").Value == "InPlay"
end

function Mags:Mag(Football)
    local Character = Variables.Character
    if Character then
        self.Using = true
        local Starting = tick()
        local Connections = {}

        local LeftArm = Character and Character:FindFirstChild("Left Arm")
        local RightArm = Character and Character:FindFirstChild("Right Arm")

        local LeftArmDist, RightArmDist = LeftArm and (LeftArm.Position - Football.Position).Magnitude or 0, RightArm and (RightArm.Position - Football.Position).Magnitude or 0
        local Distance = LeftArmDist <= RightArmDist and LeftArm or RightArmDist <= LeftArmDist and RightArm
    
        if not LeftArm or not RightArm then self.Using = false return end 
        if not self:Validated() then self.Using = false return end 

        local function StopLoop()
            Starting = nil 
            for _, connection in pairs(Connections) do
                connection:Disconnect()
            end
            table.clear(Connections)
            self.Using = false 
        end

        local function BallUpdate()
            if Starting == nil then return end 
            local Now = tick()

            if (Now - Starting) > 5 then
                StopLoop()
                return 
            end

            if not self:Validated() then
                StopLoop()
                return
            end 

            if Football and Football.Parent then
                Football.CanCollide = false 
                firetouchinterest(Distance, Football, 0)
                task.wait()
                firetouchinterest(Distance, Football, 1)
            else
                StopLoop()
            end
        end

        table.insert(Connections, game:GetService("RunService").RenderStepped:Connect(BallUpdate))
        table.insert(Connections, game:GetService("RunService").Stepped:Connect(BallUpdate))
        table.insert(Connections, game:GetService("RunService").Heartbeat:Connect(BallUpdate))
    end
end

function Mags:Activate()
    local ClosestDistance = math.huge; local ClosestFootball = nil; 
    for _, Part in pairs(workspace:GetChildren()) do
        if Part.Name == "Football" and Part:IsA("BasePart") then
            local RootPart = (Variables.Character and Variables.Character.PrimaryPart)
            if (RootPart) then
                local Distance =  RootPart and (RootPart.Position - Part["Position"]).Magnitude or 0
                if Distance < ClosestDistance and Distance < DistanceSlider.Value then
                    ClosestFootball = Part 
                    ClosestDistance = Distance 
                end
            end
        end
    end

    if (ClosestFootball) then
        self:Mag(ClosestFootball)
    end
end

do
    game:GetService("RunService").RenderStepped:Connect(function()
        if Variables.CatchingTab.Flags["Mags_Enabled"] then
            Mags:Activate()
        end
    end)
end


return Mags 
