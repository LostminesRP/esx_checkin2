-- Variables
local PlayerData                      = {}
local IsNear, IsCheckedIn, IsMenuOpen = false	
ESX                                   = nil

-- ESX Core thread
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    	while ESX.GetPlayerData() == nil do
        	Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- When checked in
RegisterNetEvent('esx_checkin:haveSpace')
AddEventHandler('esx_checkin:haveSpace', function()
	IsCheckedIn = true
	if Config.GiveArmor then
		SetPedArmour(PlayerPedId(), 100)
	end
	if Config.UseUniforms then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
		end)
	end

end)

-- When you use policebadge
RegisterNetEvent('esx_checkin:openBadgeMenu')
AddEventHandler('esx_checkin:openBadgeMenu', function(source)
	--playAnim('mp_common', 'givetake1_a', 2500)
	--Citizen.Wait(2500)
	OpenMenu()
end)

-- When you inspect policebadge
RegisterNetEvent('esx_checkin:inspectBadge')
AddEventHandler('esx_checkin:inspectBadge', function()
	notification()
end)

-- When you show policebadge
RegisterNetEvent('esx_checkin:showBadge')
AddEventHandler('esx_checkin:showBadge', function(closestPlayer, closestPlayerDistance)
	local player, distance = ESX.Game.GetClosestPlayer()

	if player ~= -1 and distance <= 3.0 then
		notification2()
		ESX.ShowNotification(_U('gave_policebadge'))
	else
		ESX.ShowNotification(_U('no_one_nearby'))
	end
end)

-- When you stop/restart the resource
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ClearPedTasks(PlayerPedId())
		if IsMenuOpen then
			ESX.UI.Menu.CloseAll()
		end

	end
end)

function kirjauduDuunin()

	if not IsCheckedIn then

		TriggerEvent('mythic_progbar:client:progress', {
			name = 'checking_in',
			duration = Config.CheckInTime,
			label = _U('progbar_checkin'),
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = 'missheistdockssetup1clipboard@idle_a',
				anim = 'idle_a',
			},
			prop = {
				model = 'p_amb_clipboard_01',
				bone = 18905,
				coords = { x = 0.10, y = 0.02, z = 0.08 },
				rotation = { x = -80.0, y = 0.0, z = 0.0 },
			}
		}, function(status)
			if not status then
				TriggerServerEvent('esx_checkin:justCheckedIn')
			end
		end)

	elseif IsCheckedIn then 

		TriggerEvent('mythic_progbar:client:progress', {
			name = 'checking_in',
			duration = Config.CheckInTime,
			label = _U('progbar_checkout'),
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
				animation = {
				animDict = 'missheistdockssetup1clipboard@idle_a',
				anim = 'idle_a',
			},
				prop = {
				model = 'p_amb_clipboard_01',
				bone = 18905,
				coords = { x = 0.10, y = 0.02, z = 0.08 },
				rotation = { x = -80.0, y = 0.0, z = 0.0 },
			}
			}, function(status)
			if not status then
				IsCheckedIn = false
				TriggerServerEvent('esx_checkin:justCheckedOut')
				if Config.GiveArmor then
					SetPedArmour(PlayerPedId(), 0)
				end
				if Config.UseUniforms then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end
			end
		end)

	end 
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local location, location2, location3 = Config.Location, Config.Location2, Config.Location3
		local etaisyys = GetDistanceBetweenCoords(location, GetEntityCoords(GetPlayerPed(-1)))
		local etaisyys2 = GetDistanceBetweenCoords(location2, GetEntityCoords(GetPlayerPed(-1)))
		local etaisyys3 = GetDistanceBetweenCoords(location3, GetEntityCoords(GetPlayerPed(-1)))

		if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then

			if (etaisyys < 2.0) then
				Draw3DText(location.x, location.y, location.z, _U('check_in'), 0.4)
				if IsControlJustPressed(0, 38) and GetLastInputMethod() then
					kirjauduDuunin()
				end 
			end
	
			if (etaisyys2 < 2.0) then
				Draw3DText(location2.x, location2.y, location2.z, _U('check_in'), 0.4)
				if IsControlJustPressed(0, 38) and GetLastInputMethod() then
					kirjauduDuunin()
				end 
			end
	
			if (etaisyys3 < 2.0) then
				Draw3DText(location3.x, location3.y, location3.z, _U('check_in'), 0.4)
				if IsControlJustPressed(0, 38) and GetLastInputMethod() then
					kirjauduDuunin()
				end 
			end
		end
	end
end)

--[[

-- Check in/check out main core
Citizen.CreateThread(function()
	Citizen.Wait(1000)

	local location, location2= Config.Location, Config.Location2
	while true do
		Citizen.Wait(Config.Optimization)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
			local coords = GetEntityCoords(PlayerPedId())
			if IsNear then
				if not IsCheckedIn then
					Draw3DText(location.x, location.y, location.z, _U('check_in'), 0.4)
					Draw3DText(location2.x, location2.y, location2.z, _U('check_in'), 0.4)
					if Vdist(coords, location, location2) < 1 and IsControlJustReleased(1, 38) then
						print ('asdasd')
						TriggerEvent('mythic_progbar:client:progress', {
							name = 'checking_in',
							duration = Config.CheckInTime,
							label = _U('progbar_checkin'),
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = 'missheistdockssetup1clipboard@idle_a',
								anim = 'idle_a',
							},
							prop = {
								model = 'p_amb_clipboard_01',
								bone = 18905,
								coords = { x = 0.10, y = 0.02, z = 0.08 },
								rotation = { x = -80.0, y = 0.0, z = 0.0 },
							}
						}, function(status)
							if not status then
								TriggerServerEvent('esx_checkin:justCheckedIn')
							end
						end)
					end
				elseif IsCheckedIn then
					Draw3DText(location.x, location.y, location.z, _U('check_out'), 0.4)
					Draw3DText(location2.x, location2.y, location2.z, _U('check_in'), 0.4)
					if Vdist(coords, location, location2) < 1 and IsControlJustReleased(1, 38) then
						TriggerEvent('mythic_progbar:client:progress', {
							name = 'checking_in',
							duration = Config.CheckInTime,
							label = _U('progbar_checkout'),
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = 'missheistdockssetup1clipboard@idle_a',
								anim = 'idle_a',
							},
							prop = {
								model = 'p_amb_clipboard_01',
								bone = 18905,
								coords = { x = 0.10, y = 0.02, z = 0.08 },
								rotation = { x = -80.0, y = 0.0, z = 0.0 },
							}
						}, function(status)
							if not status then
								IsCheckedIn = false
								TriggerServerEvent('esx_checkin:justCheckedOut')
								if Config.GiveArmor then
									SetPedArmour(PlayerPedId(), 0)
								end
								if Config.UseUniforms then
									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
										TriggerEvent('skinchanger:loadSkin', skin)
									end)
								end
							end
						end)
					end
				end
			end
		end
	end
end)

--]]

-- Draw distance
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		if Vdist(coords, Config.Location, Config.Location2 ) < Config.DrawDistance	then
			IsNear = true
		else
			IsNear = false
		end
	end
end)

-- Define elements for esx menu
local elements = {
	{label = _U('inspect_badge'), value = 'inspect_badge'},
	{label = _U('show_badge'), value = 'show_badge'}
}



-- Function for esx menu
function OpenMenu()
	IsMenuOpen = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
		title = _U('menu_title'),
		align = 'left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'inspect_badge' then
			TriggerEvent('esx_checkin:inspectBadge')
		end
		if data.current.value == 'show_badge' then
			TriggerEvent('esx_checkin:showBadge')
		end
	end, function(data, menu)
		menu.close()
		IsMenuOpen = false
		ClearPedTasks(PlayerPedId())
	end)
end

-- 3D Text function
function Draw3DText(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry('STRING')
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 700
	DrawRect(_x, _y + 0.0150, 0.06 + factor, 0.03, 41, 11, 41, 100)
end

-- Animation function
function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

-- Policebadge function
function notification()
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
	local job = PlayerData.job.label
	local job_grade = PlayerData.job.grade_label	
	playAnim('amb@world_human_seat_wall_tablet@female@base', 'base', -1)
	Citizen.Wait(1000)
    ESX.ShowAdvancedNotification(_U('policebadge_title'), _U('policebadge_subject'), _U('policebadge_job') .. job .. _U('policebadge_job_grade') .. job_grade, mugshotStr, 2)
    UnregisterPedheadshot(mugshot)
end

function notification2()
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
	--local closestPlayer = ESX.Game.GetClosestPlayer()
	local job = PlayerData.job.label
	local job_grade = PlayerData.job.grade_label		
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
	local pelaajaaa = closestPlayer

if closestPlayer ~= -1 or closestPlayerDistance > 3.0 then
	print(closestPlayer)
	print(closestPlayerDistance)
	--playAnim('mp_common', 'givetake1_a', 2500)
	--Citizen.Wait(2500)
	TriggerServerEvent('esx_checkin:notify', GetPlayerServerId(closestPlayer), job, job_grade, mugshotStr)
    --ESX.ShowAdvancedNotification(  _U('policebadge_title'), _U('policebadge_subject'), _U('policebadge_job') .. job .. _U('policebadge_job_grade') .. job_grade, mugshotStr, 2)
 
    UnregisterPedheadshot(mugshot)
end
end

RegisterNetEvent('esx_checkin:vittusaatana')
AddEventHandler('esx_checkin:vittusaatana', function (tyonnimi, tyontaso, kuva)

local kuva = 'CHAR_CALL911'


	ESX.ShowAdvancedNotification(_U('policebadge_title'), _U('policebadge_subject'), _U('policebadge_job') .. tyonnimi .. _U('policebadge_job_grade') .. tyontaso, kuva, 2)
end)