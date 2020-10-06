FROM gcr.io/distroless/java:8
LABEL description="Echo IP Java Application"
EXPOSE 60432
COPY ./target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]