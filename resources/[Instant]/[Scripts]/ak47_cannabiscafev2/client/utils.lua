ESX = ESX or nil
PlayerData = {}
scriptLoaded = true
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.SharedObjectName, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('ak47_cannabiscafev2:getconfig', function(result)
        Config = result
    end)
    if Config.Shop.blip.enable then
        createBlip()
    end
end)

function createBlip()
    local coords = Config.Shop.blip.pos
    local radius = Config.Shop.blip.radius + 0.00
    local blipRd = AddBlipForRadius(coords, radius)
    SetBlipHighDetail(blipRd, true)
    SetBlipColour(blipRd, Config.Shop.blip.radius_color)
    SetBlipAlpha (blipRd, 128)
    SetBlipAsShortRange(blipRd, true)
    local blip = AddBlipForCoord(coords)
    SetBlipHighDetail(blip, true)
    SetBlipSprite (blip, Config.Shop.blip.sprite)
    SetBlipScale  (blip, Config.Shop.blip.size)
    SetBlipColour (blip, Config.Shop.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Shop.blip.name)
    EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('ak47_cannabiscafev2:openbossaction')
AddEventHandler('ak47_cannabiscafev2:openbossaction', function()
    inBossMenu = false
    TriggerEvent('esx_society:openBossMenu', 'cannabiscafe', function(data, menu)
        menu.close()
    end)
    TriggerEvent('society:openBossMenu', 'cannabiscafe', function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('ak47_cannabiscafev2:notify')
AddEventHandler('ak47_cannabiscafev2:notify', function(msg)
    ESX.ShowNotification(msg)
end)

RegisterNetEvent('ak47_cannabiscafev2:progress')
AddEventHandler('ak47_cannabiscafev2:progress', function(msg, time)
    --Use your progressbar here
end)

function playAnim(dir, anim, blendIn, blendOut, duration, flag, playbackRate)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(dir)
    while not HasAnimDictLoaded(dir) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, dir, anim, blendIn + 0.0, blendOut + 0.0, duration, flag, playbackRate, 0, 0, 0)
end

function GetHeadingFromPoints(a, b)
    if not a or not b then
        return 0.0
    end
    if a.x == b.x and a.y == b.y then
        return 0.0
    end
    if #(a - b) < 1 then
        return 0.0
    end
    local theta = math.atan(b.x - a.x,a.y - b.y)
    if theta < 0.0 then
        theta = theta + (math.pi * 2)
    end
    return math.deg(theta) + 180 % 360
end

function drawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureDict, textureDict)
	DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureDict, textureDict)
end

function tofloat(value)
    return tonumber(string.format("%.2f", value))
end

function DrawText3D(coords, text, size, font)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords      = GetGameplayCamCoords()
    local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
    local size           = size

    if size == nil then
        size = 1
    end

    local scale = (size / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(font)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

function bongHighEffect()
    SetTimecycleModifierStrength(0.0)
    SetTimecycleModifier('spectator5')
    SetPedMotionBlur(PlayerPedId(), true)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.1)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.2)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.3)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.4)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.5)
    Citizen.Wait(1000)
    ShakeGameplayCam('DRUNK_SHAKE', 2.5)
    Citizen.Wait(3000)
    RequestClipSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')
    while not HasClipSetLoaded('MOVE_M@DRUNK@SLIGHTLYDRUNK') do
        Citizen.Wait(0)
    end
    while bongHigh > 0 do
        SetPedMovementClipset(GetPlayerPed(-1), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
        Citizen.Wait(1000)
        bongHigh = bongHigh - 1
        TriggerEvent('esx_status:remove', 'stress', 5000)
    end
    SetTimecycleModifierStrength(0.4)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.3)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.2)
    Citizen.Wait(1000)
    SetTimecycleModifierStrength(0.1)
    Citizen.Wait(1000)
    ClearTimecycleModifier()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    isBongHigh = false
end