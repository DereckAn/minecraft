#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_git_installation() {
        // Este test podría verificar si git está instalado después de llamar a la función
        assert!(Command::new("git").arg("--version").status().is_ok());
    }

    #[test]
    fn test_java_installation() {
        // Similar al test de git
        assert!(Command::new("java").arg("-version").status().is_ok());
    }

    #[test]
    fn test_mods_directory_creation() {
        // Este test podría verificar si el directorio de mods se crea correctamente
        let user_dirs = UserDirs::new().unwrap();
        let minecraft_dir = user_dirs.home_dir().join(".minecraft");
        let mods_dir = minecraft_dir.join("mods");
        assert!(mods_dir.exists());
    }
}