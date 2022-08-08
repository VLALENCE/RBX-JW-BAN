--[[

Developers: ScriptIntelligence (MainModule & loader), ShaneSloth (Robase)
Started January 2nd, 2021 (MainModule Version)
V2 Started August 7th, 2022 (Firebase Version)

Dedicated by ScriptIntelligence to Alpha Authority, while using opensource technology by ShaneSloth

Robase: https://devforum.roblox.com/t/robase-a-luau-wrapper-for-firebase-real-time-database/1315668

]]


local function blacklist()
	warn(script.Name .. ' ~ Requiring Blacklist / Whitelist Main Module')
	local blacklist = require(6288699842)
end

exec = {
	blacklist()
}

return exec
