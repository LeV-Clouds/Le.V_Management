ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj)
                ESX = obj
        end)
       Wait(10)
    end
end)


local List = {Test = {"Index 1", "Index 2", "Index 3"}, index = 1}
local List2 = {Test = {"Index 1", "Index 2", "Index 3"}, index = 1}

local pourcentageHr = 0.2
local SliderTest = 1
local SliderTest2 = 1

Citizen.CreateThread(function()

    RMenu.Add("core", "example", RageUI.CreateMenu("Examples", "Example Menu")) -- [Dépendance du Menu Crée] -- Tuto bientôt sur ma chaine ! : )
    -- RMenu:Get("core", "example"):SetRectangleBanner(255, 255, 255, 100) -- [Couleur du Menu] (RageUI)

    while true do 
        Wait(0)

        RageUI.IsVisible(RMenu:Get('core', 'example') , true, true, true, function()
            RageUI.Button("Button Test", nil, {}, true, function(Hovered, Active, Selected)
            end)  
            RageUI.Button("Button Test", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then 
                    KeyboardInput("Test Button", "...", 3)
                end 
            end) 
            RageUI.CenterButton("CenterButton Test", nil, {}, true, function(Hovered, Active, Selected)
            end)     
            RageUI.Checkbox("CheckBox Test", nil, CheckTest, {}, function(Hovered, Active, Selected, Checked)
                CheckTest = Checked
            end)
            RageUI.Separator("<-- Separator -->")

            RageUI.Checkbox("Checkez pour voir l'héritage (Parents)", nil, CheckTestHer, {}, function(Hovered, Active, Selected, Checked)
                CheckTestHer = Checked
                if CheckTestHer then 
                    HeritageWindow = true
                else 
                    HeritageWindow = false
                end
            end)
            if HeritageWindow then
                RageUI.HeritageWindow(List.index, List2.index) 
                RageUI.List("List Test Mère", List.Test, List.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                    List.index = Index
                end)
                RageUI.List("List Test Père", List2.Test, List2.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                    List2.index = Index
                end)
                RageUI.UISliderHeritage("Ressemblance", SliderTest, nil, function(Hovered, Selected, Active, Heritage, Index)
                    if Selected then 
                    
                    end
                    SliderTest = Index
                end, pourcentageHr)
                RageUI.UISliderHeritage("Teint de la peau", SliderTest2, nil, function(Hovered, Selected, Active, Heritage, Index)
                    if Selected then 
                    
                    end
                    SliderTest2 = Index
                end, pourcentageHr)
            end
        end)
    end  
end)

--[[KeySettings:Add("keyboard", "F5",function()

    RageUI.Visible(RMenu:Get('core', 'example'), true)

end, "Exemple")]]

RegisterCommand("Exemple", function()
    RageUI.Visible(RMenu:Get('core', 'example'), true)
end)