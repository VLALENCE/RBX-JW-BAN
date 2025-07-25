--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)
V3 Started May 27, 2024 (Secrets & Firebase Version)
V4.0 Started July 3, 2025 (Github Version)
V4.0.JW Started July 25, 2025 (JW Github Version)

Dedicated by ScriptIntelligence to the public

]]


--

script.Name = 'JW Blacklist Main Module'


-- 

warn(script.Name .. ' ~ Starting JW Blacklist Main Module')


--

local RuntimeService = game:GetService("RunService")
local PlayerService = game:GetService('Players')
local GroupService = game:GetService('GroupService')
local HttpService = game:GetService('HttpService')


local URL = "https://raw.githubusercontent.com/TRENATTI/WRITTEN/refs/heads/main/LISTING/index.json"
local URL_DATA = "{\"users\":{\"user_464676572\":{\"name\":\"blood_racks\",\"id\":464676572},\"user_1541182095\":{\"name\":\"reachVizion\",\"id\":1541182095},\"user_1659737230\":{\"name\":\"DemonVelI\",\"id\":1659737230},\"user_7617782141\":{\"name\":\"qirxys\",\"id\":7617782141},\"user_8987860009\":{\"name\":\"jackruins2\",\"id\":8987860009}}}"


--

if HttpService.HttpEnabled then
	local URL_Encoded = HttpService:GetAsync(URL)
	local URL_Decoded = HttpService:JSONDecode(URL_Encoded)

	local users = URL_Decoded["users"]
	for user,data in pairs(users) do
		local yippee = false
		repeat 
			local history:BanHistoryPages = nil
			local success, err = pcall(function()
				history = PlayerService:GetBanHistoryAsync(data.id)
			end)	
			if success then
				if #history:GetCurrentPage() < 1 then
					local newUserId = tonumber(data.id)
					local config: BanConfigType = {
						UserIds = { newUserId },
						Duration = -1,
						DisplayReason = "JACKRUIN.",
						PrivateReason = "",
						ExcludeAltAccounts = false,
						ApplyToUniverse = true,
					}
					local success2, err2 = pcall(function()
						return PlayerService:BanAsync(config)
					end)
					if success2 then
						warn(script.Name .. ` ~ Permanently Banned [`..data.id..`]`)
						yippee = true
					end
				else
					yippee = true
				end
			end
		until yippee == true or RuntimeService:IsStudio()
	end
else
	local users = HttpService:JSONDecode(URL_DATA).users
	for user,data in pairs(users) do
		local yippee = false
		repeat 

			print(user, data, data.id)
			local history:BanHistoryPages = nil
			local success, err = pcall(function()
				history = PlayerService:GetBanHistoryAsync(tonumber(data.id))
			end)	
			if success then
				if #history:GetCurrentPage() < 1 then
					local newUserId = tonumber(data.id)
					local config: BanConfigType = {
						UserIds = { newUserId },
						Duration = -1,
						DisplayReason = "JACKRUIN.",
						PrivateReason = "",
						ExcludeAltAccounts = false,
						ApplyToUniverse = true,
					}
					local success2, err2 = pcall(function()
						return PlayerService:BanAsync(config)
					end)
					if success2 then
						warn(script.Name .. ` ~ Permanently Banned [`..data.id..`]`)
						yippee = true
					end
					if err2 then
						print(err2)
					end
				else
					yippee = true
				end
			end
			if err then 
				print(err)
			end
		until yippee == true or RuntimeService:IsStudio()
	end
end


--

local function checkBlacklist(player:Player)
	if HttpService.HttpEnabled then
		local URL_Encoded = HttpService:GetAsync(URL)
		local URL_Decoded = HttpService:JSONDecode(URL_Encoded)

		local users = URL_Decoded["users"]
		for user,data in pairs(users) do
			if string.find(tostring(data.id), tostring(player.UserId)) then
				return true
			end
		end
		return false
	else
		local users = HttpService:JSONDecode(URL_DATA).users
		for user,data in pairs(users) do
			if string.find(tostring(data.id), tostring(player.UserId)) then
				return true
			end
		end
		return false
	end
end

local function writePlayer(player:Player)
	local config: BanConfigType = {
		UserIds = { player.UserId },
		Duration = -1,
		DisplayReason = "JACKRUIN.",
		PrivateReason = "",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true,
	}
	local success, err = pcall(function()
		return PlayerService:BanAsync(config)
	end)
	if success then
		warn(script.Name .. ' ~ Permanently Banned ' .. player.Name)
	end
end


--

local function checkPlayer(newPlayer:Player)
	if checkBlacklist(newPlayer) then writePlayer(newPlayer) return end
	print(script.Name .. ' ~ Checked JW Blacklist for ' .. newPlayer.Name .. ', cleared.')
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