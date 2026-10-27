------------------------------------------------------------
-- do the things
------------------------------------------------------------
function GetTrackOffset()
	local trackOffset = reaper.ReaSonus_FP8_GetTrackOffset()
	reaper.ShowMessageBox("Track offset: " .. trackOffset, "ReaSonus_FP8_GetTrackOffset", 0)
end

------------------------------------------------------------
-- prepare the things
------------------------------------------------------------
function Console(content) reaper.ShowConsoleMsg(content .. string.char(10)) end

function split(s, sep)
    local fields = {}
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function versionCheck()
	local apiExists = reaper.APIExists("ReaSonus_GetVersion")
	if (apiExists) then
		local versionExpectedString = "0.12.0"
		local versionExpected =  split(versionExpectedString, ".")
		local versionString = reaper.ReaSonus_GetVersion()
		local version = split(versionString, "-")
		version = split(version[1], ".")
		local versionAccepted = true

		if (tonumber(version[1]) < tonumber(versionExpected[1])) then versionAccepted = false end
		if (tonumber(version[2]) < tonumber(versionExpected[2])) then versionAccepted = false end
		if (tonumber(version[3]) < tonumber(versionExpected[3])) then versionAccepted = false end

		if (versionAccepted) then
			return true
		else
			reaper.ShowMessageBox("The currently installed version of ReaSonus Native does not support all of the API functions used in this script.\n\nInstalled version: " .. versionString .. "\n\nExpected version: " .. versionExpectedString, "Error", 0)
			return false
		end
	else
		reaper.ShowMessageBox("ReaSonus Native API was not found!\n\nCheck that ReaSonus Native is correctly installed then try again.", "Error", 0)
		return false
	end
end

function ScriptExecute()
	GetTrackOffset()
end

if (versionCheck()) then ScriptExecute() end
