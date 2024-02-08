local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Commands.Add('Pmanager', 'manage player', {}, false, function(source, args)
    TriggerClientEvent('core-playermanagement:client:openmenu', source)
end, 'admin')

QBCore.Functions.CreateCallback('core-playermanagement:server:getallgang', function(source, cb, args)
    local gangs = {}
    for k, v in pairs(QBCore.Shared.Gangs) do
        table.insert(gangs, {
            gang = k
        })
    end
    cb(gangs)
end)
QBCore.Functions.CreateCallback('core-playermanagement:server:getplayers', function(source, cb, args)
    local players = {}
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        table.insert(players, {
            firstname = v.PlayerData.charinfo.firstname,
            lastname = v.PlayerData.charinfo.lastname,
            job = v.PlayerData.job.name,
            grade = v.PlayerData.job.grade.name,
            cid = v.PlayerData.citizenid,
            gang = v.PlayerData.gang.name,
            ganggrade = v.PlayerData.gang.grade.name,
            craftinrep = v.PlayerData.metadata['craftingrep'],
            playerid = v.PlayerData.source

        })
    end
    cb(players)
end)
QBCore.Functions.CreateCallback('core-playermanagement:server:getalljobs', function(source, cb, args)
    local jobs = {}
    for k, v in pairs(QBCore.Shared.Jobs) do
        table.insert(jobs, {
            job = k
        })
    end
    cb(jobs)
end)
QBCore.Functions.CreateCallback('core-playermanagement:server:getganggrade', function(source, cb, gang)
    local ganggrades = {}
    if QBCore.Shared.Gangs[gang] then
        for grade, data in pairs(QBCore.Shared.Gangs[gang].grades) do
            table.insert(ganggrades, {
                grade = grade,
                name = data.name
            })
        end
    end
    cb(ganggrades)
end)
QBCore.Functions.CreateCallback('core-playermanagement:server:getallgradeofjob', function(source, cb, job)
    local grades = {}
    if QBCore.Shared.Jobs[job] then
        for grade, data in pairs(QBCore.Shared.Jobs[job].grades) do
            table.insert(grades, {
                grade = grade,
                name = data.name
            })
        end
    end
    cb(grades)
end)
RegisterNetEvent('core-playermanagement:server:kickplayer', function(id)
    local p = QBCore.Functions.GetPlayerByCitizenId(id)
    if p then
        DropPlayer(p.PlayerData.source, "Out of the server")
    end
end)
RegisterNetEvent('core-playermanagement;server:givecash', function(id, amount)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(id)
    if p then
        p.Functions.AddMoney('cash', amount)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'You gave ' .. p.PlayerData.charinfo.firstname .. " " .. amount .. " $",
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'you received ' .. amount .. " $ in cash",
            'top-center',
            'success')
    end
end)
RegisterNetEvent('core-playermanagement;server:giveBank', function(id, amount)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(id)
    if p then
        p.Functions.AddMoney('bank', amount)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'You gave ' .. p.PlayerData.charinfo.firstname .. " " .. amount .. " $",
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'you received ' .. amount .. " $ in Bank",
            'top-center',
            'success')
    end
end)
RegisterNetEvent('core-playermanagement:server:updategrade', function(job, grade, citizenid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if p then
        p.Functions.SetJob(job, grade)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'Players Grade has been updated ',
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'your grade has been updated',
            'top-center',
            'success')
    end
end)
RegisterNetEvent('core-playermanagement:server:changejob', function(job, citizenid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if p then
        p.Functions.SetJob(job, 0)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'Player job has been update to ' .. job,
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'your job has been updated',
            'top-center',
            'success')
    end
end)
RegisterNetEvent('core-playermanagement:server:changegang', function(gang, citizenid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if p then
        p.Functions.SetGang(gang, 0)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'Player gang has been updated ',
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'your gang has been updated',
            'top-center',
            'success')
    end
end)

RegisterNetEvent('core-playermanagement:server:changeganggrade', function(gang, grade, citizenid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if p then
        print(gang, grade)
        p.Functions.SetGang(gang, grade)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'Player gang grade has been updated  ',
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'your gang grade has been updated',
            'top-center',
            'success')
    end
end)
RegisterNetEvent('core-playermanagement:server:givelevel', function(amount, citizenid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local p = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if p then
        p.Functions.SetMetaData("craftingrep", p.PlayerData.metadata["craftingrep"] + amount)
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'the Player received ' .. amount .. " level",
            'top-center',
            'success')
        TriggerClientEvent('core-gangsystem:client:notify', p.PlayerData.source,
            'youre crafting level has changed',
            'top-center',
            'success')
    end
end)
