
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local Zone = {
    Coord = {
        {position = vector3(-32.3, -1112.73, 26.42+1.0), metier = "unemployed"},
    }
}

Citizen.CreateThread(function()
    while true do
        local Waito = false
        for _,v in pairs(Zone.Coord) do
            if ESX.PlayerData.job.name == v.metier then
                local dist = Vdist2(GetEntityCoords(GetPlayerPed(-1)), v.position)
                if dist < 3 then
                    Waito = true 
                    DrawMarker(20, v.position, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2, 150, 50, 50, 100, 0, 0, 2, 1, nil, nil, 0)
                    if dist < 2 then 
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour intéragir")
                        if IsControlJustPressed(0, 51) then
                            RageUI.Visible(RMenu:Get('core', 'stock_entreprise_main'), true)
                            RefreshInfosSociety()
                        end
                    end
                end
            end
        end
        if Waito then
            Wait(0)
        else 
            Wait(500)
        end
    end
end)


KeyboardInput = function(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. '')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end
