local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('core-gangsystem:client:notify', function(title, position, type)
    lib.notify({
        title = title,
        position = position,
        type = type
    })
end)


RegisterNetEvent('core-playermanagement:client:openmenu', function(data)
    QBCore.Functions.TriggerCallback('core-playermanagement:server:getplayers', function(playerss)
        local options = {}
        for k, v in pairs(playerss) do
            table.insert(options, {
                title = v.firstname .. " " .. v.lastname,
                description = 'Job:' ..
                    " " ..
                    v.job ..
                    " | grade: " ..
                    v.grade ..
                    "\n " .. "gang: " .. v.gang .. " | grade: " .. v.ganggrade .. "\n" ..
                    "Crafting level: " .. v.craftinrep .. " | Id: " .. v.playerid,
                icon = 'user-circle',
                event = 'core-playermanagement:client:playermanager',
                arrow = true,
                args = {
                    fullname = v.firstname .. " " .. v.lastname,
                    id = v.cid,
                    jj = v.job,
                    level = v.craftinrep,

                    ggang = v.gang
                }

            })
        end
        lib.registerContext({
            id = 'admin_menu',
            title = 'Manage Players',
            options = options
        })
        lib.showContext('admin_menu')
    end)
end)
RegisterNetEvent('core-playermanagement:client:playermanager', function(data)
    lib.registerContext({
        id = 'other_menu',
        title = 'Player Manager',
        menu = 'admin_menu',
        options = {
            {
                title = 'Change Job',
                event = 'core-playermanagement:openjobmenu',
                args = {
                    targetid = data.id
                },
                arrow = true,
                icon = 'briefcase',
                description = "Click Here to change " .. data.fullname .. " job"
            },
            {
                title = 'Change Grade',
                description = 'Click Here to change ' .. data.fullname .. " grade",
                event = 'core-playermanagement:client:opengrademenu',
                arrow = true,
                args = {
                    job = data.jj,
                    cid = data.id,
                    name = data.fullname
                },
                icon = 'level-down'
            },
            {
                title = 'Change/Add Gang',
                description = 'Click Here to change ' .. data.fullname .. " Gang",
                event = 'core-playermanagement;client:opengangmenu',
                arrow = true,
                args = {
                    cid = data.id
                },
                icon = 'user-secret'
            },
            {
                title = 'Change Gang Grade',
                description = 'Click Here to change ' .. data.fullname .. " Gang grade",
                event = 'core-playermanagement;client:openganggrade',
                arrow = true,
                args = {
                    gang = data.ggang,
                    cid = data.id
                },
                icon = 'line-chart'
            },
            {
                title = 'Change/Give Crafting level',
                description = 'Click Here to change ' .. data.fullname .. " crafting level",
                event = 'core-playermanagement:addlevel',
                arrow = true,
                args = {

                    name = data.fullname,
                    cid = data.id,
                    craftingrep = data.level
                },
                icon = 'plus'
            },
            {
                title = 'Give ' .. data.fullname .. " Money",
                description = 'Click Here to give ' .. data.fullname .. 'money',
                arrow = true,
                event = "core-playermanagement:client:moneymenu",
                args = {
                    ffname = data.fullname,
                    ccid = data.id
                },
                icon = 'dollar'
            },
            {
                title = 'Kick ' .. data.fullname,
                description = 'Click Here to Kick ' .. data.fullname,
                onSelect = function()
                    TriggerServerEvent('core-playermanagement:server:kickplayer', data.id)
                end,
                icon = 'times-circle'
            },

        }
    })
    lib.showContext('other_menu')
end)

RegisterNetEvent('core-playermanagement:openjobmenu', function(dt)
    local options = {}
    QBCore.Functions.TriggerCallback('core-playermanagement:server:getalljobs', function(data)
        for k, v in pairs(data) do
            table.insert(options, {
                title = v.job,
                onSelect = function()
                    TriggerServerEvent('core-playermanagement:server:changejob', v.job, dt.targetid)
                end
            })
        end

        lib.registerContext({
            id = 'menu_1',
            title = 'Player Manager',
            menu = 'other_menu',
            options = options,

        })
        lib.showContext('menu_1')
    end)
end)
RegisterNetEvent('core-playermanagement:client:moneymenu', function(data)
    lib.registerContext({
        id = 'money_menu',
        title = 'Money management',
        menu = 'other_menu',
        options = {
            {
                title = 'Give Cash',
                description = 'Click here to give ' .. data.ffname .. ' cash',
                onSelect = function()
                    Givecashinput(data)
                end
            },
            {
                title = 'Give Bank Money',
                description = 'Click here to give ' .. data.ffname .. ' Bank money',
                onSelect = function()
                    GiveBankinput(data)
                end
            },
        }
    })

    lib.showContext('money_menu')
end)
RegisterNetEvent('core-playermanagement:client:opengrademenu', function(data)
    local options = {}
    QBCore.Functions.TriggerCallback('core-playermanagement:server:getallgradeofjob', function(grades)
        for k, v in pairs(grades) do
            table.insert(options, {
                title = v.name,
                onSelect = function()
                    TriggerServerEvent('core-playermanagement:server:updategrade', data.job, v.grade, data.cid)
                end
            })
        end
        lib.registerContext({
            id = 'grades_menu',
            title = 'Grades of ' .. data.name .. " job",
            menu = 'other_menu',
            options = options,
        })
        lib.showContext('grades_menu')
    end, data.job)
end)

RegisterNetEvent('core-playermanagement;client:opengangmenu', function(data)
    local options = {}
    QBCore.Functions.TriggerCallback('core-playermanagement:server:getallgang', function(gangs)
        for k, v in pairs(gangs) do
            table.insert(options, {
                title = v.gang,
                onSelect = function()
                    TriggerServerEvent('core-playermanagement:server:changegang', v.gang, data.cid)
                end
            })
        end
        lib.registerContext({
            id = 'gangs_menu',
            title = 'gangs',
            menu = 'other_menu',
            options = options,
        })
        lib.showContext('gangs_menu')
    end)
end)
RegisterNetEvent('core-playermanagement;client:openganggrade', function(data)
    local options = {}
    QBCore.Functions.TriggerCallback('core-playermanagement:server:getganggrade', function(ganga)
        for k, v in pairs(ganga) do
            table.insert(options, {
                title = v.name,
                onSelect = function()
                    TriggerServerEvent('core-playermanagement:server:changeganggrade', data.gang, v.grade, data.cid)
                end
            })
        end
        lib.registerContext({
            id = 'gangsgrade_menu',
            title = 'gang grade',
            menu = 'other_menu',
            options = options,
        })
        lib.showContext('gangsgrade_menu')
    end, data.gang)
end)
RegisterNetEvent('core-playermanagement:addlevel', function(data)
    local input = lib.inputDialog('Give Level',
        { { type = 'number', label = 'Crafting level ' .. data.craftingrep, description = 'Click here to give ' .. data.name .. ' crafting rep', icon = 'plus' } })
    if not input then return end
    TriggerServerEvent('core-playermanagement:server:givelevel', input[1], data.cid)
end)
function Givecashinput(data)
    local input = lib.inputDialog('Give Cash',
        { { type = 'number', label = 'Cash amount ', description = 'Put your amount here', icon = 'plus' } })
    if not input then return end
    TriggerServerEvent('core-playermanagement;server:givecash', data.ccid, input[1])
end

function GiveBankinput(data)
    local input = lib.inputDialog('Give Bank money',
        { { type = 'number', label = 'Bank money amount ', description = 'Put your amount here', icon = 'plus' } })
    if not input then return end
    TriggerServerEvent('core-playermanagement;server:giveBank', data.ccid, input[1])
end
