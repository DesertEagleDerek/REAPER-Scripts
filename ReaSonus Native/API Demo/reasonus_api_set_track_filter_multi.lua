------------------------------------------------------------
-- do the things
------------------------------------------------------------
function SetTrackFilterMulti()

	--present menu to user
	local menuItems = "#ReaSonus_FP8_SetTrackFilter||All [B5:All]|Sends [B1:Audio][Left]|Receives [B1:Audio][Right]|Hardware Out [B3:Bus][Left]|Instrument [B2:VI]|Effects [B4:VCA][Left]|Top Folders [B3:Bus]|All Folders [B3:Bus][Right]|With MIDI [B2:VI][Left]|With Audio [B1:Audio]|VCA [B4:VCA]"
	local menuChoice = gfx.showmenu(menuItems)
	menuChoice = math.floor(tonumber(menuChoice - 2))

	--select mode
	if (menuChoice == 0) then
		reaper.ReaSonus_FP8_SetTrackFilterAll()
	elseif (menuChoice == 1) then
		reaper.ReaSonus_FP8_SetTrackFilterSends()
	elseif (menuChoice == 2) then
		reaper.ReaSonus_FP8_SetTrackFilterReceives()
	elseif (menuChoice == 3) then
		reaper.ReaSonus_FP8_SetTrackFilterHwOutputs()
	elseif (menuChoice == 4) then
		reaper.ReaSonus_FP8_SetTrackFilterInstruments()
	elseif (menuChoice == 5) then
		reaper.ReaSonus_FP8_SetTrackFilterEffects()
	elseif (menuChoice == 6) then
		reaper.ReaSonus_FP8_SetTrackFilterTopFolders()
	elseif (menuChoice == 7) then
		reaper.ReaSonus_FP8_SetTrackFilterAllFolders()
	elseif (menuChoice == 8) then
		reaper.ReaSonus_FP8_SetTrackFilterWithMidi()
	elseif (menuChoice == 9) then
		reaper.ReaSonus_FP8_SetTrackFilterWithAudio()
	elseif (menuChoice == 10) then
		reaper.ReaSonus_FP8_SetTrackFilterVca()
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
	SetTrackFilterMulti()
end

if (versionCheck()) then ScriptExecute() end
