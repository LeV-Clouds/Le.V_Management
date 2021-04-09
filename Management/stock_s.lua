ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("core:GetInfosSociety", function(source, callback)
    MySQL.Async.fetchAll('SELECT * FROM argent_entreprise WHERE id', {}, function(result)
        callback(result)
    end)
end)

ESX.RegisterServerCallback("core:GetInfosStock", function(source, callback)
    MySQL.Async.fetchAll('SELECT * FROM stock_entreprise WHERE id', {}, function(result)
        callback(result)
    end)
end)

RegisterServerEvent("core:PropreStock")
AddEventHandler("core:PropreStock", function(itemName, type, ID, somme)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)
    if type == "Depot" then 
            MySQL.Async.fetchAll('SELECT * FROM argent_entreprise WHERE id=@id', {['@id'] = ID}, function(result)
                for k, v in pairs(result) do
                    if xPlayer.getAccount(itemName).money >= tonumber(somme) and tonumber(somme) > 0 then
                        xPlayer.removeMoney(somme)
                        MySQL.Async.execute("UPDATE argent_entreprise SET argentpropre='" .. v.argentpropre + tonumber(somme) .. "' WHERE id ='" .. ID .. "';", {}, function() end)
                        TriggerClientEvent("esx:showNotification", xPlayer.source, "- Type : ~b~Dépot~s~\n- Somme : ~g~" .. tonumber(somme) .. "$")
                    else 
                        TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~b~Dépot~s~\n- Somme : ~g~" .. tonumber(somme) .. "$")
                    end
                end
            end)
    elseif type == "Retrait" then 
        MySQL.Async.fetchAll('SELECT * FROM argent_entreprise WHERE id=@id', {['@id'] = ID}, function(result)
            for k, v in pairs(result) do
                if v.argentpropre >= tonumber(somme) then
                    xPlayer.removeMoney(somme)
                    MySQL.Async.execute("UPDATE argent_entreprise SET argentpropre='" .. v.argentpropre - tonumber(somme) .. "' WHERE id ='" .. ID .. "';", {}, function() end)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- Type : ~y~Retrait~s~\n- Somme : ~g~" .. tonumber(somme) .. "$")
                else 
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~y~Retrait~s~\n- Somme : ~g~" .. tonumber(somme) .. "$")
                end
            end
        end)
    end
end)   

RegisterServerEvent("core:SaleStock")
AddEventHandler("core:SaleStock", function(itemName, type, ID, somme)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)
    local ArgentSaleGet = 0
	ArgentSaleGet = xPlayer.getAccount('black_money').money
    if type == "Depot" then 
            MySQL.Async.fetchAll('SELECT * FROM argent_entreprise WHERE id=@id', {['@id'] = ID}, function(result)
                for k, v in pairs(result) do
                    if ArgentSaleGet >= tonumber(somme) and tonumber(somme) > 0 then
                        xPlayer.removeAccountMoney('black_money', tonumber(somme))
                        MySQL.Async.execute("UPDATE argent_entreprise SET argentsale='" .. v.argentsale + tonumber(somme) .. "' WHERE id ='" .. ID .. "';", {}, function() end)
                        TriggerClientEvent("esx:showNotification", xPlayer.source, "- Type : ~b~Dépot~s~\n- Somme : ~r~" .. tonumber(somme) .. "$")
                    else 
                        TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~b~Dépot~s~\n- Somme : ~r~" .. tonumber(somme) .. "$")
                    end
                end
            end)
    elseif type == "Retrait" then 
        MySQL.Async.fetchAll('SELECT * FROM argent_entreprise WHERE id=@id', {['@id'] = ID}, function(result)
            for k, v in pairs(result) do
                if v.argentpropre >= tonumber(somme) then
                    xPlayer.addAccountMoney('black_money', tonumber(somme))
                    MySQL.Async.execute("UPDATE argent_entreprise SET argentsale='" .. v.argentsale - tonumber(somme) .. "' WHERE id ='" .. ID .. "';", {}, function() end)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- Type : ~y~Retrait~s~\n- Somme : ~r~" .. tonumber(somme) .. "$")
                else 
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~y~Retrait~s~\n- Somme : ~r~" .. tonumber(somme) .. "$")
                end
            end
        end)
    end
end) 

RegisterServerEvent("core:PrendreStock")    
AddEventHandler("core:PrendreStock", function(type, item, nombre, ID, NomItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "objet" then 
        MySQL.Async.fetchAll('SELECT * FROM stock_entreprise WHERE id=@id', {['@id'] = ID}, function(result)
            for k, v in pairs(result) do
                if v.nombre >= tonumber(nombre) and tonumber(nombre) > 0 then
                    MySQL.Async.execute("UPDATE stock_entreprise SET nombre='" .. v.nombre - tonumber(nombre) .. "' WHERE id ='" .. ID .. "';", {}, function() end)
                    xPlayer.addInventoryItem(item, tonumber(nombre))
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- Type : ~y~Retrait~s~\n- Nombre : ~b~" .. tonumber(nombre) .. "~s~\n- Item : ~g~" .. NomItem)
                else 
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~y~Retrait~s~\n- Nombre : ~b~" .. tonumber(nombre) .. "~s~\n- Objet : ~g~" .. NomItem)
                end
            end
        end)
    elseif type == "armes" then
        MySQL.Async.execute('DELETE FROM stock_entreprise WHERE id = @id',
        { ['id'] = ID })
        xPlayer.addWeapon(item, tonumber(nombre))
        TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\n- Type : ~y~Retrait~s~\n- Arme  : ~g~" .. NomItem .."~s~\n- Munitions : ~o~" .. nombre)
    end
end)

ESX.RegisterServerCallback('core:GetStorageItem', function(source, callback, type, metier, valeur, NomItem, nombre)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "objet" then
        MySQL.Async.fetchAll('SELECT * FROM stock_entreprise WHERE metier = @metier AND item = @item', {
            ["@metier"] = metier,
            ["@item"] = valeur
        }, function(result)
            if result[1] ~= nil then
                callback(false)
                MySQL.Async.fetchAll('SELECT * FROM stock_entreprise  WHERE metier = @metier AND item = @item', {['@metier'] = metier, ["@item"] = valeur,}, function(result)
                    for k, v in pairs(result) do
                        MySQL.Async.execute('UPDATE stock_entreprise SET nombre = @nombre WHERE metier = @metier AND item = @item', {['@metier'] = metier, ["@item"] = valeur, ['@nombre'] = v.nombre + tonumber(nombre)})
                        xPlayer.removeInventoryItem(valeur, tonumber(nombre))
                    end 
                end)
            else
                callback(true)
                MySQL.Async.execute('INSERT INTO stock_entreprise (item, nom, nombre, metier, type) VALUES(@item, @nom, @nombre, @metier, @type)',{ ["@item"] = valeur, ['@nom'] = NomItem, ['@nombre'] = nombre, ['@metier'] = metier, ['@type'] = "objet"})
                xPlayer.removeInventoryItem(valeur, tonumber(nombre))
            end
        end)
    elseif type == "armes" then
        MySQL.Async.execute('INSERT INTO stock_entreprise (item, nom, nombre, metier, type) VALUES(@item, @nom, @nombre, @metier, @type)',{ ["@item"] = valeur, ['@nom'] = NomItem, ['@nombre'] = nombre, ['@metier'] = metier, ['@type'] = "armes"})
        xPlayer.removeWeapon(valeur)
    end
end)

ESX.RegisterServerCallback('core:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory
	cb({
		items      = items,
		weapons    = xPlayer.getLoadout()
	})
end)


ESX.RegisterServerCallback('core:ListeEmployes', function(source, CallBack, metier)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE job = @job', {
        ['@job'] = metier
    }, function (Index)
        local ListeEMP = {}
        for k,v in pairs(Index) do
            table.insert(ListeEMP, {Nom = v.nom, Prenom = v.prenom, DDN = v.datedenaissance, Identitfier = v.identifier, Identifiant = v.identifiant, Grade = v.job_grade})
        end
        CallBack(ListeEMP)
    end)
end)

function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

ESX.RegisterServerCallback('core:ManageJob', function(source, CallBack, identifier, job, grade, option, metierlabel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
  
	if xTarget then
		if option == 'destitution' then
            if (xTarget.job.grade == 0) then
                TriggerClientEvent('esx:showNotification', xTarget.source, "- ~r~Erreur~s~\n- ~o~Destitution~s~\n- " .. metierlabel .. "\n- ~r~Destitution impossible")
            else 
                TriggerClientEvent('esx:showNotification', xTarget.source, "- ~o~Destitution~s~\n- " .. metierlabel )		
                xTarget.setJob(job, grade)
                MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                    ['@job']        = job,
                    ['@job_grade']  = grade,
                    ['@identifier'] = identifier
                })
            end
		elseif option == 'promotion' then
            if (xTarget.job.grade == tonumber(getMaximumGrade(xPlayer.job.name))) then
                TriggerClientEvent('esx:showNotification', xTarget.source, "- ~r~Erreur~s~\n- ~y~Promotion~s~\n- " .. metierlabel .. "\n- ~r~Promotion impossible")
            else 
                TriggerClientEvent('esx:showNotification', xTarget.source, "- ~y~Promotion~s~\n- " .. metierlabel )
                xTarget.setJob(job, grade)
                MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                    ['@job']        = job,
                    ['@job_grade']  = grade,
                    ['@identifier'] = identifier
                })
            end
		elseif option == 'licenciement' then
			TriggerClientEvent('esx:showNotification', xTarget.source, "- ~r~Licenciement~s~\n- " .. metierlabel)
			xTarget.setJob(job, grade)
            MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                ['@job']        = job,
                ['@job_grade']  = grade,
                ['@identifier'] = identifier
            })
		elseif option == 'recrutement' then
			TriggerClientEvent('esx:showNotification', xTarget.source, "- ~y~Recrutement~s~\n- " .. metierlabel)
			xTarget.setJob(job, grade)
            MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                ['@job']        = job,
                ['@job_grade']  = grade,
                ['@identifier'] = identifier
            })
		end
		CallBack()
	end
end)