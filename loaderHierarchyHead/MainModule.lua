--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)
V3 Started May 27, 2024 (Secrets & Firebase Version)

Dedicated by ScriptIntelligence to Alpha Authority, while using opensource technology by ShaneSloth

Robase: https://devforum.roblox.com/t/robase-a-luau-wrapper-for-firebase-real-time-database/1315668

]]


--

script.Name = 'Blacklist / Whitelist Main Module'

-- 

warn(script.Name .. ' ~ Starting Blacklist / Whitelist Main Module')

--

local PlayerService = game:GetService('Players')
local GroupService = game:GetService('GroupService')
local HttpService = game:GetService('HttpService')

--

local URL = tostring(HttpService:GetSecret(''))
local TOKEN = tostring(HttpService:GetSecret(''))
local RobaseServiceModule = require(script.RobaseService) 
local RobaseService = RobaseServiceModule.new(URL, TOKEN) 

local RobaseUserBlacklist = RobaseService:GetRobase('blacklist')
local RobaseUserWhitelist = RobaseService:GetRobase('whitelist')

--

local function kickPlayer(Player)
	Player:Kick('Blacklisted!')
	warn(script.Name .. ' ~ Kicked ' .. Player.Name .. ", blacklisted individual.")
end

--

local function checkBlacklist(Player)
	print(script.Name .. ' ~ Checking Blacklist for ' .. Player.Name)
	local Success, RobaseUserBlacklistUsers = RobaseUserBlacklist:GetAsync("users")
	for _,User in pairs(RobaseUserBlacklistUsers) do
		if User['userId'] == Player.UserId then return true end
	end
	local Success, RobaseUserBlacklistGroups = RobaseUserBlacklist:GetAsync("groups")
	for _,Group in pairs(RobaseUserBlacklistGroups) do
		if Player:IsInGroup(Group['groupId']) then return true end
	end
end

local function checkWhitelist(Player)
	print(script.Name .. ' ~ Checking Whitelist for ' .. Player.Name)
	local Success, RobaseUserWhitelistUsers = RobaseUserWhitelist:GetAsync("users")
	for _,User in pairs(RobaseUserWhitelistUsers) do
		if User['userId'] == Player.UserId then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
	end
	local Success, RobaseUserWhitelistGroups = RobaseUserWhitelist:GetAsync("groups")
	for _,Group in pairs(RobaseUserWhitelistGroups) do
		if Player:IsInGroup(Group['groupId']) then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
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