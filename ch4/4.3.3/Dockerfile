FROM azul/zulu-openjdk:21
LABEL description="Echo IP Java Application"
EXPOSE 80
RUN apt-get update -y && apt-get install git -y     \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/iac-sources/inbuilder.git
WORKDIR inbuilder
RUN chmod 700 mvnw \
    && ./mvnw clean package \
	&& mv target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]
