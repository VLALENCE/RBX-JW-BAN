--[[

Created by ScriptIntelligence
Started January 2nd, 2021

Property of Alpha Authority

]]

script.Name = 'Blacklist / Whitelist Main Module'

warn(script.Name .. ' ~ Starting Blacklist / Whitelist Main Module')

local PlayerService = game:GetService('Players')

local Blacklist = {}

Blacklist.Players = {
	18745095,
}

-- 18745095 - natsuflux

Blacklist.Groups = {
	3064711,
	9603500,
	7881372,
	2969248,
	4733250,
	4665428,
	5234523,
	4105128,
	5889407,
	2732679,
	5133149,
	4963120,
	58267,
	3261533,
	5340099
}

-- 3064711 - A-NEXO
-- 9603500 - Bloxxer Liberation Army
-- 7881372 - Cursed Awoken
-- 2969248 - Combat Assault Team 
-- 4733250 - Darkness Reborn :
-- 4665428 - Dark Valiant
-- 5234523 - Demon Sovereignty
-- 4105128 - 𝐄jército Mexicano
-- 5889407 - Fallen Veil
-- 2732679 - Federation of Arcadia
-- 5133149 - 2Hard | Alt Bloodline
-- 4963120 - Imp3ri4l Int3llig3nc3
-- 58267 - ROBLOX Bloxxers United
-- 3261533 - st0rmtr00p3rz
-- 5340099 - The Genesis Imperial

local Whitelist = {}

Whitelist.Players = {
	32098161,
	17147722,
}

-- 32098161 - Eze44

Whitelist.Groups = {
	6884402
}

-- 6884402 - Crimsοn Eyes

local function kickPlayer(Player)
	Player:Kick('Blacklisted!')
	error(script.Name .. ' ~ Kicked ' .. Player.Name .. ", blacklisted individual.")
end

--

local function checkBlacklist(Player)
	print(script.Name .. ' ~ Checking Blacklist for ' .. Player.Name)
	if table.find(Blacklist.Players, Player.UserId) then return true end
	for _,Group in ipairs(Blacklist.Groups) do
		if Player:IsInGroup(Group) then return true end
	end
	return false
end

local function checkWhitelist(Player)
	print(script.Name .. ' ~ Checking Whitelist for ' .. Player.Name)
	if table.find(Whitelist.Players, Player.UserId) then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
	for _,Group in ipairs(Whitelist.Groups) do
		if Player:IsInGroup(Group) then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
	end
end

--

local function checkPlayer(Player)
	if checkWhitelist(Player) == true then return end
	if checkBlacklist(Player) == true then kickPlayer(Player) return end
	print(script.Name .. ' ~ Checked Whitelist and Blacklist for ' .. Player.Name .. ', clear.')
end

--

local function intiliaze()
	PlayerService.PlayerAdded:Connect(function(Player)
		checkPlayer(Player)	
	end)
	for index,player in ipairs(PlayerService:GetPlayers()) do
		checkPlayer(player)
	end	
end

--

local module = {
	intiliaze()
}

return module
