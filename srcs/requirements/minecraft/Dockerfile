FROM openjdk:17-jdk-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

# mc server.jar 1.21.6
RUN curl -L -o server.jar https://piston-data.mojang.com/v1/objects/6e64dcabba3c01a7271b4fa6bd898483b794c59b/server.jar

RUN echo "eula=true" > eula.txt

VOLUME ["/minecraft"]

EXPOSE 25565

CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
