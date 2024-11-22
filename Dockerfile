# Use multi-stage builds to reduce the final image size

# Stage 1: Development and Build
FROM maven:3.8.1-jdk-11 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and run the tests
COPY src ./src

RUN mvn clean test && mvn clean package -DskipTests

# Stage 2: Production
FROM openjdk:11-jre-slim AS production
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/multi-stage-java-app-1.0.0.jar /app/app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
