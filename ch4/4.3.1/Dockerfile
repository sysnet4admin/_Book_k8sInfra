FROM azul/zulu-openjdk:21
LABEL description="Echo IP Java Application"
EXPOSE 80
COPY ./target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]
