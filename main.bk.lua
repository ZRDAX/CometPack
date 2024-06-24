local utils = require("utils")
local lfs = require("lfs")

local repository = "repository/"
local install_dir = "/usr/local/my_packages/"

local function compile_package(package_path)
    local command = string.format("cd %s && make && sudo make install", package_path)
    return os.execute(command)
end

local function install_package(package_name)
    local package_file = repository .. package_name .. ".tar.gz"
    print("Verificando local do pacote: " .. package_file)
    if not lfs.attributes(package_file) then
        print("Pacote não encontrado: " .. package_file)
        return
    end

    utils.create_dir(install_dir)
    utils.unzip(package_file, install_dir)

    local package_path = install_dir .. package_name
    if lfs.attributes(package_path .. "/Makefile") then
        print("Compilando pacote: " .. package_name)
        compile_package(package_path)
    end

    print("Pacote instalado: " .. package_name)
end

local function remove_package(package_name)
    local package_path = install_dir .. package_name
    if not lfs.attributes(package_path) then
        print("Pacote não encontrado: " .. package_name)
        return
    end

    utils.delete_dir(package_path)
    print("Pacote removido: " .. package_name)
end

local function list_installed_packages()
    for dir in lfs.dir(install_dir) do
        if dir ~= "." and dir ~= ".." then
            print(dir)
        end
    end
end

-- Main execution
local action = arg[1]
local package_name = arg[2]

if action == "install" and package_name then
    install_package(package_name)
elseif action == "remove" and package_name then
    remove_package(package_name)
elseif action == "list" then
    list_installed_packages()
else
    print("Usage: lua main.lua [install|remove|list] [package_name]")
end
