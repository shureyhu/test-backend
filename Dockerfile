#FROM openjdk:11
#VOLUME /tmp
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","/app.jar"]


# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src /app/src
RUN mvn package -DskipTests

# Stage 2: Create the final image
FROM openjdk:11
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY --from=build /app/${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
