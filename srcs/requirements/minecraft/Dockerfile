FROM openjdk:17-jdk-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y curl && \
    curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json \
    | grep -oP '"release":\s*"\K[^"]+' | head -1 > version.txt && \
    VERSION=$(cat version.txt) && \
    SERVER_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
    grep -A 10 "\"id\": \"$VERSION\"" | grep -oP '"url":\s*"\K[^"]+') && \
    SERVER_JAR_URL=$(curl -s $SERVER_URL | grep -oP '"server":\s*{\s*"sha1":\s*".*?",\s*"size":\s*\d+,\s*"url":\s*"\K[^"]+') && \
    curl -o server.jar $SERVER_JAR_URL && \
    rm -rf /var/lib/apt/lists/*

RUN echo "eula=true" > eula.txt

VOLUME ["/minecraft"]

EXPOSE 25565

CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
