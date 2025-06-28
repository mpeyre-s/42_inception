FROM openjdk:17-jdk-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y curl && \
	echo "Downloading version manifest..." && \
	curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json \
	| grep -oP '"release":\s*"\K[^"]+' | head -1 > version.txt && \
	echo "Minecraft version fetched: $(cat version.txt)" && \
	VERSION=$(cat version.txt) && \
	echo "Fetching version manifest URL..." && \
	SERVER_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
	grep -A 10 "\"id\": \"$VERSION\"" | grep -oP '"url":\s*"\K[^"]+') && \
	echo "Version manifest: $SERVER_URL" && \
	echo "Fetching server URL..." && \
	SERVER_JAR_URL=$(curl -s $SERVER_URL | grep -oP '"server":\s*{\s*"sha1":\s*".*?",\s*"size":\s*\d+,\s*"url":\s*"\K[^"]+') && \
	echo "Downloading Minecraft server..." && \
	curl -o server.jar $SERVER_JAR_URL && \
	echo "Cleaning up..." && \
	rm -rf /var/lib/apt/lists/*

RUN echo "eula=true" > eula.txt

VOLUME ["/minecraft"]

EXPOSE 25565

CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
