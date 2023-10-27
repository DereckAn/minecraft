
if (-not (java -version 2>&1 | Select-String "21.0.1")) {
    Write-Output "Java not found. Installing..."
    $installerPath = "$env:USERPROFILE\Downloads\jdk-21_windows-x64_bin.exe"
    Invoke-WebRequest -Uri "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe" -OutFile $installerPath
    Start-Process -FilePath $installerPath
} else {
    Write-Output "Java found."
}

if (-not (Test-Path "$env:APPDATA\.minecraft\versions\1.20.1-forge-47.1.0")) {
    Write-Output "Forge not found. Installing..."
    $installerPath2 = "$env:USERPROFILE\Downloads\forge-1.20.1-47.1.0-installer.jar"
    Invoke-WebRequest -Uri "https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar" -OutFile $installerPath2
    java -jar forge-1.20.1-47.1.0-installer.jar --installClient
    Start-Process -FilePath $installerPath2
} else {
    Write-Output "Forge found."
}

$links = @(
    "https://github.com/DereckAn/minecraft/blob/main/Mods/BiomesOPlenty-1.20.1-18.0.0.592.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/Dungeon%2BCrawl-1.20.1-2.3.14.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/DungeonsArise-1.20.1-2.1.56.1-beta.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/HopoBetterMineshaft-%5B1.20-1.20.1%5D-1.1.8.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/MutantMonsters-v8.0.2-1.20.1-Forge.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/Philips-Ruins1.20.1-1.4.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/PuzzlesLib-v8.0.7-1.20.1-Forge.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/Rex's-AdditionalStructures-1.20.x-(v.4.1.2).jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/TerraBlender-forge-1.20.1-3.0.0.169.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/TheHammerMod-1.20.1-beta3.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/Xaeros_Minimap_23.5.0_Forge_1.20.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/caelus-forge-3.1.0%2B1.20.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/citadel-2.4.2-1.20.1.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/colytra-forge-6.2.0%2B1.20.1.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/dungeons-and-taverns-2.0.2%2Bforge.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/explorations-forge-1.20.1-1.5.1.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/jei-1.20.1-forge-15.2.0.23.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/majrusz-library-1.20-4.3.2.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/repurposed_structures-7.0.0%2B1.20-forge.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/tlc_forge-1.0.3-R-1.20.X.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/u_team_core-forge-1.20.1-5.1.3.267.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/useful_backpacks-forge-1.20.1-2.0.1.121.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/vanillaplustools-1.20-1.0.jar",
    "https://github.com/DereckAn/minecraft/blob/main/Mods/L_Enders_Cataclysm-1.17-1.20.1(Latest%2BForge%2BOnly).jar"
)

$destination = "$env:APPDATA\.minecraft\mods"

if (-not (Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination
}

# Descarga mods
foreach ($link in $links) {
    $filename = Split-Path -Leaf $link
    $filepath = Join-Path -Path $destination -ChildPath $filename
    if (-not (Test-Path $filepath)) {
        Invoke-WebRequest -Uri $link -OutFile $filepath
    }
}