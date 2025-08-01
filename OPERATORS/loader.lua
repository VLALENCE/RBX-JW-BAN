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

local function blacklist()
	warn(script.Name .. ' ~ Requiring JW Blacklist Main Module')
	if script:FindFirstChild("MainModule") then
		require(script.MainModule)
	end
end

exec = {
	blacklist()
}

return exec
