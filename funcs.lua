FT = getgenv() or {}

local alreadyloaded = FT.FunctionsLoaded or false
local PRINT_DOCUMENTATION = false
local readfile = readfile or function() print("Sorry you aren't using an exploit hahah") end

if not alreadyloaded then
	print('---------------------------------------------------------------------')
	print('Started')
end

local start = os.time()

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

FT.TableToString = function(giventable, separator, recursive)
	recursive = recursive or true
	separator = separator or ''

	if not recursive then
		local string = "" -- WORK ON THIS SHITS PLS
		return
	end
	local newtable = {}
	for i, v in pairs(giventable) do
		if type(i) == "table" then
			TableToString(i, separator)
		elseif type(v) == "table" then
			TableToString(v, separator)
		else
			print("I added something " .. tostring(i) .. separator .. tostring(v))
			table.insert(newtable, tostring(i) .. separator .. tostring(v))
		end
	end
	return unpack(newtable)
end

FT.TableCheck = function(thetable, value)
	for iter, v in pairs(thetable) do
		if v == value or iter == value then
			return true, {iter, value}
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
	local player;

	if type(name) == "string" then
		player = game.Players:FindFirstChild(name)
	elseif type(name) == "userdata" then
		player = name
	end

	FT.GetExploit = function()
		local exploit;
		if syn then
			exploit = "syn"
		elseif readfileas then
			exploit = "calamari"
		end
		return exploit
	end

	local character = player.Character

	info = {
		IsInGame = not player or true;
		IsLocalPlayer = player == game.Players.LocalPlayer;
		Character = character;
		Humanoid = character:FindFirstChildOfClass('Humanoid');
		RootPart = character:FindFirstChild('HumanoidRootPart');
		OperatingSys = player.OsPlatform;
		UserId = player.UserId;
		Team = player.Team
	}

	return info
end

FT.ClearConsole = function()
	for i=1, 200 do print() end
end

FT.FindFirstDescendantOfClass = function(obj, classname, name)
	for _, stuff in pairs(obj:GetDescendants()) do
		if stuff:IsA(classname) or stuff.Name == name then
			return stuff
		end
	end
end

FT.ChildrenOfChildren = function(obj, name)
	for _, a in pairs(obj:GetChildren()) do
		local test = a:FindFirstChild(name)
		if test then return test end
	end
end

FT.FindChildren = function(obj, classname, name)
	local newTable = {}
	for _, a in pairs(obj:GetChildren()) do
		local test1, test2 = true, true

		if classname then
			if obj.ClassName ~= classname then
				test1 = false
			end
		end

		if name then
			if obj.Name ~= name then
				test2 = false
			end
		end

		print(tostring(test1) .. " | " .. tostring(test2))

		if test1 and test2 then
			table.insert(newTable, obj)
		end
	end
	return newTable
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

FT.MergeTables = function(tbl1, tbl2)
	for k, v in pairs(tbl2) do
		tbl[k] = v
	end
	return tbl1
end

FT.PlayersExceptLocalPlayer = function(returnlocal, returnchar)
	local players = {}

	for _, p in pairs(game.Players:GetPlayers()) do
		if (returnlocal and p == game.Players.LocalPlayer) then
			if returnchar then
				if p.Character then
					table.insert(players, p.Character)
				end
			else
				table.insert(players, p)
			end
		elseif returnchar then
			table.insert(players, p.Character)
		elseif p.Name ~= game.Players.LocalPlayer.Name then
			table.insert(players, p)
		end
	end

	return players
end

FT.WorldPointToViewPoint = function(vec)
	local camera = workspace.CurrentCamera
	local vector, onScreen = camera:WorldToScreenPoint(vec)

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

FT.GetArea = function(part)
	return part.Size.X * part.Size.Y * part.Size.Z
end

FT.Triangulate = function(vectors)
	local a = nil

	for _, vec in pairs(vectors) do
		if a then
			a = a + vec
		else
			a = vec
		end
	end
	return a/table.getn(vectors)
end

FT.betterreadfile = function(filename)
	local file = assert(readfile, "Your exploit doesn't support readfile.")
	local contents;
	local success, errormessage = pcall(function() contents = readfile(filename) end)
	if success then return contents else return nil end
end

FT.import = function(name)
	local file = betterreadfile(name)
	if file then loadstring(file)() return getgenv()[name] end
end

FT.CopyTable = function(tbl)
	local newTable = {}
	for k, v in pairs(tbl) do
		newTable[k] = v
	end
	return newTable
end

FT.range = function(start, stop, step)
	step = step or 1
	local newTable = {}
	for i=start, stop, step do
		table.insert(newTable, i)
	end
	return newTable
end

FT.Test123 = function(value1, value2, value3, value4)
	if value1 == value2 then return value3 else return value4 end
end

FT.tablefunc = function(tbl, func, otherargs)
	for _, a in pairs(tbl) do
		func(a, otherargs)
	end
end

local FRT = {}

FT.FunctionReturnChange = function(tag, functiontocheck, functiontocall, val)
	table.insert(FRT, {
		Tag = tag;
		Value = val or Test123(not FRT[tag], nil, true, not FRT[tag]);
		FunctionCheck = functiontocheck;
		FunctionCall = functiontocall
	})
end

game:GetService("RunService").Heartbeat:Connect(function()
	for _, a in pairs(FRT) do

	end
end)

FT.RedwoodApi = function()
	local resources = game:GetService("Workspace").resources
	local event = resources.RemoteEvent
	local func = resources.RemoteFunction
	local a = {}

	a.updateMOTD = function(text)
		event:FireServer("updateMOTD", text)
		func:InvokeServer("attemptChangeMOTD")
	end

	a.cuff = function(player)
		if type(player) == "table" then
			for _, p in pairs(player) do event:FireServer("cuff", p) wait(0.1) end
		else
			event:FireServer("cuff", player)
		end
	end

	a.damage = function(player, dmg)
		if type(player) == "table" then
			for _, p in pairs(player) do
				local humanoid = p
				if p.ClassName == "Player" then
					local char = p.Character
					if char then
						humanoid = char:FindFirstChildOfClass("Humanoid")
					end
				elseif p.ClassName == "Model" then
					humanoid = p:FindFirstChildOfClass("Humanoid")
				end
				if humanoid then
					event:FireServer("dealDamage", humanoid, dmg)
				end
				wait(0.1)
			end
		else
			event:FireServer("dealDamage", player, dmg)
		end
	end

	a.teamchange = function(team)
		local oh2 = nil
		if type(team) == "userdata" then oh2 = team.Name elseif type(team) == "string" then oh2 = team end
		oh2 = string.lower(oh2)
		func:InvokeServer("requestTeam", string.lower(oh2))
	end

	a.updatedoor = function(door)
		if type(door) == "table" then
			for _, test in pairs(door) do event:FireServer("updateDoorSystem", test) end
		else
			event:FireServer("updateDoorSystem", door)
		end
	end

	return a
end

FT.PrisonLifeApi = function()

	local a = {}

	a.melee = function(player)
		game:GetService("ReplicatedStorage").meleeEvent:FireServer(player)
	end

	a.teamchange = function(team) -- team or brickcolor of team
		if team.Name == "Neutral" then
			warn("You would've been kicked. You can't teamchange to that team.")
		else
			game:GetService("Workspace").Remote.TeamEvent:FireServer(team.TeamColor)
		end
	end

	a.arrest = function(playerpart)
		game:GetService("Workspace").Remote.arrest:FireServer(playerpart)
	end

	return a
end

FT.GodSimulatorApi = function()
	local a = {}
	local event = game:GetService("ReplicatedStorage")["🔥"]
	local func = game:GetService("ReplicatedStorage")["👌"]

	a.UseAbility = function(godname, ability, cframe)
		event:FireServer("UseAbility", godname, ability, cframe)
	end

	a.Teleport = function(placename)
		event:FireServer("PDS", "Teleport", placename)
	end

	a.Activations = function(name)
		func:InvokeServer("PDS", "Activations", name)
	end

	return a
end

FT.DarkRpApi = function()
	local a = {}
	local events = game:GetService("ReplicatedStorage").Events

	--[[
		Message's third argument ranges from 1-6
		1 - Unknown
		2 - Unknown
		3 - Unknown
		4 - Error
		5 - Warning
		6 - Success
	--]]

	a.Message = function(title, message, typeofmsg)
		typeofmsg = typeofmsg or 5
		events.Note:Fire(title, message, typeofmsg)
	end

	a.JobChange = function(job)
		events.MenuEvent:FireServer(1, job)
	end

	a.HideWeapons = function(name, isback)
		events.WeaponBackEvent:FireServer(name, isback)
	end

	a.Pickup = function(obj, pickup)
		events.PickUpEvent:FireServer(obj, pickup)
	end

	return a
end

local FUNCS = {
	["ClosestPlayerToCursor"] = [[
	ARGUMENTS: None.
	RETURNS: The player instance of the person closest to your reticle.
	]];

	["TableCheck"] = [[
	ARGUMENTS:
		[1] = Table you will be checking.
		[2] = Value you will be checking for.
	RETURNS: A boolean if the value was found in the table
	]];

	["FindClosestPlayer"] = [[
	ARGUMENTS:
		[1]: The position you want the find the closest player to.
		[2]: Table of team/s that you want to ignore.
	RETURNS: The player instance of the closest player to [1]z.
	]];

	["Pathfind"] = [[
	ARGUMENTS:
		[1] = The start position of the path.
		[2] = The end position of the path.
	RETURNS: The path and waypoints in this order.
	]];

	["GetPlayerInfo"] = [[
	ARGUMENTS:
		[1] = Name of player.
	RETURNS: A table with lots of information within.
	]];

	["ClearConsole"] = [[
		ARGUMENTS: None.
		RETURNS: Nothing.
	]];

	["FindFirstDescendantOfClass"] = [[
		ARGUMENTS:
			[1] = Object that you want to check the descendants of.
			[2] = Classname that you want to compare to the descendants.
		RETURNS: A descendant of [1] that's classname matched [2]
	]];

	["GetAsset"] = [[
		ARGUMENTS:
			[1] = Audio id/any id
		RETURNS: The asset "instance" of the asset]];

	["RandomValueFromTable"] = [[
		ARGUMENTS:
			[1] = Table that you want to get random value from.
		RETURNS: A random value from [1]
	]];

	["StringToTable"] = [[
		ARGUMENTS:
			[1] = String that you want to make into a table.
		RETURNS: A table of each letter that was in [1].
	]];
	--To access these you would do GetPlayerInfo(name)['ValueName'] would return the value of that given"

	["StringFind"] = [[
		ARGUMENTS:
			[1] = A string you are going to be checking
			[2] = The part of the string you want to get the positions of
		RETURNS: A table of all the positions of [2] found in [1]
	]];

	["PlayersExceptLocalPlayer"] = [[
		ARGUMENTS: NONE
		RETURNS: A list of all players except the local player
	]];

	["WorldPointToViewPoint"] = [[
		ARGUMENTS:
			[1] = A vector3
		RETURNS: A vector2 of where [1] would be on the screen
	]];

	["GetCorners"] = [[
		ARGUMENTS:
			[1] = An object you want to get the corners of
		RETURNS: A table of all the corners of [1]
	]];

	["GetArea"] = [[
		ARGUMENTS:
			[1] = An object
		RETURNS: A Vector3 of the part's size
	]];

	["Triangulate"] = [[
		ARGUMENTS:
			[1] = A table of Vector3's
		RETURNS: The exact middle point of [1]
	]];

	["betterreadfile"] = [[
		ARGUMENTS:
			[1] = filename
		RETURNS: The contents of the file [1]
	]];

	["import"] = [[
		ARGUMENTS:
			[1] = The name of a module
		RETURNS: A table of the modules functions
	]];

	["CopyTable"] = [[
		ARGUMENTS:
			[1] = A table
		RETURNS: A copy of the table
	]];

	["range"] = [[
		ARGUMENTS:
			[1] = The start number
			[2] = The end number
			[3] = The step number
		RETURNS: A list of all the numbers from [1] to [2] iterating up by [3]
	]];

}

FT.GetDocumentation = function(func)
	return FUNCS[func] or FUNCS["FT." .. func] or "No documentation found."
end

local msg1 = "So your exploit supports getgenv() so you only need to call the functions name like GetAsset(id)"

if not getgenv() then
	msg1 = "Your exploit doesn't support getgenv() so you need to call _G.FT to get the table of all the functions."
	_G.FT = FT
end

if PRINT_DOCUMENTATION and not alreadyloaded then
	for k, v in pairs(FUNCS) do
		print('\n' .. k .. ': ' .. v .. '\n')
	end
end

if not alreadyloaded then
	print(msg1)
	print('Took a total of ' .. os.time()-start .. ' seconds to finish loading.')
	print('---------------------------------------------------------------------')
else
	print("The functions were already loadded, but I decided to be nice and load them in again incase there was an error :)")
end

FT.FunctionsLoaded = true
