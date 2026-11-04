--name of the plugin
local targetName = "VST3: Blue Cat's Gain 3 (Stereo) (Blue Cat Audio)"

--which instance? eg: 1 is 1st found, 2 is 2nd found etc. and -1 is last found
local targetIndex = -1

--location in list. set to high number to move it to the end or -1 to leave it alone
local targetPosition = 15

--add the plugin if it does not already exist
local targetAddedIfNotFound = true

--close all other floating windows before opening plugin
local targetSingleFloatingWindow = true

------------------------------------------------------------
-- do the things
------------------------------------------------------------
function ControlMappedPluginOnTrack(targetName, targetIndex, targetPosition, targetAddedIfNotFound, targetSingleFloatingWindow)

	--make sure there are tracks to work with
	local totalTracks = reaper.GetNumTracks()
	if (totalTracks < 1) then return end

	--there should only be 1 selected track
	local selectedTracks = reaper.CountSelectedTracks(0)
	if (selectedTracks ~= 1) then return end

	--try to get the selected track
	local track = reaper.GetSelectedTrack(0, 0)
	if (track == nil) then return end

	local trackFxCount = reaper.TrackFX_GetCount(track)
	local pluginFound = false
	local pluginId = -1
	
	--there must be some fx
	if (trackFxCount > 0) then
		--check all FX in the list
		pluginFound, pluginId = FindPlugin(targetName, track, trackFxCount, targetIndex)
		
		if (pluginFound) then
			--check if plugin is already open in floating window
			local HWND = reaper.TrackFX_GetFloatingWindow(track, pluginId)
			if (HWND ~= nil) then
				--it's open, so close it and send track mode flag to resume mixing
				reaper.TrackFX_Show(track, pluginId, 2)
				reaper.ReaSonus_FP8_SetFaderModeTrack()
			else
				--close all existing floating windows
				if (targetSingleFloatingWindow) then
					for i = 0, trackFxCount-1 do
						reaper.TrackFX_Show(track, i, 2)
					end
				end
				
				if (targetPosition > -1) then
					--fx needs to be moved to requested position
					reaper.TrackFX_CopyToTrack(track, pluginId, track, targetPosition, true)
					--confirm the index
					pluginFound, pluginId = FindPlugin(targetName, track, trackFxCount, targetIndex)
					reaper.ReaSonus_FP8_ControlPlugin(track, pluginId)
				else
					--fx will not be moved
					reaper.ReaSonus_FP8_ControlPlugin(track, pluginId)
				end
			end
		elseif (targetAddedIfNotFound) then
			--add the plugin
			reaper.TrackFX_AddByName(track, targetName, false, -1)
			reaper.ReaSonus_FP8_ControlPlugin(track, trackFxCount)
		end
	elseif (targetAddedIfNotFound) then
		--there are no fx, add the plugin if user requested
		reaper.TrackFX_AddByName(track, targetName, false, -1)
		reaper.ReaSonus_FP8_ControlPlugin(track, 0)
	end
end

function FindPlugin(targetName, track, trackFxCount, targetIndex)

	local pluginFound = false
	local pluginId = -1
	local currentIndex = 0
	
	--check all fx for the plugin name
	for i = 0, trackFxCount-1 do
		--keep checking until the plugin is found
		if (pluginFound == false) then
			--get current fx name and compare with target plugin name
			retval, fxName = reaper.TrackFX_GetFXName(track, i)          

			if (fxName == targetName) then
				currentIndex = currentIndex + 1
				if (currentIndex == targetIndex) then
					--instance found
					pluginFound = true
					pluginId = i
				elseif (targetIndex == -1) then
					--keep searching for other instances
					pluginId = i
				end
			end
		end
	end
	
	if (targetIndex == -1 and pluginId > -1) then
		pluginFound = true
	end
	
	return pluginFound, pluginId
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
	ControlMappedPluginOnTrack(targetName, targetIndex, targetPosition, targetAddedIfNotFound, targetSingleFloatingWindow)
end

if (versionCheck()) then ScriptExecute() end
