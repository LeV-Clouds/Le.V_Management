ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj)
                ESX = obj
        end)
       Wait(10)
    end
     while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
   ESX.PlayerData.job = job
end)


local IndexArgentPropre = {Action = {"Retirer", "Déposer"}, index = 1}
local IndexArgentSale = {Action = {"Retirer", "Déposer"}, index = 1}
local Filtre = {Action = {"-", "Objet", "Armes"}, index = 1}
local Gerant = {Action = {"Promouvoir", "Destituer", "Licencier"}, index = 1}

Citizen.CreateThread(function ()

    RMenu.Add("core", "stock_entreprise_main", RageUI.CreateMenu("Casier", "Catégories"))
    RMenu.Add('core', 'stock_entreprise_main_retrait', RageUI.CreateSubMenu(RMenu:Get('core', 'stock_entreprise_main'), "Stockage", "Liste"))
    RMenu.Add('core', 'stock_entreprise_main_depot', RageUI.CreateSubMenu(RMenu:Get('core', 'stock_entreprise_main'), "Stockage", "Liste"))
    RMenu.Add('core', 'stock_entreprise_main_listemp', RageUI.CreateSubMenu(RMenu:Get('core', 'stock_entreprise_main'), "Casier de la société", "Liste"))


    while true do 
        Wait(0)

        RageUI.IsVisible(RMenu:Get('core', 'stock_entreprise_main') , true, true, true, function()
            RageUI.CenterButton("- ~y~Gestion du Casier~s~ -", nil, {}, true, function(Hovered, Active, Selected)
            end)
            if InfosSocCall then 
                for k,v in pairs(InfosSocCall) do
                    if v.metier == ESX.PlayerData.job.name then

                        RageUI.List("Argent non déclarée : ~r~" .. v.argentsale .. "$", IndexArgentSale.Action, IndexArgentSale.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                            if Selected then 
                                if Index == 1 then  -- Retirer
                                    if ESX.PlayerData.job.grade_name == 'gerant' then 
                                        RetraitSale = KeyboardInput("Somme à retirer ~r~$", "", 6)
                                        if tonumber(RetraitSale) ~= nil then 
                                            TriggerServerEvent("core:SaleStock", "black_money", "Retrait", v.id, RetraitSale)
                                            Wait(400)
                                            RefreshInfosSociety()
                                        elseif not tonumber(RetraitSale) then   
                                            RageUI.Popup({message= "~r~Somme inssufisante~s~."})
                                        end
                                    else 
                                        RageUI.Popup({message= "- ~r~Erreur~s~\n- Vous n'êtes pas ~o~gérant~s~."})
                                    end
                                elseif Index == 2 then -- Déposer
                                    DepotSale = KeyboardInput("Somme à déposer ~r~$", "", 6)
                                    if tonumber(DepotSale) ~= nil then 
                                        TriggerServerEvent("core:SaleStock", "black_money", "Depot", v.id, DepotSale)
                                        Wait(400)
                                        RefreshInfosSociety()
                                    elseif not tonumber(DepotSale) then   
                                        RageUI.Popup({message= "~r~Somme inssufisante~s~."})
                                    end
                                end
                            end
                            IndexArgentSale.index = Index
                        end)

                        RageUI.List("Argent déclarée : ~g~" .. v.argentpropre .. "$", IndexArgentPropre.Action, IndexArgentPropre.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                            if Selected then    
                                if Index == 1 then  -- Retirer
                                    if ESX.PlayerData.job.grade_name == 'gerant' then 
                                        RetraitPropre = KeyboardInput("Somme à déposer ~g~$", "", 6)
                                        if tonumber(RetraitPropre) ~= nil then 
                                            TriggerServerEvent("core:PropreStock", "money", "Retrait", v.id, RetraitPropre)
                                            Wait(400)
                                            RefreshInfosSociety()
                                        elseif not tonumber(RetraitPropre) then 
                                            RageUI.Popup({message= "~r~Somme inssufisante~s~."})
                                        end
                                    else 
                                        RageUI.Popup({message= "- ~r~Erreur~s~\n- Vous n'êtes pas ~o~gérant~s~."})
                                    end
                                elseif Index == 2 then -- Déposer
                                    DepotPropre = KeyboardInput("Somme à déposer ~g~$", "", 6)
                                    if tonumber(DepotPropre) ~= nil then 
                                        TriggerServerEvent("core:PropreStock", "money", "Depot", v.id, DepotPropre)
                                        Wait(400)
                                        RefreshInfosSociety()
                                    elseif not tonumber(DepotPropre) then   
                                        RageUI.Popup({message= "~r~Somme inssufisante~s~."})
                                    end
                                end
                            end
                            IndexArgentPropre.index = Index
                        end)
                    end
                end
            end
            RageUI.Button("Retirer du stock", nil, {RightLabel = ">"}, true, function(Hovered, Active, Selected)
                if Selected then
                    RefreshInfosStock()
                end
            end, RMenu:Get('core', 'stock_entreprise_main_retrait'))
            RageUI.Button("Déposer dans le stock", nil, {RightLabel = ">"}, true, function(Hovered, Active, Selected)
                if Selected then
                   RefreshInfosInv()
                end
            end, RMenu:Get('core', 'stock_entreprise_main_depot'))
            if ESX.PlayerData.job.grade_name == 'gerant' then 
                RageUI.Button("Liste des salarié(es)", nil, {RightLabel = ">"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RefreshInfosEmployee()
                    end
                end, RMenu:Get('core', 'stock_entreprise_main_listemp'))
            else 
                RageUI.Button("~c~Liste des salarié(es)", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
				end)
            end
        end) 
        RageUI.IsVisible(RMenu:Get('core', 'stock_entreprise_main_listemp') , true, true, true, function()
            RageUI.CenterButton("- ~b~Gestion des salarié(es)~s~ -", nil, {}, true, function(Hovered, Active, Selected)
            end)
            if InfosEmployeeCall then
                for k ,v in pairs(InfosEmployeeCall) do
                    RageUI.List(v.Nom .. " " .. v.Prenom, Gerant.Action, Gerant.index, "- Date de naissance : ~y~" .. v.DDN .. "~s~\n- ID : ~r~" .. v.Identifiant, {}, true, function(Hovered, Active, Selected, Index) 
						if Selected then
							if Index == 1 then
								ESX.TriggerServerCallback('core:ManageJob', function()
								end, v.Identitfier, ESX.PlayerData.job.name, tonumber(v.Grade) + 1, 'promotion', "~b~" .. ESX.PlayerData.job.label)
								Wait(350)
								RefreshInfosEmployee()
								Wait(50)
								TriggerEvent('esx:showNotification', '- ~y~Promotion\n~s~- Nom : ~g~'.. v.Nom .. " " .. v.Prenom)
							elseif Index == 2 then
								ESX.TriggerServerCallback('core:ManageJob', function()
								end, v.Identitfier, ESX.PlayerData.job.name, tonumber(v.Grade) - 1, 'destitution', "~b~" .. ESX.PlayerData.job.label)
								Wait(350)
								RefreshInfosEmployee()
								Wait(50)
								TriggerEvent('esx:showNotification', '- ~o~Destitution\n~s~- Nom : ~g~'.. v.Nom .. " " .. v.Prenom)
							elseif Index == 3 then
								ESX.TriggerServerCallback('core:ManageJob', function()
								end, v.Identitfier, 'unemployed', 0, 'licenciement', "~b~" .. ESX.PlayerData.job.label)
								Wait(350)
								RefreshInfosEmployee()
								Wait(50)
								ESX.ShowNotification("- ~r~Licenciement\n~s~- Nom : ~g~" .. v.Nom .. " " .. v.Prenom .. "~s~\n- Métier : ~b~Chômeur")
							end
						end
						Gerant.index = Index
					end)
                end
            end
        end)
        RageUI.IsVisible(RMenu:Get('core', 'stock_entreprise_main_retrait') , true, true, true, function()
            RageUI.CenterButton("~y~Retrait d'un éléments~s~", nil, {}, true, function(Hovered, Active, Selected)
            end)
            RageUI.List("Filtrer", Filtre.Action, Filtre.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                if Index == 1 then 
                   objet = false
                   tout = true
                   armes = false
                elseif Index == 2 then
                    tout = false
                    objet = true
                    armes = false
                elseif Index == 3 then
                    tout = false
                    objet = false
                    armes = true
                end
                Filtre.index = Index
            end)
            if InfosStockCall then 
                for k,v in pairs(InfosStockCall) do
                    if v.metier == ESX.PlayerData.job.name then 
                        if InfosStockCall[k].nombre > 0  then 
                            if tout then
                                if v.type == 'objet' then 
                                    RageUI.Button(v.nom .. " - (Contenue) : [~g~" .. v.nombre .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            RetraitObjet = KeyboardInput("Quantité à retirer : ", "", 6)
                                            if tonumber(RetraitObjet) > v.nombre then
                                                RageUI.Popup({message= "- ~r~Erreur~s~\n- Objet : ~g~" .. v.nom .. "~s~\n- Quantité : ~g~" .. tonumber(RetraitObjet)}) 
                                            else 
                                                if tonumber(RetraitObjet) ~= nil then 
                                                    TriggerServerEvent("core:PrendreStock", "objet", v.item, RetraitObjet, v.id, v.nom)
                                                    Wait(400)
                                                    RefreshInfosStock()
                                                elseif not tonumber(RetraitObjet) then   
                                                    RageUI.Popup({message= "~r~Quantité inssufisante~s~."})
                                                end
                                            end
                                        end
                                    end)
                                elseif v.type == 'armes' then
                                    RageUI.Button(v.nom .. " - (Munitions) : [~y~" .. v.nombre .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent("core:PrendreStock", "armes", v.item, v.nombre, v.id, v.nom)
                                            Wait(400)
                                            RefreshInfosStock()
                                        end
                                    end) 
                                end
                            elseif objet then
                                if v.type == 'objet' then 
                                    RageUI.Button(v.nom .. " - (Contenue) : [~g~" .. v.nombre .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            RetraitObjet = KeyboardInput("Quantité à retirer : ", "", 6)
                                            if tonumber(RetraitObjet) > v.nombre then
                                                RageUI.Popup({message= "- ~r~Erreur~s~\n- Objet : ~g~" .. v.nom .. "~s~\n- Quantité : ~g~" .. tonumber(RetraitObjet)}) 
                                            else 
                                                if tonumber(RetraitObjet) ~= nil then 
                                                    TriggerServerEvent("core:PrendreStock", "objet", v.item, RetraitObjet, v.id, v.nom)
                                                    Wait(400)
                                                    RefreshInfosStock()
                                                elseif not tonumber(RetraitObjet) then   
                                                    RageUI.Popup({message= "~r~Quantité inssufisante~s~."})
                                                end
                                            end
                                        end
                                    end) 
                                end
                            elseif armes then
                                if v.type == 'armes' then
                                    RageUI.Button(v.nom .. " - (Munitions) : [~y~" .. v.nombre .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent("core:PrendreStock", "armes", v.item, v.nombre, v.id, v.nom)
                                            Wait(400)
                                            RefreshInfosStock()
                                        end
                                    end) 
                                end
                            end
                        end
                    end
                end
            end
        end)
        RageUI.IsVisible(RMenu:Get('core', 'stock_entreprise_main_depot') , true, true, true, function()
            RageUI.CenterButton("~y~Dépot d'un éléments~s~", nil, {}, true, function(Hovered, Active, Selected)
            end)
            RageUI.List("Filtrer", Filtre.Action, Filtre.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                if Index == 1 then 
                   objet = false
                   tout = true
                   armes = false
                elseif Index == 2 then
                    tout = false
                    objet = true
                    armes = false
                elseif Index == 3 then
                    tout = false
                    objet = false
                    armes = true
                end
                Filtre.index = Index
            end) 
            if tout then 
                if ListeObjet then
                    for k,v in pairs(ListeObjet) do
                        if ListeObjet[k].count > 0  then
                            RageUI.Button(v.label .. " - (Contenue) : [~g~" .. v.count .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    DepotStock = KeyboardInput("Quantité à déposer :", "", 6)
                                    if tonumber(DepotStock) ~= nil then 
                                        if tonumber(DepotStock) > v.count then
                                            RageUI.Popup({message= "- ~r~Erreur~s~\n- Objet : ~g~" .. v.label .. "~s~\n- Quantité : ~g~" .. v.count}) 
                                        else 
                                            ESX.TriggerServerCallback('core:GetStorageItem', function(valid)
                                                if valid then
                                                    RageUI.Popup({message= "~g~Vérification~s~ ..."}) 
                                                    Wait(400)
                                                    RefreshInfosInv()
                                                    RageUI.Popup({message= "- Type : ~y~Dépot~s~\n- Nombre : ~b~" .. tonumber(DepotStock) .. "~s~\n- Item : ~g~" .. v.label}) 
                                                else 
                                                    RageUI.Popup({message= "~g~Vérification~s~ ..."}) 
                                                    Wait(400)
                                                    RefreshInfosInv()
                                                    RageUI.Popup({message= "- Type : ~b~Rajout~s~\n- Nombre : ~b~" .. tonumber(DepotStock) .. "~s~\n- Item : ~g~" .. v.label}) 
                                                end
                                            end, "objet", ESX.PlayerData.job.name, v.name, v.label, DepotStock)   
                                        end
                                    elseif not tonumber(DepotStock) then 
                                        RageUI.Popup({message= "~r~Quantité inssufisante~s~."})    
                                    end
                                end
                            end)
                        end 
                    end 
                end
                if ListeArmes then
                    for k,v in pairs(ListeArmes) do
                        RageUI.Button(v.label .. " - (Munitions) : [~y~" .. v.ammo .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ESX.TriggerServerCallback('core:GetStorageItem', function()
                                end, "armes", ESX.PlayerData.job.name, v.name, v.label, v.ammo)  
                                Wait(400)
                                RefreshInfosInv() 
                            end
                        end)
                    end 
                end         
            elseif objet then
                if ListeObjet then
                    for k,v in pairs(ListeObjet) do
                        if ListeObjet[k].count > 0  then
                            RageUI.Button(v.label .. " - (Contenue) : [~g~" .. v.count .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    DepotStock = KeyboardInput("Quantité à déposer :", "", 6)
                                    if tonumber(DepotStock) ~= nil then 
                                        if tonumber(DepotStock) > v.count then
                                            RageUI.Popup({message= "- ~r~Erreur~s~\n- Objet : ~g~" .. v.label .. "~s~\n- Quantité : ~g~" .. v.count}) 
                                        else 
                                            ESX.TriggerServerCallback('core:GetStorageItem', function(valid)
                                                if valid then
                                                    RageUI.Popup({message= "~g~Vérification~s~ ..."}) 
                                                    Wait(400)
                                                    RefreshInfosInv()
                                                    RageUI.Popup({message= "- Type : ~y~Dépot~s~\n- Nombre : ~b~" .. tonumber(DepotStock) .. "~s~\n- Item : ~g~" .. v.label}) 
                                                else 
                                                    RageUI.Popup({message= "~g~Vérification~s~ ..."}) 
                                                    Wait(400)
                                                    RefreshInfosInv()
                                                    RageUI.Popup({message= "- Type : ~b~Rajout~s~\n- Nombre : ~b~" .. tonumber(DepotStock) .. "~s~\n- Item : ~g~" .. v.label}) 
                                                end
                                            end, "objet", ESX.PlayerData.job.name, v.name, v.label, DepotStock)   
                                        end
                                    elseif not tonumber(DepotStock) then 
                                        RageUI.Popup({message= "~r~Quantité inssufisante~s~."})    
                                    end
                                end
                            end)
                        end 
                    end 
                end
            elseif armes then
                if ListeArmes then
                    for k,v in pairs(ListeArmes) do
                        RageUI.Button(v.label .. " - (Munitions) : [~y~" .. v.ammo .. "~s~]", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ESX.TriggerServerCallback('core:GetStorageItem', function()
                                end, "armes", ESX.PlayerData.job.name, v.name, v.label, v.ammo)  
                                Wait(400)
                                RefreshInfosInv() 
                            end
                        end)
                    end 
                end     
            end    
        end)
    end
end)

RefreshInfosSociety = function() -- Argent société
   ESX.TriggerServerCallback("core:GetInfosSociety", function(InfosStock)
       InfosSocCall = InfosStock
   end)
end


RefreshInfosEmployee = function() -- Liste Employées
    ESX.TriggerServerCallback("core:ListeEmployes", function(InfosEmployee)
        InfosEmployeeCall = InfosEmployee
    end, ESX.PlayerData.job.name)
end


RefreshInfosStock = function() -- Stock
    ESX.TriggerServerCallback("core:GetInfosStock", function(InfosStock)
        InfosStockCall = InfosStock
    end)
end

RefreshInfosInv = function() -- Inventaire Joueur
	Objet = {}
	Armes = {}
	ESX.TriggerServerCallback('core:getPlayerInventory', function(inventory)
        ListeObjet = inventory.items
        ListeArmes = inventory.weapons
	end)
end