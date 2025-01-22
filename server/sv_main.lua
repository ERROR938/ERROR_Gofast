local gofasts_states = {
    ['small'] = true,
    ['medium'] = true,
    ['big'] = true
}

ESX = nil
if (Config.ESXVersion == "newESX") then
    ESX = exports['es_extended']:getSharedObject()
else
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

RegisterNetEvent("ERROR_Gofast:Server:SetState", function(typee, state)
    gofasts_states[typee] = state
end)

RegisterNetEvent("ERROR_Gofast:Server:PayGofast", function(typee)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (not xPlayer) then 
        xPlayer.showNotification("Une erreur est survenue", "error")
        return
     end
    xPlayer.addAccountMoney('black_money', Config.rewards[typee])
    xPlayer.showNotification("Vous avez reçu votre récompense", "success")
    gofasts_states[typee] = false
    SetTimeout(Config.GofastRefeal*60000, function()
        gofasts_states[typee] = true
    end)
end)

ESX.RegisterServerCallback("ERROR_Gofast:Server:GetState", function(source, cb, typee)
    cb(gofasts_states[typee])
end)