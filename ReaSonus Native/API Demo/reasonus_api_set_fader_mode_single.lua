------------------------------------------------------------
-- do the things
------------------------------------------------------------
function SetFaderModeSingle()
	--make sure there are tracks to work with
	local totalTracks = reaper.GetNumTracks()
	if (totalTracks < 1) then
		reaper.ShowMessageBox("Could not find any tracks!\n\nAdd at least 1 track and try again!", "Error", 0)
		return
	end

	--there should only be 1 selected track
	local selectedTracks = reaper.CountSelectedTracks(0)
	if (selectedTracks ~= 1) then
		reaper.ShowMessageBox("No track was selected!\n\nSelect 1 track and try again!", "Error", 0)
		return
	end

	--try to get the selected track
	local track = reaper.GetSelectedTrack(0, 0)
	if (track == nil) then
		reaper.ShowMessageBox("Unable to get selected track!", "Error", 0)
		return
	end

	--present menu to user
	local menuItems = "#ReaSonus_FP8_SetFaderMode||Track Mode||Plugin Mode (HUI)|Plugin Mode (Track)||Send Mode (HUI)|Send Mode (Track)||Receive Mode (HUI)|Receive Mode (Track)||Pan Mode 1|Pan Mode 2"
	local menuChoice = gfx.showmenu(menuItems)
	menuChoice = math.floor(tonumber(menuChoice - 2))

	--select mode
	if (menuChoice > -1) then
		reaper.ReaSonus_FP8_SetFaderMode(menuChoice, track)
	end
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
	SetFaderModeSingle()
end

if (versionCheck()) then ScriptExecute() end
