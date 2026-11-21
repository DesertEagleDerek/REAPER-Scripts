------------------------------------------------------------
-- do the things
------------------------------------------------------------
function TransportSeek()
	reaper.ClearConsole()
	MainLoop()
end

local phase = 0
local phase_time = 1
local finished = false
local time_start = reaper.time_precise()
local time_since_last_check_transport_seek = reaper.time_precise() - 1

function NextPhase()
	phase = phase + 1
end

function MainLoop()

	--update timers
	local main_loop_elapsed = reaper.time_precise() - time_start
	local transport_seek_loop_elapsed = reaper.time_precise() - time_since_last_check_transport_seek
	
	--repeat this action every 1s
	if (transport_seek_loop_elapsed >= phase_time) then
		time_since_last_check_transport_seek = reaper.time_precise()

		if (phase == 0) then
			Console("Script -> Begin")
			reaper.ReaSonus_SetTransportSeekForward()
			Console("ReaSonus_SetTransportSeekForward")
			reaper.ReaSonus_SetTransportSeekSpeed(1)
			Console("ReaSonus_SetTransportSeekSpeed(1)")
			
		elseif (phase == 1) then
			reaper.ReaSonus_SetTransportSeekSpeed(10)
			Console("ReaSonus_SetTransportSeekSpeed(10)")
			
		elseif (phase == 2) then
			reaper.ReaSonus_SetTransportSeekSpeed(1)
			Console("ReaSonus_SetTransportSeekSpeed(1)")
			
		elseif (phase == 3) then
			reaper.ReaSonus_SetTransportSeekSpeed(10)
			Console("ReaSonus_SetTransportSeekSpeed(10)")
			
		elseif (phase == 4) then
			reaper.ReaSonus_SetTransportSeekSpeed(1)
			Console("ReaSonus_SetTransportSeekSpeed(1)")
			
		elseif (phase == 5) then
			reaper.ReaSonus_IncrementTransportSeekSpeed()
			Console("ReaSonus_IncrementTransportSeekSpeed")
			phase_time = 0.5
			
		elseif (phase == 6) then
			reaper.ReaSonus_IncrementTransportSeekSpeed()
			Console("ReaSonus_IncrementTransportSeekSpeed")
			
		elseif (phase == 7) then
			reaper.ReaSonus_IncrementTransportSeekSpeed()
			Console("ReaSonus_IncrementTransportSeekSpeed")
			
		elseif (phase == 8) then
			reaper.ReaSonus_IncrementTransportSeekSpeed()
			Console("ReaSonus_IncrementTransportSeekSpeed")
			
		elseif (phase == 9) then
			reaper.ReaSonus_DecrementTransportSeekSpeed()
			Console("ReaSonus_DecrementTransportSeekSpeed")
			
		elseif (phase == 10) then
			reaper.ReaSonus_DecrementTransportSeekSpeed()
			Console("ReaSonus_DecrementTransportSeekSpeed")
			
		elseif (phase == 11) then
			reaper.ReaSonus_DecrementTransportSeekSpeed()
			Console("ReaSonus_DecrementTransportSeekSpeed")
			
		elseif (phase == 12) then
			reaper.ReaSonus_DecrementTransportSeekSpeed()
			Console("ReaSonus_DecrementTransportSeekSpeed")

		elseif (phase == 13) then
			reaper.ReaSonus_SetTransportSeekSpeed(5)
			Console("ReaSonus_SetTransportSeekSpeed(5)")
			phase_time = 1
			
		elseif (phase == 14) then
			reaper.ReaSonus_SetTransportSeekRewind()
			Console("ReaSonus_SetTransportSeekRewind")
			
		elseif (phase == 15) then
			reaper.ReaSonus_SetTransportSeekForward()
			Console("ReaSonus_SetTransportSeekForward")
			
		elseif (phase == 16) then
			reaper.ReaSonus_SetTransportSeekRewind()
			Console("ReaSonus_SetTransportSeekRewind")
			
		elseif (phase == 17) then
			reaper.ReaSonus_SetTransportSeekStop()
			Console("ReaSonus_SetTransportSeekStop")
			
		elseif (phase == 18) then
			reaper.ReaSonus_SetTransportSeek(1)
			Console("ReaSonus_SetTransportSeek(1)")
			phase_time = 0.5
			
		elseif (phase == 19) then
			reaper.ReaSonus_SetTransportSeek(-1)
			Console("ReaSonus_SetTransportSeek(-1)")
			
		elseif (phase == 20) then
			reaper.ReaSonus_SetTransportSeek(1)
			Console("ReaSonus_SetTransportSeek(1)")
			
		elseif (phase == 21) then
			reaper.ReaSonus_SetTransportSeek(-1)
			Console("ReaSonus_SetTransportSeek(-1)")
			
		elseif (phase == 22) then
			reaper.ReaSonus_SetTransportSeekSpeed(1)
			Console("ReaSonus_SetTransportSeekSpeed(1)")
			phase_time = 2
			
		elseif (phase == 23) then
			reaper.ReaSonus_SetTransportSeek(0)
			Console("ReaSonus_SetTransportSeek(0)")
			finished = true
		end
		
		NextPhase()
	end
	
	if (not finished) then
		--repeat this action every 1s
		if (main_loop_elapsed >= 1) then
			time_start = reaper.time_precise()
			MainLoop()
		else
			reaper.defer(MainLoop)
		end
	else
		Console("Script -> End")
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
	TransportSeek()
end

if (versionCheck()) then ScriptExecute() end
