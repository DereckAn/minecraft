use std::fs;
use std::path::Path;
use std::process::Command;
use directories::UserDirs;
use reqwest;
use zip;
use std::env;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Bienvenido al Instalador de Mods de Minecraft!");

    // Paso 1: Detectar el sistema operativo
    let os = env::consts::OS;
    println!("Sistema operativo detectado: {}", os);

    // Paso 2: Instalar Git
    install_git(&os).await?;

    // Paso 3: Instalar Java
    install_java(&os).await?;

    // Paso 4: Descargar e instalar mods
    download_mods().await?;

    // Paso 5: Instalar Fabric
    install_fabric().await?;

    println!("¡Todo listo! Tu Minecraft está preparado para jugar con mods y Fabric!");
    Ok(())
}

async fn install_git(os: &str) -> Result<(), Box<dyn std::error::Error>> {
    println!("Verificando si Git está instalado...");
    
    let git_installed = Command::new("git").arg("--version").status().is_ok();

    if git_installed {
        println!("Git ya está instalado.");
    } else {
        println!("Git no está instalado. Instalando Git...");
        
        match os {
            "windows" => {
                Command::new("winget")
                    .args(&["install", "--id", "Git.Git", "-e", "--source", "winget"])
                    .status()?;
            },
            "macos" => {
                if !Command::new("brew").arg("--version").status().is_ok() {
                    println!("Homebrew no está instalado. Instalando Homebrew...");
                    let brew_install_script = "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"";
                    Command::new("sh")
                        .arg("-c")
                        .arg(brew_install_script)
                        .status()?;
                }
                Command::new("brew").args(&["install", "git"]).status()?;
            },
            "linux" => {
                Command::new("sudo")
                    .args(&["apt-get", "update"])
                    .status()?;
                Command::new("sudo")
                    .args(&["apt-get", "install", "-y", "git"])
                    .status()?;
            },
            _ => return Err("Sistema operativo no soportado".into()),
        }
        
        println!("Git ha sido instalado exitosamente.");
    }

    Ok(())
}

async fn install_java(os: &str) -> Result<(), Box<dyn std::error::Error>> {
    println!("Verificando si Java está instalado...");
    
    let java_installed = Command::new("java").arg("-version").status().is_ok();

    if java_installed {
        println!("Java ya está instalado.");
    } else {
        println!("Java no está instalado. Instalando Java...");
        
        match os {
            "windows" => {
                Command::new("winget").args(&["install", "Microsoft.OpenJDK.21"]).status()?;
            },
            "macos" => {
                Command::new("brew").args(&["install", "openjdk"]).status()?;
            },
            "linux" => {
                Command::new("sudo")
                    .args(&["apt-get", "update"])
                    .status()?;
                Command::new("sudo")
                    .args(&["apt-get", "install", "-y", "default-jdk"])
                    .status()?;
            },
            _ => return Err("Sistema operativo no soportado".into()),
        }
        
        println!("Java ha sido instalado exitosamente.");
    }

    Ok(())
}

async fn download_mods() -> Result<(), Box<dyn std::error::Error>> {
    println!("Downloading mods...");

    let mods_url = "https://github.com/DereckAn/minecraft/archive/refs/heads/main.zip";
    let response = reqwest::get(mods_url).await?;
    let mods_zip = response.bytes().await?;

    let user_dirs = UserDirs::new().ok_or("Failed to get user directories")?;
    let minecraft_dir = user_dirs.home_dir().join(".minecraft");
    let mods_dir = minecraft_dir.join("mods");

    fs::create_dir_all(&mods_dir)?;

    let mut zip = zip::ZipArchive::new(std::io::Cursor::new(mods_zip))?;

    for i in 0..zip.len() {
        let mut file = zip.by_index(i)?;
        let outpath = mods_dir.join(file.name());

        if file.name().ends_with('/') {
            fs::create_dir_all(&outpath)?;
        } else {
            if let Some(p) = outpath.parent() {
                if !p.exists() {
                    fs::create_dir_all(p)?;
                }
            }
            let mut outfile = fs::File::create(&outpath)?;
            std::io::copy(&mut file, &mut outfile)?;
        }
    }

    println!("Mods downloaded and installed successfully.");
    Ok(())
}

async fn install_fabric() -> Result<(), Box<dyn std::error::Error>> {
    println!("Installing Fabric...");

    let fabric_url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.11.2/fabric-installer-0.11.2.jar";
    let response = reqwest::get(fabric_url).await?;
    let fabric_installer = response.bytes().await?;

    let user_dirs = UserDirs::new().ok_or("Failed to get user directories")?;
    let downloads_dir = user_dirs.download_dir().ok_or("Failed to get downloads directory")?;
    let installer_path = downloads_dir.join("fabric-installer.jar");

    fs::write(&installer_path, fabric_installer)?;

    println!("Running Fabric installer...");
    let output = Command::new("java")
        .arg("-jar")
        .arg(&installer_path)
        .arg("client")
        .arg("-mcversion")
        .arg("1.21")
        .output()?;

    if output.status.success() {
        println!("Fabric installed successfully.");
    } else {
        println!("Failed to install Fabric. Please install it manually.");
    }

    Ok(())
}