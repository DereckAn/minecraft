#!/bin/bash

if ! java -version 2>&1 | grep -q "21.0.1"; then
    echo "Java not found. Installing..."
    sudo pacman -S jre-openjdk -y
    sudo pacman -S jdk-openjdk -y

    # installerPath="$HOME/Downloads/jdk-21_windows-x64_bin.exe"
    # wget -O "$installerPath" "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
    # wine "$installerPath"
else
    echo "Java found."
fi

if [ ! -d "$HOME/.minecraft/versions/1.20.1-forge-47.1.0" ]; then
    echo "Forge not found. Installing..."
    installerPath2="$HOME/Downloads/forge-1.20.1-47.1.0-installer.jar"
    wget -O "$installerPath2" "https://adfoc.us/serve/sitelinks/?id=271228&url=https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.2.0/forge-1.20.1-47.2.0-installer.jar"
    java -jar "$installerPath2" --installClient
    java -jar "$installerPath2"
else
    echo "Forge found."
fi

links=(
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/BOMD-Forge-1.20.1-1.0.4.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/BiomesOPlenty-1.20.1-18.0.0.598.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/CreativeCore_FORGE_v2.11.11_mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Dungeon%20Crawl-1.20.1-2.3.14.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/DungeonsArise-1.20.1-2.1.57-release.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/EnhancedVisuals_FORGE_v1.6.9_mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/FallingTree-1.20.1-4.3.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HammersAndExcavators-1.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HopoBetterMineshaft-%5B1.20-1.20.1%5D-1.1.8.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HopoBetterRuinedPortals-%5B1.20-1.20.1%5D-1.3.6.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/L_Enders_Cataclysm-1.39%20-1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/MoreBows-CJ-forge-mc1.20x-1.5.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/MutantMonsters-v8.0.6-1.20.1-Forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/OnlyHammers-1.20.1-0.5-Forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Philips-Ruins1.20.1-2.7.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/PuzzlesLib-v8.1.11-1.20.1-Forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Rex's-AdditionalStructures-1.20.x-(v.4.1.2).jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/TerraBlender-forge-1.20.1-3.0.0.169.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Terralith_1.20.1_v2.4.5.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/TheHammerMod-1.20.1-beta3.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Weeping-Angels-46.0.1-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Xaeros_Minimap_23.9.3_Forge_1.20.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/YungsApi-1.20-Forge-4.0.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/YungsBetterEndIsland-1.20-Forge-2.0.4.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/YungsBetterNetherFortresses-1.20-Forge-2.0.5.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/badpackets-forge-0.4.3.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/balm-forge-1.20.1-7.1.4.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/caelus-forge-3.1.0%2B1.20.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/citadel-2.4.9-1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/cloth-config-11.1.106-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/colytra-forge-6.2.2%2B1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/connectedglass-1.1.9-forge-mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/creeperoverhaul-3.0.1-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/cupboard-1.20.1-2.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/dungeons-and-taverns-v2.1.4%20%5BForge%5D.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/dungeons_1.16.1_mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/explorations-forge-1.20.1-1.5.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/explorify-v1.3.0-mc1.20u1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/fusion-1.1.0b-forge-mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/geckolib-forge-1.20.1-4.3.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/gravestone-1.20.1-1.0.10.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/improvedmobs-1.20.1-1.11.6-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/imst-2.1.0.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/invhud.forge.1.20.1-3.4.18.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/jei-1.20.1-forge-15.2.0.27.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/majrusz-library-forge-1.20.1-7.0.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/majruszs-difficulty-forge-1.20.1-1.9.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/repurposed_structures-7.1.11%2B1.20.1-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/resourcefulconfig-forge-1.20.1-2.1.0.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/spore_1.20.1_2.0.0b.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/structureessentials-1.20.1-3.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/supermartijn642corelib-1.1.16-forge-mc1.20.1.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/tenshilib-1.20.1-1.7.2-forge.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/u_team_core-forge-1.20.1-5.1.4.269.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/useful_backpacks-forge-1.20.1-2.0.1.122.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/waystones-forge-1.20-14.0.2.jar"
    "https://github.com/DereckAn/minecraft/blob/main/difficul_af/wthit-forge-8.4.3.jar"
)

destination="$HOME/.minecraft/mods"

if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
fi

# Download mods
for link in "${links[@]}"; do
    filename=$(basename "$link")
    filepath="$destination/$filename"
    if [ ! -f "$filepath" ]; then
        wget -O "$filepath" "$link"
    fi
done

echo "Go and play minecraft nino rata"
