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
    local fabric_installer="fabric-installer.jar"
    local minecraft_dir

    if [[ "$OSTYPE" == "darwin"* ]]; then
        minecraft_dir="$HOME/Library/Application Support/minecraft"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        minecraft_dir="$HOME/.minecraft"
    fi

    echo "Descargando el instalador de Fabric más reciente..."
    cd ~/Downloads
    curl -OJ "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar"
    mv fabric-installer-*.jar "$fabric_installer"

    echo "Instalando Fabric para Minecraft $minecraft_version..."
    java -jar "$fabric_installer" client -mcversion $minecraft_version -dir "$minecraft_dir"

    if [ $? -eq 0 ]; then
        echo "Fabric se ha instalado correctamente para Minecraft $minecraft_version."
    else
        echo "Hubo un error al instalar Fabric. Por favor, verifica la versión de Minecraft y vuelve a intentarlo."
    fi

    rm "$fabric_installer"
}

# Ejecutar funciones
if [[ "$OSTYPE" == "darwin"* ]]; then
    verificar_e_instalar_homebrew
fi
verificar_e_instalar_git
verificar_e_instalar_java
descargar_y_configurar_mods
instalar_fabric