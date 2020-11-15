local localPlayer = game:GetService("Players").LocalPlayer
local currentCamera = game:GetService("Workspace").CurrentCamera
local mouse = localPlayer:GetMouse()
local teamCheck = true

function getClosestPlayerToCursor() [nonamecall]
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Name ~= localPlayer.Name then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and teamCheck and v.Team ~= localPlayer.Team then
                local pos = currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude

                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            elseif v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and not teamCheck then
                local pos = currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude

                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    
    return closestPlayer or localPlayer
end

game:GetService("UserInputService").InputBegan:Connect(function(input, onGui)
    if not onGui and input.KeyCode == Enum.KeyCode.T then
        teamCheck = not teamCheck
    end
end)

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end
local namecallMethod = getnamecallmethod or get_namecall_method
local newClose = newcclosure or function(f) return f end

mt.__namecall = newClose(function(...) [nonamecall]
    local method = namecallMethod()
    local args = {...}

    if tostring(method) == "FireServer" and tostring(args[1]) == "HitPart" then
        args[2] = getClosestPlayerToCursor().Character.Head
        args[3] = getClosestPlayerToCursor().Character.Head.Position

        return oldNamecall(unpack(args))
    end

    return oldNamecall(...)
end)

if setreadonly then setreadonly(mt, true) else make_writeable(mt, false) end