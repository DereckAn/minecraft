#!/bin/sh

echo "What is your OS? (Enter 1 for macOS, 2 for Linux, or 3 for Windows)"
read os

while [ "$os" != "1" ] && [ "$os" != "2" ] && [ "$os" != "3" ]; do
    echo "Please enter 1 for macOS, 2 for Linux, or 3 for Windows."
    read os
done

# NOTE: Dejar este if para que corrobore si tiene git installado. 
if [ $os = "1" ]; then 
    echo "You have selected macOS"
    if ! which brew >/dev/null; then # check if Homebrew is already installed
        echo "Homebrew not found. Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew found."
    fi
    if ! which git >/dev/null; then
        echo "Git not found. Installing..."
        brew install git
    else
        echo "Git found."
    fi


    if [ -d "$HOME/.java" ]; then # note: Check if Java JDK Development Kit 21.0.1 is already installed
        echo "Java already installed"
    else
        echo "Installing Java - JDK Development Kit 21.0.1"
        sh -c "$(curl -fsSL https://download.oracle.com/java/21/latest/jdk-21_macos-x64_bin.tar.gz)" &
        wait

        if [ $? -eq 0 ]; then # note: check if last command was successful
            echo "Successfully JDK Development Kit 21.0.1"
        else
            echo "Error installing JDK Development Kit 21.0.1"
        fi
    fi


    if [ -d "$HOME/.minecraft/versions/forge" ]; then # note: Check if Minecraft Forge is already installed
        echo "Forge Minecraft ya está instalado"
    else
        echo "Descargando e instalando Forge Minecraft 1.20.1-47-1-0"
        curl -LJO https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar && java -jar forge-1.20.1-47.1.0-installer.jar --installClient &
        wait

        if [ $? -eq 0 ]; then # note: check if last command was successful
            echo "Minecraft Forge instalado con éxito"
        else
            echo "Error al instalar Forge"
        fi
    fi



    if [ $? -eq 0 ]; then 
        echo "Installing Minecraft mods"
        # Lista de enlaces a descargar
        links=(
            "https://github.com/DereckAn/minecraft/blob/main/Mods/BiomesOPlenty-1.20.1-18.0.0.592.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/Dungeon%2BCrawl-1.20.1-2.3.14.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/DungeonsArise-1.20.1-2.1.56.1-beta.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/HopoBetterMineshaft-%5B1.20-1.20.1%5D-1.1.8.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/MutantMonsters-v8.0.2-1.20.1-Forge.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/Philips-Ruins1.20.1-1.4.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/PuzzlesLib-v8.0.7-1.20.1-Forge.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/Rex's-AdditionalStructures-1.20.x-(v.4.1.2).jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/TerraBlender-forge-1.20.1-3.0.0.169.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/TheHammerMod-1.20.1-beta3.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/Xaeros_Minimap_23.5.0_Forge_1.20.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/caelus-forge-3.1.0%2B1.20.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/citadel-2.4.2-1.20.1.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/colytra-forge-6.2.0%2B1.20.1.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/dungeons-and-taverns-2.0.2%2Bforge.jar"   
            "https://github.com/DereckAn/minecraft/blob/main/Mods/explorations-forge-1.20.1-1.5.1.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/jei-1.20.1-forge-15.2.0.23.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/majrusz-library-1.20-4.3.2.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/repurposed_structures-7.0.0%2B1.20-forge.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/tlc_forge-1.0.3-R-1.20.X.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/u_team_core-forge-1.20.1-5.1.3.267.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/useful_backpacks-forge-1.20.1-2.0.1.121.jar"
            "https://github.com/DereckAn/minecraft/blob/main/Mods/vanillaplustools-1.20-1.0.jar"
        )

        # Carpeta de destino para los archivos descargados
        destination="$HOME/Library/Application Support/minecraft/mods"
        # & tambien puedes ser esta direccion por si acaso /Applications/Minecraft/Library/Application Support/minecraft/mods

         # Verifica si la carpeta de destino existe, si no, créala
        if [ ! -d "$destination" ]; then
            mkdir -p "$destination"
        fi

        # Iterar sobre los enlaces y descargar cada archivo
        for link in "${links[@]}"
        do
            # Extraer el nombre del archivo del enlace
            filename=$(basename "$link")

            # Descargar el archivo utilizando curl
            curl -LJO "$link" -o "$destination/$filename"
        done

    else 
        echo "Error installing Minecraft mods"
    fi





elif [ $os = "2" ]; then
    echo "You have selected Linux"

    if ! which git >/dev/null; then
        echo "Git not found. Installing..."
        sudo apt-get update
        sudo apt-get install git -y
    else
        echo "Git found."
    fi

    if ! java -version 2>&1 | grep "21.0.1" > /dev/null; then
        echo "Java not found. Installing..."
        sudo apt-get update 
        sudo apt-get install openjdk-17-jdk -y
    else
        echo "Java found."
    fi

    if [ ! -d "$HOME/.minecraft/versions/forge" ]; then
        echo "Forge not found. Installing..."
        curl -LJO https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar
        java -jar forge-1.20.1-47.1.0-installer.jar --installClient
    else
        echo "Forge found."
    fi

  # Lista de enlaces a mods
    links=(
        "https://github.com/mod1.jar"
        "https://github.com/mod2.jar"
    )

  # Carpeta de destino 
    destination="$HOME/.minecraft/mods"

    if [ ! -d "$destination" ]; then
        mkdir -p "$destination"
    fi

  # Descarga mods
    for link in "${links[@]}"; do
        filename=$(basename "$link")
        curl -LJO "$link" -o "$destination/$filename" 
    done






elif [ $os = "3" ]; then

    echo "You have selected Windows"

    if not exist "C:\Program Files\git" (
        echo "Git not found. Installing..."
        choco install git -y
    ) else (
        echo "Git found."
    )

    if not java -version 2>&1 | findstr "21.0.1" >nul then
        echo "Java not found. Installing..."
        curl -LO https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe
    ) else (
        echo "Java found."  
    )

    if not exist "%APPDATA%\.minecraft\versions\forge" (
        echo "Forge not found. Installing..." 
        curl -LO https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar
        java -jar forge-1.20.1-47.1.0-installer.jar --installClient
    ) else (
        echo "Forge found."
    )

    # rem Lista de enlaces a mods
    # maybe there is a problem with the last link 
    set links=(
        "https://github.com/DereckAn/minecraft/blob/main/Mods/BiomesOPlenty-1.20.1-18.0.0.592.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/Dungeon%2BCrawl-1.20.1-2.3.14.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/DungeonsArise-1.20.1-2.1.56.1-beta.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/HopoBetterMineshaft-%5B1.20-1.20.1%5D-1.1.8.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/MutantMonsters-v8.0.2-1.20.1-Forge.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/Philips-Ruins1.20.1-1.4.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/PuzzlesLib-v8.0.7-1.20.1-Forge.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/Rex's-AdditionalStructures-1.20.x-(v.4.1.2).jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/TerraBlender-forge-1.20.1-3.0.0.169.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/TheHammerMod-1.20.1-beta3.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/Xaeros_Minimap_23.5.0_Forge_1.20.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/caelus-forge-3.1.0%2B1.20.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/citadel-2.4.2-1.20.1.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/colytra-forge-6.2.0%2B1.20.1.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/dungeons-and-taverns-2.0.2%2Bforge.jar"   
        "https://github.com/DereckAn/minecraft/blob/main/Mods/explorations-forge-1.20.1-1.5.1.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/jei-1.20.1-forge-15.2.0.23.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/majrusz-library-1.20-4.3.2.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/repurposed_structures-7.0.0%2B1.20-forge.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/tlc_forge-1.0.3-R-1.20.X.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/u_team_core-forge-1.20.1-5.1.3.267.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/useful_backpacks-forge-1.20.1-2.0.1.121.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/vanillaplustools-1.20-1.0.jar"
        "https://github.com/DereckAn/minecraft/blob/main/Mods/L_Enders_Cataclysm-1.17-1.20.1(Latest%2BForge%2BOnly).jar"
    )

    # rem Destination folder
    # to install mods in minecraft you need to go to the mods folder in the .minecraft this is the whlo path "C:\Users\Pito de Abuelo\AppData\Roaming\.minecraft\mods" in my case
    set destination = "%APPDATA%\.minecraft\mods"  

    if not exist "%destination%" (
        mkdir "%destination%"
    )

    # rem Descarga mods
    for %%link in %links% do (
        set filename=%%~nxlink
        curl -LO "%%link" -o "%destination%\!filename!"
    )

fi