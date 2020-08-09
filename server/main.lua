ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Checked In Event
RegisterServerEvent('esx_checkin:justCheckedIn')
AddEventHandler('esx_checkin:justCheckedIn', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)  
    if xPlayer.canCarryItem('policebadge', 1) then
        TriggerClientEvent('esx_checkin:haveSpace', source)
        xPlayer.addInventoryItem('policebadge', 1)
        if Config.GiveWeapons then
            xPlayer.addWeapon('weapon_pistol', 999)
            xPlayer.addWeapon('weapon_stungun', 999)
            xPlayer.addWeapon('weapon_nightstick', 999)
            xPlayer.addWeapon('weapon_flashlight', 999)
        end
        if Config.ChangeJob then
            if xPlayer.job.name ~= 'police' then
                xPlayer.setJob('police', xPlayer.job.grade)
            end
        end
        if Config.NotifyChat then
            TriggerClientEvent('chat:addMessage', -1, { 
                args = {_U('police_in') .. xPlayer.getName() .. _U('police2_in')} 
            })
        end
        xPlayer.showNotification(_U('just_checked_in'))
    else
        xPlayer.showNotification(_U('no_space'))
    end
end)

-- Checked Out Event
RegisterServerEvent('esx_checkin:justCheckedOut')
AddEventHandler('esx_checkin:justCheckedOut', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source) 
    xPlayer.setInventoryItem('policebadge', 0)
    if Config.GiveWeapons then
        xPlayer.removeWeapon('weapon_pistol')
        xPlayer.removeWeapon('weapon_stungun')
        xPlayer.removeWeapon('weapon_nightstick')
        xPlayer.removeWeapon('weapon_flashlight')
    end
    if Config.ChangeJob then
        if xPlayer.job.name ~= 'offpolice' then
            xPlayer.setJob('off' .. xPlayer.job.name, xPlayer.job.grade)
        end
    end
    if Config.NotifyChat then
        TriggerClientEvent('chat:addMessage', -1, { 
            args = {_U('police_out') .. xPlayer.getName() .. _U('police2_out')} 
        })
    end
    xPlayer.showNotification(_U('just_checked_out'))
end)

-- Make the policebadge usable
ESX.RegisterUsableItem('policebadge', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source) 
    TriggerClientEvent('esx_checkin:openBadgeMenu', source)
end)