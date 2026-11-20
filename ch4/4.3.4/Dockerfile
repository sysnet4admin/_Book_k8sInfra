FROM azul/zulu-openjdk:21 AS int-build
RUN apt-get update -y && apt-get install git -y     \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/iac-sources/inbuilder.git
WORKDIR inbuilder
RUN chmod 700 mvnw \
    && ./mvnw clean package

FROM gcr.io/distroless/java21-debian12
LABEL description="Echo IP Java Application"
EXPOSE 80
COPY --from=int-build inbuilder/target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]
