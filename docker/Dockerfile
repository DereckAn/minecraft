# Usamos una imagen base de Java
FROM openjdk:17-slim

# Establecemos variables de entorno actualizadas
ENV MINECRAFT_VERSION=1.21
ENV FABRIC_LOADER_VERSION=0.16.5
ENV LAUNCHER_VERSION=1.0.1
ENV MINECRAFT_JAR=fabric-server-mc.${MINECRAFT_VERSION}-loader.${FABRIC_LOADER_VERSION}-launcher.${LAUNCHER_VERSION}.jar
ENV MINECRAFT_RAM=50G

# Instalamos las herramientas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Creamos un directorio para el servidor
WORKDIR /minecraft_fabric_server_1.21

# Descargamos el ejecutable del servidor Fabric
RUN curl -OJ https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${LAUNCHER_VERSION}/server/jar

# Aceptamos el EULA
RUN echo "eula=true" > eula.txt

# Exponemos el puerto del servidor
EXPOSE 25565

# Comando para iniciar el servidor
# CMD ["sh", "-c", "java -Xmx${MINECRAFT_RAM} -Xms${MINECRAFT_RAM} -jar ${MINECRAFT_JAR} nogui"]
CMD ["sh", "-c", "java -Xmx${MINECRAFT_RAM} -jar ${MINECRAFT_JAR} nogui"]