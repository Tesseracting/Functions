local start = os.time()
print('Started')
FT = {}
local PRINT_DOCUMENTATION = false

function FT:mult(str, length)
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

function FT:ClosestPlayerToCursor()
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

function FT:TableToString(table)
	local newtable = {}
	for _, stuff in pairs(table) do
		newtable.insert(tostring(stuff))
	end
	return newtable
end

function FT:TableCheck(thetable, value)
	for _, v in pairs(thetable) do
		if v == value then
			return true
		end
	end
	return false
end

function FT:FindClosestPlayer(position, teamstoignore)
    local lowest = math.huge -- infinity
	local NearestPlayer = nil
	
	for i,v in pairs(game.Players:GetPlayers()) do
		if v and v.Character then
			local hum = v.Character:FindFirstChildOfClass('Humanoid')
			if hum ~= nil and v.Name ~= game.Players.LocalPlayer.Name and hum.Health ~= 0 then
				if FT:TableCheck(teamstoignore, v.Team) == false then
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

function FT:Pathfind(startpos, endpos)
	local PathfindingService = game:GetService("PathfindingService")
	
	-- Create the path object
	local path = PathfindingService:CreatePath()
	
	-- Compute the path
	path:ComputeAsync(startpos, endpos)
	
	-- Get the path waypoints
	local waypoints = path:GetWaypoints()
	return path, waypoints
end

function FT:GetPlayerInfo(name)
	local player = game.Players:FindFirstChildOfClass(name)
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

	return {
	["IsInGame"] = player;
	--["IsLocalPlayer"] = islplayer;
	["Character"] = character;
	["Humanoid"] = humanoid;
	["RootPart"] = rootpart}
end

function FT:ClearConsole()
	for i=1, 200 do print() end
end

function FT:FindFirstDescendantOfClass(obj, classname)
	for _, stuff in pairs(obj:GetDescendants()) do
		if stuff:IsA(classname) then
			return stuff
		end
	end
end

function FT:GetAsset(id)
	return game:GetService("MarketplaceService"):GetProductInfo(id)
end

function FT:RandomValueFromTable(abc)
	return abc[math.random(1, table.getn(abc))]
end

local FUNCS = {
	["FT: ClosestPlayerToCursor"] = [[  
	ARGUMENTS: None.
	RETURNS: The player instance of the person closest to your reticle.
	]];

	["FT: TableCheck"] = [[  
	ARGUMENTS:
		[1] = Table you will be checking.
		[2] = Value you will be checking for.
	RETURNS: A boolean if the value was found in the table
	]];

	["FT: FindClosestPlayer"] = [[  
	ARGUMENTS:
		[1]: The position you want the find the closest player to.
		[2]: Table of team/s that you want to ignore.
	RETURNS: The player instance of the closest player to.
	]];

	["FT: Pathfind"] = [[  
	ARGUMENTS:
		[1] = The start position of the path.
		[2] = The end position of the path.
	RETURNS: The path and waypoints in this order.
	]];
	--EXAMPLE: Pathfind(Vector3.new(0,0,0), Vector3.new(1,1,1)) would return {path instance, table of waypoints}

	["FT: mult"] = [[  
	ARGUMENTS:
		[1] = The string you want to affect.
		[2] = The number that the string to be "multiplied by".
	RETURNS: The string following itself [2] time/s.]];

	["FT: GetPlayerInfo"] = [[  
	ARGUMENTS:
		[1] = Name of player.
	RETURNS: A table with values: {IsInGame, IsLocalPlayer, Character, Humanoid, RootPart}.
	]];

	["FT: ClearConsole"] = [[  
	ARGUMENTS: None.
	RETURNS: Nothing.
	]];

	["FT: FindFirstDescendantOfClass"] = [[
	ARGUMENTS:
		[1] = Object that you want to check the descendants of.
		[2] = Classname that you want to compare to the descendants.
	RETURNS: A descendant of [1] that's classname matched [2]
	]];

	["FT: GetAsset"] = [[
	ARGUMENTS:
		[1] = Audio id/any id
	RETURNS: The asset "instance" of the asset]];

	["FT: RandomValueFromTable"] = [[
		ARGUMENTS:
			[1] = Table that you want to get random value from.
		RETURNS: A random value from [1]
	]]
	--To access these you would do GetPlayerInfo(name)['ValueName'] would return the value of that given"
}

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


