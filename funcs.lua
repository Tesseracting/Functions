local start = os.time()
print('Started')
FT = {}
local PRINT_DOCUMENTATION = false

FT.mult = function(str, length)
	if length > 0 and tonumber(length) ~= nil then
		local multipliedstring = ''
		for i=1, length do 
			multipliedstring = multipliedstring .. str
		end
		return multipliedstring
	else
		warn("The number that you supplied to be multiply the string by was either negative or not a number.")
	end
end

FT.ClosestPlayerToCursor = function()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and v.Team ~= localPlayer.Team then
            local pos = currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude

            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    
    return closestPlayer or localPlayer
end

FT.TableToString = function(giventable, seperator)
	if not seperator then seperator = '' end
	local newtable = {}
	for _, stuff in pairs(giventable) do
		table.insert(newtable, tostring(stuff) .. tostring(seperator))
	end
	return unpack(newtable)
end

FT.TableCheck = function(thetable, value)
	for _, v in pairs(thetable) do
		if v == value then
			return true
		end
	end
	return false
end

FT.FindClosestPlayer = function(position, teamstoignore)
    local lowest = math.huge -- infinity
	local NearestPlayer = nil
	
	for i,v in pairs(game.Players:GetPlayers()) do
		if v and v.Character then
			local hum = v.Character:FindFirstChildOfClass('Humanoid')
			if hum ~= nil and v.Name ~= game.Players.LocalPlayer.Name and hum.Health ~= 0 then
				if FT.TableCheck(teamstoignore, v.Team) == false then
					local distance = v:DistanceFromCharacter(position)
					if distance < lowest then
						lowest = distance
						NearestPlayer = v
					end
				end
			end
        end
    end
    return NearestPlayer, lowest
end

FT.Pathfind = function(startpos, endpos)
	local PathfindingService = game:GetService("PathfindingService")
	
	-- Create the path object
	local path = PathfindingService:CreatePath()
	
	-- Compute the path
	path:ComputeAsync(startpos, endpos)
	
	-- Get the path waypoints
	local waypoints = path:GetWaypoints()
	return path, waypoints
end

FT.GetPlayerInfo = function(name)
	local info = {}
	local player = game.Players:FindFirstChild(name)
	local islplayer = false
	local character = nil
	local humanoid = nil
	local rootpart = nil

	if player then 
		character = player.Character 
		if player.Name == game.Players.LocalPlayer.Name then 
			islplayer = true 
		end
	end

	if character then
		humanoid = character:FindFirstChildOfClass('Humanoid') 
		rootpart = character:FindFirstChild('HumanoidRootPart') 
	end 

	--table.insert(info, )

	info["IsInGame"] = player
	info["IsLocalPlayer"] = islplayer
	info["Character"] = character
	info["Humanoid"] = humanoid
	info["RootPart"] = rootpart

	return info
end

FT.ClearConsole = function()
	for i=1, 200 do print() end
end

FT.FindFirstDescendantOfClass = function(obj, classname)
	for _, stuff in pairs(obj:GetDescendants()) do
		if stuff:IsA(classname) then
			return stuff
		end
	end
end

FT.GetAsset = function(id)
	return game:GetService("MarketplaceService"):GetProductInfo(id)
end

FT.RandomValueFromTable = function(abc)
	return abc[math.random(1, table.getn(abc))]
end

FT.StringToTable = function(abc)
	local newList = {}
	for i=1, string.len(abc) do
		table.insert(newList, string.sub(abc, i, i))
	end
	return newList
end

FT.StringFind = function(str, x)
    local found = {}
    local lastStart, lastEnd = 0, 0

    repeat
        lastStart, lastEnd = string.find(str, x, lastEnd+1)
        if (lastStart and lastEnd) then table.insert(found, string.sub(str, lastStart, lastEnd)) end
    until not (lastStart or lastEnd)
    return found
end

FT.PlayersExceptLocalPlayer = function()
	local players = game.Players:GetPlayers()
	for i, p in pairs(players) do if p.Name == game.Players.LocalPlayer.Name then table.remove(players, i) end end
	return players
end

FT.WorldPointToViewPoint = function(vec)
	local camera = workspace.CurrentCamera
	local worldPoint = Vector3.new(0, 10, 0)
	local vector, onScreen = camera:WorldToScreenPoint(worldPoint)
 
	return Vector2.new(vector.X, vector.Y), onScreen
end

FT.GetCorners = function(part)
	local corners = {}
	for x=-1, 1, 2 do
		for y=-1, 1, 2 do
			for z=-1, 1, 2 do
				table.insert(corners, part.CFrame:pointToWorldSpace(Vector3.new(part.Size.X/2*x, part.Size.Y/2*y, part.Size.Z/2*z)))
			end
		end
	end
	return corners
end

local FUNCS = {
	["FT.ClosestPlayerToCursor"] = [[  
	ARGUMENTS: None.
	RETURNS: The player instance of the person closest to your reticle.
	]];

	["FT.TableCheck"] = [[  
	ARGUMENTS:
		[1] = Table you will be checking.
		[2] = Value you will be checking for.
	RETURNS: A boolean if the value was found in the table
	]];

	["FT.FindClosestPlayer"] = [[  
	ARGUMENTS:
		[1]: The position you want the find the closest player to.
		[2]: Table of team/s that you want to ignore.
	RETURNS: The player instance of the closest player to [1]z.
	]];

	["FT.Pathfind"] = [[  
	ARGUMENTS:
		[1] = The start position of the path.
		[2] = The end position of the path.
	RETURNS: The path and waypoints in this order.
	]];
	--EXAMPLE: Pathfind(Vector3.new(0,0,0), Vector3.new(1,1,1)) would return {path instance, table of waypoints}

	["FT.mult"] = [[  
	ARGUMENTS:
		[1] = The string you want to affect.
		[2] = The number that the string to be "multiplied by".
	RETURNS: The string following itself [2] time/s.]];

	["FT.GetPlayerInfo"] = [[  
	ARGUMENTS:
		[1] = Name of player.
	RETURNS: A table with values: {IsInGame, IsLocalPlayer, Character, Humanoid, RootPart}.
	]];

	["FT.ClearConsole"] = [[  
	ARGUMENTS: None.
	RETURNS: Nothing.
	]];

	["FT.FindFirstDescendantOfClass"] = [[
	ARGUMENTS:
		[1] = Object that you want to check the descendants of.
		[2] = Classname that you want to compare to the descendants.
	RETURNS: A descendant of [1] that's classname matched [2]
	]];

	["FT.GetAsset"] = [[
	ARGUMENTS:
		[1] = Audio id/any id
	RETURNS: The asset "instance" of the asset]];

	["FT.RandomValueFromTable"] = [[
		ARGUMENTS:
			[1] = Table that you want to get random value from.
		RETURNS: A random value from [1]
	]];

	["FT.StringToTable"] = [[
		ARGUMENTS:
			[1] = String that you want to make into a table.
		RETURNS: A table of each letter that was in [1].
	]]
	--To access these you would do GetPlayerInfo(name)['ValueName'] would return the value of that given"
}

FT.GetDocumentation = function(func)
	return FUNCS[fucn] or "No documentation found."
end

print('---------------------------------------------------------------------')
if PRINT_DOCUMENTATION then
	for k, v in pairs(FUNCS) do
		print('\n' .. k .. ': ' .. v .. '\n')
	end
end
_G.FT = FT
print('THE GLOBAL VARIABLE FOR THESE FUNCTIONS IS "_G.FT"')
print('Took a total of ' .. os.time()-start .. ' seconds to finish loading.')
print('---------------------------------------------------------------------')
--adding edit to check auto update script

