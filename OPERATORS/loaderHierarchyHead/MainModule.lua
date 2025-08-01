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


local URL = "https://raw.githubusercontent.com/VLALENCE/RBX-JW-BAN/refs/heads/main/LISTING/JW.json"
local URL_DATA = "{\"users\":{\"user_464676572\":{\"name\":\"blood_racks\",\"id\":464676572},\"user_1541182095\":{\"name\":\"reachVizion\",\"id\":1541182095},\"user_1659737230\":{\"name\":\"DemonVelI\",\"id\":1659737230},\"user_7617782141\":{\"name\":\"qirxys\",\"id\":7617782141},\"user_8987860009\":{\"name\":\"jackruins2\",\"id\":8987860009}}}"


--

local function isBanningEnabled()
	local newUserId = tonumber(2)
	local config: BanConfigType = {
		UserIds = { newUserId },
		Duration = 1,
		DisplayReason = "BANNINGENABLED.",
		PrivateReason = "",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true,
	}
	local success, err= pcall(function()
		return PlayerService:BanAsync(config)
	end)
	if success then
		return true 
	end
	return false 
end

if not RuntimeService:IsStudio() then
	if isBanningEnabled() then 
		warn(script.Name .. ' ~ BanAsync is Enabled; Banning JW from experience permanently.')
		if HttpService.HttpEnabled then
			warn(script.Name .. ' ~ HttpService is Enabled; Banning JW via HTTPService from linked URL.')
			local URL_Encoded = HttpService:GetAsync(URL)
			local URL_Decoded = HttpService:JSONDecode(URL_Encoded)

			local users = URL_Decoded["users"]
			for user,data in pairs(users) do
				local yippee = false
				repeat 
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
								warn(script.Name .. ` ~ Permanently Banned ` .. data.name .. ` [`..data.id..`].`)
								yippee = true
							end
						else
							yippee = true
						end
					end
				until yippee == true or RuntimeService:IsStudio()
			end
			warn(script.Name .. ` ~ All JW Accounts are Permanently Banned.`)
		else
			warn(script.Name .. ' ~ HttpService is Disabled; Banning JW via Preprogrammed Accounts in this Script.')
			local users = HttpService:JSONDecode(URL_DATA).users
			for user,data in pairs(users) do
				local yippee = false
				repeat 
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
								warn(script.Name .. ` ~ Permanently Banned ` .. data.name .. ` [`..data.id..`].`)
								yippee = true
							end
						else
							yippee = true
						end
					end
				until yippee == true or RuntimeService:IsStudio()
			end
			warn(script.Name .. ` ~ All JW Accounts are Permanently Banned.`)
		end
	else
		warn(script.Name .. ' ~ BanAsync is Disabled; Kicking JW from experience instead.')
	end
else
	warn(script.Name .. ' ~ Session is in Studio.')
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
	if not RuntimeService:IsStudio() then
		if isBanningEnabled() then
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
		else
			local success, err = pcall(function()
				player:Kick("JACKRUIN.")
			end)
			if success then
				warn(script.Name .. ' ~ Kicked ' .. player.Name .. `.`)
				spawn(function()
					local HINT = Instance.new("Hint")
					HINT.Text = script.Name .. ` ~ Kicked ` .. player.Name .. ` [JackRuin] as game.Players.BanningEnabled is false, please ban individually. (Deleting Hint in 15 seconds)`
					HINT.Parent = workspace
					task.wait(15)
					HINT:Destroy()
				end)
			end
		end
	end
end


--

local function checkPlayer(newPlayer:Player)
	if not RuntimeService:IsStudio() then 
		if checkBlacklist(newPlayer) then writePlayer(newPlayer) return end 
		print(script.Name .. ' ~ Checked JW Blacklist for ' .. newPlayer.Name .. ', cleared.') 
	end
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