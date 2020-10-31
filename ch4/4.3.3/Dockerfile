FROM openjdk:8
LABEL description="Echo IP Java Application"
EXPOSE 60433
RUN git clone https://github.com/iac-source/inbuilder.git
WORKDIR inbuilder
RUN chmod 700 mvnw
RUN ./mvnw clean package
RUN mv target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]