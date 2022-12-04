local success, result = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/yooosf/FF/main/initialize.lua")
if success then
    loadstring(result)()
else
    game:GetService("Players").LocalPlayer:Kick("There was an error attempting to load: Football Fusion 2 | " .. tostring(result))
end
