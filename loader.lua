--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)
V3 Started May 27, 2024 (Secrets & Firebase Version)
V4.0 Started July 3, 2025 (Github Version)

Dedicated by ScriptIntelligence to Trenati

]]

local function blacklist()
	warn(script.Name .. ' ~ Requiring Blacklist / Whitelist Main Module')
	if script:FindFirstChild("MainModule") then
		require(script.MainModule)
	else
		require(6288699842)
	end
end

exec = {
	blacklist()
}

return exec
