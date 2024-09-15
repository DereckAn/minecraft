# Usamos una imagen base de Java
FROM openjdk:21-slim

# Instalamos las herramientas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Creamos un directorio para el servidor
WORKDIR /minecraft_fabric_server_1.21

# Descargamos el ejecutable del servidor Fabric
RUN curl -OJ https://meta.fabricmc.net/v2/versions/loader/1.21/0.16.5/1.0.1/server/jar

# Aceptamos el EULA
RUN echo "eula=true" > eula.txt

# Exponemos el puerto del servidor
EXPOSE 25565

# Comando para iniciar el servidor
CMD ["sh", "-c", "java -Xmx24G -jar fabric-server-mc.1.21-loader.0.16.5-launcher.1.0.1.jar nogui"]