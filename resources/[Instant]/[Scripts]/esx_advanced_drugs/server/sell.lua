RegisterNetEvent('esx_advanced_drugs:sell')
AddEventHandler('esx_advanced_drugs:sell', function()
    local _source = source
    playerHasDrugs(_source)
end)