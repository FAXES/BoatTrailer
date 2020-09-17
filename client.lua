
attachKey = 51 -- Index number for attach key - http://docs.fivem.net/game-references/controls/
attachKeyName = "~INPUT_CONTEXT~" -- Key name (center column) of above key.

--- Code ---

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

vehicles = {
    ["dinghy"] = {20, 0.0, -2.0, 0.08, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["smallvehicle"] = {20, 0.0, -1.0, 0.45, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["mediumvehicle"] = {20, 0.0, -1.0, 0.50, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["predator"] = {20, 0.0, -1.6, 0.50, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["nitrovehicle"] = {20, 0.0, -1.0, 0.10, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["leo92"] = {10, 1.2, 2.2, 0.40, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
	["gatorciv"] = {10, 1.2, 2.2, 0.40, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["snowmobile"] = {10, 1.2, 2.2, 0.40, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["forklift"] = {10, 1.2, 2.2, 0.40, 0.0, 0.0, 0.0, false, false, true, false, 20, true},
    ["forklift2"] = {10, 1.2, 2.2, 0.40, 0.0, 0.0, 0.0, false, false, true, false, 20, true}
}

trailers = {
    ["vehicletrailer"] = true,
    ["nbtrailer"] = true,
    ["utvtrailer"] = true
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)
		if veh ~= nil then
			local vehName = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
			if vehicles[vehName] then
				local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 6.0, -5.0)
				local vehicleCoordsInWorldLol = GetEntityCoords(veh)
                local trailerLoc = GetVehicleInDirection(vehicleCoordsInWorldLol, belowFaxMachine)
				local trailName = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(trailerLoc)))
                if trailers[trailName] then
					if IsEntityAttached(veh) then
						if IsControlJustReleased(1, attachKey) then
							DetachEntity(veh, false, true)
						end
						-- Start Prompt
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to detach entity.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
					else
                        if IsControlJustReleased(1, attachKey) then
                            local vehicle = vehicles[vehName]
                            if vehName == "nitrovehicle" then
                                if trailName == "nbtrailer" then
                                    vehicle = {2, 0.18, -1.0, 0.20, 0.0, 0.0, 0.0, false, false, true, false, 20, true}
                                end
                            elseif vehName == "mediumvehicle" then
                                if trailName == "nbtrailer" then
                                     vehicle = {2, 0.18, -1.0, 0.65, 0.0, 0.0, 0.0, false, false, true, false, 20, true}
                                end
                            end
							AttachEntityToEntity(veh, trailerLoc, vehicle[1], vehicle[2], vehicle[3], vehicle[4], vehicle[5], vehicle[6], vehicle[7], vehicle[8], vehicle[9], vehicle[10], vehicle[11], vehicle[12], vehicle[13])
						end
                        -- Start Prompt
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to attach entity.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
					end
				end
			end
		end
    end
end)