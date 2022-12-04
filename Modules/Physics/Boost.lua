do loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacker1337/legohacks/main/PhysicsServiceOnClient.lua"))() end 
local Boost = {}
local PhysicsService = game:GetService("PhysicsService")
PhysicsService:CreateCollisionGroup("Heads")

--// UI Setup
local LastChanged = 0;

do
    local BoostSection = Variables.Physics:AddSection("Boost")
    local place0 = BoostSection:AddToggle("Enabled", {flag = "Boost_Enabled"}, function() end)
    local place = BoostSection:AddBind("Toggle key", Enum.KeyCode.T, {flag = "Boost_ToggleKey"}, function() 
        LastChanged = tick()
    end)

    Variables.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent then
            if input.KeyCode == place.Bind and tick() - LastChanged >= .3 then
                place0:Set(not Variables.Physics.Flags["Boost_Enabled"], false)
            end
        end
    end)
end

function Boost:Clear(Head)
    for i,v in pairs(Head:GetChildren()) do
        if not v:IsA("SpecialMesh") then v:Destroy() end 
    end
end

do
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, Player in ipairs(Variables.Players:GetPlayers()) do
            if Player ~= Variables.Client and Player.Character then
                if Player.Character:FindFirstChild("Head") and not Player.Character:FindFirstChild("CloneHead") then
                    Player.Character:FindFirstChild("Head").CanCollide = false 

                    local ClonedHead = Player.Character:FindFirstChild("Head"):Clone()
                    ClonedHead.Parent = Player.Character
                    ClonedHead.Name = "CloneHead"
                    ClonedHead.Transparency = 1
                    Boost:Clear(ClonedHead)
                    ClonedHead.Size = Vector3.new(5, 5, 5)
                    ClonedHead.CFrame = Player.Character:FindFirstChild("Head").CFrame
                    PhysicsService:SetPartCollisionGroup(ClonedHead, "Heads")
                    PhysicsService:CollisionGroupSetCollidable("Heads", "Heads", false)

                    local Weld = Instance.new("Weld", ClonedHead)
                    Weld.Part0 = Player.Character:FindFirstChild("Head")
                    Weld.Part1 = ClonedHead   
                elseif Player.Character:FindFirstChild("CloneHead") then
                    Player.Character:FindFirstChild("Head").CanCollide = false
                    local ClonedHead = Player.Character:FindFirstChild("CloneHead")
                    ClonedHead.CFrame = Player.Character:FindFirstChild("Head").CFrame
                    ClonedHead.Size = Vector3.new(5, 5, 5)
                    ClonedHead.Transparency = 1          
                    
                    if Variables.Physics.Flags["Boost_Enabled"] then
                        if Variables.Character and Variables.Character.PrimaryPart then
                            local NewParams = RaycastParams.new()
                            NewParams.FilterType = Enum.RaycastFilterType.Blacklist
                            NewParams.FilterDescendantsInstances = {Variables.Character, Player.Character}    
                            
                            local Raycast = workspace:Raycast(Variables.Character.PrimaryPart.Position, Vector3.new(0, -10, 0), NewParams)
                            if Raycast and not Raycast.Instance.Parent:FindFirstChildOfClass("Humanoid") and not Raycast.Instance.Parent.Parent:FindFirstChildOfClass("Humanoid") or Variables.Character:FindFirstChildOfClass("Tool")  then
                                ClonedHead.CanCollide = false
                            else
                                if Variables.Character.Head.Position.Y > (Player.Character.Head.Position.Y + 1) then
                                    ClonedHead.CanCollide = true                             
                                end
                            end
                        end 
                    else
                        ClonedHead.CanCollide = false
                    end

                    PhysicsService:SetPartCollisionGroup( Player.Character:FindFirstChild("Head"), "Heads")
                    PhysicsService:SetPartCollisionGroup(ClonedHead, "Heads")
                    PhysicsService:CollisionGroupSetCollidable("Heads", "Heads", false)  
                end               
            end
        end 
    end)
end


return Boost
