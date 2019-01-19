-----------------------------------
--- Boat Trailer, Made by FAXES ---
-----------------------------------

--- Config ---

attachKey = 51 -- Index number for attach key - http://docs.fivem.net/game-references/controls/
attachKeyName = "~INPUT_CONTEXT~" -- Key name (center column) of above key.

--- Code ---

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1) -- Made the whole thing forgot to add this line lol, maybe thats why it broke #4:32AMLife
        local veh = GetVehiclePedIsIn(ped)
        if veh ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "DINGHY" then -- After a few hours here at 4am GetDisplayNameFromVehicleModel() got it working well :P
                local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
				local boatCoordsInWorldLol = GetEntityCoords(veh)
                local trailerLoc = GetVehicleInDirection(boatCoordsInWorldLol, belowFaxMachine)
                
				if GetDisplayNameFromVehicleModel(GetEntityModel(trailerLoc)) == "BOATTRAILER" then -- Is there a trailer????
                    if IsEntityAttached(veh) then -- Is boat already attached?
                        if IsControlJustReleased(1, attachKey) then -- detach
							DetachEntity(veh, false, true)
						end
                        -- Start Prompt
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to detach boat.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
                    else
                        if IsControlJustReleased(1, attachKey) then -- Attach
							AttachEntityToEntity(veh, trailerLoc, 20, 0.0, -1.0, 0.25, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
							TaskLeaveVehicle(ped, veh, 64)
                        end
                        -- Start Prompt
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to attach boat.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
                        -- Made by Faxes with some help of the bois
					end
                end
            end
        end
    end
    -- Just a comment here. Why the fuck not? Its 6 am now
end)
-- All done, only lots of bullshit with code lol. Timestamp, its not 6:15AM. Why we still here? Just to suffer?