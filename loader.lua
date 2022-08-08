--[[

Created by ScriptIntelligence
Started January 2nd, 2021

Property of Alpha Authority

]]


local function blacklist()
	warn(script.Name .. ' ~ Requiring Blacklist / Whitelist Main Module')
	local blacklist = require(6288699842)
end

exec = {
	blacklist()
}

return exec
