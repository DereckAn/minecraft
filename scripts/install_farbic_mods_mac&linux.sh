#!/bin/bash
# This is script is not tested yet

# Funciones reutilizables para verificar e instalar dependencias
verificar_e_instalar_homebrew() {
    if ! which brew >/dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew found."
    fi
}

verificar_e_instalar_git() {
    if ! command -v git &> /dev/null; then
        echo "Git no está instalado. Instalándolo..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install git
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update && sudo apt install git -y
        fi
    else
        echo "Git found."
    fi
}

verificar_e_instalar_java() {
    if ! type -p java > /dev/null; then
        echo "Java no está instalado. Instalando la última versión de Java..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install openjdk
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update && sudo apt install default-jdk -y
        fi
    else
        echo "Java found."
    fi
}

# Función para descargar y configurar mods
descargar_y_configurar_mods() {
    local mods_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        mods_dir="$HOME/Library/Application Support/minecraft/mods"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        mods_dir="$HOME/.minecraft/mods"
    fi

    # Eliminar carpeta mods si existe y crear carpeta temporal
    rm -rf $HOME/Downloads/mods
    mkdir -p $HOME/Downloads/temp && cd $_

    # Descargar mods
    git init
    git remote add origin https://github.com/DereckAn/minecraft.git
    git config core.sparseCheckout true
    git sparse-checkout set mods
    git pull origin main

    # Mover mods y limpiar
    mkdir -p "$mods_dir"
    mv mods/* "$mods_dir"
    cd .. && rm -rf temp
}

# Función para instalar Fabric
instalar_fabric() {
    local minecraft_version="1.21"
    local fabric_version="0.14.21"
    local fabric_installer="fabric-installer-$fabric_version.jar"
    local minecraft_dir

    if [[ "$OSTYPE" == "darwin"* ]]; then
        minecraft_dir="$HOME/Library/Application Support/minecraft"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        minecraft_dir="$HOME/.minecraft"
    fi

    if [ ! -d "$minecraft_dir/versions/${minecraft_version}-fabric-loader-${fabric_version}" ]; then
        echo "Fabric $fabric_version para Minecraft $minecraft_version no está instalado. Procediendo con la instalación..."
        cd ~/Downloads
        curl -OJ "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${fabric_version}/fabric-installer-${fabric_version}.jar"
        java -jar "$fabric_installer" client -mcversion $minecraft_version
        rm "$fabric_installer"
    else
        echo "Fabric ${fabric_version} para Minecraft ${minecraft_version} ya está instalado."
    fi
}

# Ejecutar funciones
if [[ "$OSTYPE" == "darwin"* ]]; then
    verificar_e_instalar_homebrew
fi
verificar_e_instalar_git
verificar_e_instalar_java
descargar_y_configurar_mods
instalar_fabric