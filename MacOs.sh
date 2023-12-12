set javaVersion to do shell script "java -version 2>&1 | awk -F '\"' '/version/ {print $2}'"
if javaVersion does not contain "21.0.1" then
    display dialog "Java not found. Installing..." buttons {"OK"} default button 1
    do shell script "brew install openjdk@11"
else
    display dialog "Java found." buttons {"OK"} default button 1
end if

set forgePath to (path to home folder as text) & "Downloads:forge-1.20.1-47.1.0-installer.jar"
if not (exists folder (path to home folder as text) & ".minecraft:versions:1.20.1-forge-47.1.0") then
    display dialog "Forge not found. Installing..." buttons {"OK"} default button 1
    do shell script "curl -o " & quoted form of POSIX path of forgePath & " https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar"
    do shell script "java -jar " & quoted form of POSIX path of forgePath & " --installClient"
    do shell script "java -jar " & quoted form of POSIX path of forgePath
else
    display dialog "Forge found." buttons {"OK"} default button 1
end if

set links to {"https://github.com/DereckAn/minecraft/blob/main/difficul_af/BOMD-Forge-1.20.1-1.0.4.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/BiomesOPlenty-1.20.1-18.0.0.598.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/CreativeCore_FORGE_v2.11.11_mc1.20.1.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Dungeon%20Crawl-1.20.1-2.3.14.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/DungeonsArise-1.20.1-2.1.57-release.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/EnhancedVisuals_FORGE_v1.6.9_mc1.20.1.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/FallingTree-1.20.1-4.3.2.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HammersAndExcavators-1.1.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HopoBetterMineshaft-%5B1.20-1.20.1%5D-1.1.8.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/HopoBetterRuinedPortals-%5B1.20-1.20.1%5D-1.3.6.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/L_Enders_Cataclysm-1.39%20-1.20.1.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/MoreBows-CJ-forge-mc1.20x-1.5.1.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/MutantMonsters-v8.0.6-1.20.1-Forge.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/OnlyHammers-1.20.1-0.5-Forge.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Philips-Ruins1.20.1-2.7.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/PuzzlesLib-v8.1.11-1.20.1-Forge.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Rex's-AdditionalStructures-1.20.x-(v.4.1.2).jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/TerraBlender-forge-1.20.1-3.0.0.169.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/Terralith_1.20.1_v2.4.5.jar", "https://github.com/DereckAn/minecraft/blob/main/difficul_af/TheHammerMod-1.20.1-beta3.jar"}

repeat with link in links
    set fileName to last item of paragraphs of link
    set downloadPath to (path to home folder as text) & "Downloads:" & fileName
    do shell script "curl -o " & quoted form of POSIX path of downloadPath & " " & quoted form of link
end repeat