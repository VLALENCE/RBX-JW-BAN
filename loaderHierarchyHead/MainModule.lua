--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)
V3 Started May 27, 2024 (Secrets & Firebase Version)
V4.0 Started July 3, 2025 (Github Version)

Dedicated by ScriptIntelligence to Trenati

]]


--

script.Name = 'Blacklist / Whitelist Main Module'


-- 

warn(script.Name .. ' ~ Starting Blacklist / Whitelist Main Module')


--

local RuntimeService = game:GetService("RunService")
local PlayerService = game:GetService('Players')
local GroupService = game:GetService('GroupService')
local HttpService = game:GetService('HttpService')


--

local URL = "https://raw.githubusercontent.com/TRENATTI/WRITTEN/refs/heads/main/LISTING/index.json"
local URL_Encoded = HttpService:GetAsync(URL)
local URL_Decoded = HttpService:JSONDecode(URL_Encoded)

local users = URL_Decoded["users"]
for user,data in pairs(users) do
	local datatable = data.associatedAccounts.robloxAccounts:split(", ")
	for index,userId in pairs(datatable) do
		print(userId)
		local yippee = false
		repeat 
			local history:BanHistoryPages = nil
			local success, err = pcall(function()
				history = PlayerService:GetBanHistoryAsync(userId)
			end)
			print(success, err)			
			if success then

				print(#history:GetCurrentPage())
				if #history:GetCurrentPage() < 1 then
					local newUserId = tonumber(userId)
					print(newUserId)
					local config: BanConfigType = {
						UserIds = { newUserId },
						Duration = -1,
						DisplayReason = "WRITEN.",
						PrivateReason = "",
						ExcludeAltAccounts = false,
						ApplyToUniverse = true,
					}
					local success2, err2 = pcall(function()
						return PlayerService:BanAsync(config)
					end)
					print(success2, err2)
					if success2 then
						warn(script.Name .. ' ~ Permanently Banned ' .. data.latestUsername ..`[`..userId..`]`)
						yippee = true
					end
				else
					yippee = true
				end
			end
		until yippee == true or RuntimeService:IsStudio()
	end
end


--

local function checkPermanentBlacklist(player:Player)
	local users = URL_Decoded["users"]
	for user,data in pairs(users) do
		if string.find(data.associatedAccounts.robloxAccounts, tostring(player.UserId)) then
			return true
		end
	end
	return false
end

local function writePlayer(player:Player)
	local config: BanConfigType = {
		UserIds = { player.UserId },
		Duration = -1,
		DisplayReason = "WRITEN.",
		PrivateReason = "",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true,
	}
	local success, err = pcall(function()
		return PlayerService:BanAsync(config)
	end)
	print(success, err)
	warn(script.Name .. ' ~ Permanently Banned ' .. player.Name)
end

local function checkGroupBlacklist(player:Player)
	local groups = URL_Decoded["groups"]
	for group,data in pairs(groups) do
		if player:IsInGroup(data.groupId) then
			return true
		end
	end
	return false
end

local function getGroupsBlacklisted(player:Player)
	local groups = URL_Decoded["groups"]
	group_table = ""
	for group,data in pairs(groups) do
		if player:IsInGroup(data.groupId) then
			group_table += data.groupId..", "
		end
	end
	return group_table
end

local function kickPlayer(player:Player, groups)
	player:Kick('In Blacklisted Groups! ['..groups..']')
	warn(script.Name .. ' ~ Kicked ' .. player.Name .. ", blacklisted groups. ["..groups']')
end


--

local function checkPlayer(newPlayer:Player)
	if checkPermanentBlacklist(newPlayer) then writePlayer(newPlayer) return end
	if checkGroupBlacklist(newPlayer) then 
		local groups = getGroupsBlacklisted(newPlayer)
		kickPlayer(newPlayer, groups) 
		return 
	end
	print(script.Name .. ' ~ Checked Permanent Blacklist and Group Blacklist for ' .. newPlayer.Name .. ', cleared.')
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