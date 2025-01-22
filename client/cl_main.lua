ESX = nil
if (Config.ESXVersion == "newESX") then
    ESX = exports['es_extended']:getSharedObject()
else
    CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Wait(0)
        end
    end)
end

local function StartTrajet(type)
    local thread, canDoMission = nil, true
    ESX.TriggerServerCallback("ERROR_Gofast:Server:GetState", function(canInteract)
        if (not canInteract) then
            ESX.ShowNotification("Vous devez attendre avant de refaire un gofast", "error")
            return
        end

        local driveToCoords
        if (type == "small") then
            driveToCoords = Config.trajets['small'][math.random(1, #Config.trajets['small'])]
        elseif type == "medium" then
            driveToCoords = Config.trajets['medium'][math.random(1, #Config.trajets['medium'])]
        elseif type == "big" then
            driveToCoords = Config.trajets['big'][math.random(1, #Config.trajets['big'])]
        end
        local car = CreateCar(Config.Vehicles[math.random(1, #Config.Vehicles)], Config.VehSpawnPoint.x, Config.VehSpawnPoint.y, Config.VehSpawnPoint.z, Config.VehSpawnPoint.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
        TriggerServerEvent("ERROR_Gofast:Server:SetState", type, false)
        local blip = AddBlipForCoord(driveToCoords.x, driveToCoords.y, driveToCoords.z)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 5)
        ESX.ShowNotification(("Rendez-vous à la destination, vous avez %s minutes"):format(Config.TimeToDeleteMission), "success")

        SetTimeout(Config.TimeToDeleteMission*60000, function()
            if (DoesBlipExist(blip)) then
                RemoveBlip(blip)
                DeleteEntity(car)
                ESX.ShowNotification("Vous avez échoué la mission", "error")
            end
            canDoMission = false
        end)
    
        thread = CreateThread(function()
            local sleep, pos
            while (function()
                sleep = 1000
                if (not canDoMission) then return false end
                if (not IsPedInAnyVehicle(PlayerPedId())) then return true end
                pos = GetEntityCoords(PlayerPedId())
                dst = #(pos - driveToCoords)
                if (dst > 10.0) then return true end
                sleep = 0
                DrawMarker(Config.Markers['id'], driveToCoords.x, driveToCoords.y, driveToCoords.z+1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.Markers['size'], Config.Markers['size'], Config.Markers['size'], Config.Markers['color'][1], Config.Markers['color'][2], Config.Markers['color'][3], Config.Markers['opacity'], Config.Markers['animate'], true, 2, Config.Markers['turn'], nil, false)
                if (dst <= 2) then
                    ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour livrer le véhicule")
                    if (IsControlJustPressed(0, 51)) then
                        local car = GetVehiclePedIsIn(PlayerPedId())
                        local plate = GetVehicleNumberPlateText(car)
                        if (string.find(plate, "GOFAST")) then
                            DeleteEntity(car)
                            RemoveBlip(blip)
                            TriggerServerEvent("ERROR_Gofast:Server:PayGofast", type)
                            ESX.ShowNotification("Vous avez livré le véhicule avec succès", "success")
                            TerminateThread(GetIdOfThisThread())
                            return false
                        else
                            ESX.ShowNotification("Ce n'est pas le bon véhicule")
                        end
                    end
                end
                return true
            end) () do
                Wait(sleep)
            end
        end)
    end, type)
end

local npc = CreatePNJ(Config.PedModel, Config.PedPos.x, Config.PedPos.y, Config.PedPos.z, Config.PedPos.w)

exports.ox_target:addLocalEntity(npc, {
    label = "Commencer un GoFast",
    icon = "fas fa-car",
    name = "gofast",
    distance = 2.0,
    onSelect = function(ent)
        lib.showContext('gofast')
    end
})

lib.registerContext({
    id = 'gofast',
    title = 'Menu GoFast',
    options = {
        {
            title = 'Petit trajet',
            icon = 'fas fa-location-dot',
            description = "Raporte peu d'argent mais comporte peu de risque",
            onSelect = function(args)
                StartTrajet('small')
            end
        },
        {
            title = 'Trajet moyen',
            icon = 'fas fa-location-dot',
            description = "Raporte un peu plus d'argent mais comporte plus de risque",
            onSelect = function(args)
                StartTrajet('medium')
            end
        },
        {
            title = 'Long trajet',
            icon = 'fas fa-location-dot',
            description = "Raporte beaucoup d'argent mais comporte beaucoup de risque",
            onSelect = function(args)
                StartTrajet('big')
            end
        },
    },
})