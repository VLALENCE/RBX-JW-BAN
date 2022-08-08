--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)

Dedicated by ScriptIntelligence to Alpha Authority, while using opensource technology by ShaneSloth

]]

--[[

-- Redacted -- Internal processing instructions for Robase authorization hidden. 

]]

--

script.Name = 'Blacklist / Whitelist Main Module'

-- 

warn(script.Name .. ' ~ Starting Blacklist / Whitelist Main Module')

--

local PlayerService = game:GetService('Players')
local GroupService = game:GetService('GroupService')
-- Redacted -- Internal processing service for Robase authorization hidden.  

--

-- Redacted -- Internal processing for Robase authorization hidden.  
local RobaseServiceModule = require(script.RobaseService) 
local RobaseService = RobaseServiceModule.new(--[[Redacted]]) -- Internal processing for Robase authorization hidden. 

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
	--if table.find(Blacklist.Players, Player.UserId) then return true end
	local Success, RobaseUserBlacklistUsers = RobaseUserBlacklist:GetAsync("users")
	for _,User in pairs(RobaseUserBlacklistUsers) do
		if User['userId'] == Player.UserId then return true end
	end
	--for _,Group in ipairs(Blacklist.Groups) do
	local Success, RobaseUserBlacklistGroups = RobaseUserBlacklist:GetAsync("groups")
	for _,Group in pairs(RobaseUserBlacklistGroups) do
		if Player:IsInGroup(Group['groupId']) then return true end
	end
end

local function checkWhitelist(Player)
	print(script.Name .. ' ~ Checking Whitelist for ' .. Player.Name)
	--if table.find(Whitelist.Players, Player.UserId) then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
	local Success, RobaseUserWhitelistUsers = RobaseUserWhitelist:GetAsync("users")
	for _,User in pairs(RobaseUserWhitelistUsers) do
		if User['userId'] == Player.UserId then print(script.Name .. ' ~ ' .. Player.Name .. ' is Whitelisted.') return true end
	end
	--for _,Group in ipairs(Whitelist.Groups) do
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
