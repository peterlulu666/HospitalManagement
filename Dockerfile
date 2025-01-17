# Use the official Maven image as the build environment
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the build environment
WORKDIR /app

# Copy the pom.xml file to the build environment
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline -B

# Copy the source code to the build environment
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Use the Eclipse Temurin JDK 17 Alpine image as the base image for the final container
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory in the final container
WORKDIR /app

# Copy the built JAR file from the build environment
COPY --from=build /app/target/hospital-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port on which your Spring Boot application listens
EXPOSE 8080

# Set the command to run your application
ENTRYPOINT ["java", "-jar", "app.jar"]