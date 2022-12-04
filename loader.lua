local success, result = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/yoo123fd/f/master/initialize.lua")
if success then
    loadstring(result)()
else
    game:GetService("Players").LocalPlayer:Kick("There was an error attempting to load: Football Fusion 2 | " .. tostring(result))
end
