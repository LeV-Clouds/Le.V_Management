fx_version "adamant"
games { "gta5" };

name "RageUI";
description "Le.V_Core LUA"

client_scripts {
    "Rui/RMenu.lua", -- Lib Rui
    "Rui/menu/RageUI.lua",
    "Rui/menu/Menu.lua",
    "Rui/menu/MenuController.lua",
    "Rui/components/*.lua",
    "Rui/menu/elements/*.lua",
    "Rui/menu/items/*.lua",
    "Rui/menu/panels/*.lua",
    "Rui/menu/windows/*.lua",
    "coords.lua",
    "Manage_c.lua",
}

server_scripts {
    "@mysql-async/lib/MySql.lua",
    "Manage_s.lua",
}



