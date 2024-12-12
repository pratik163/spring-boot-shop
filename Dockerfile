# Build stage: Use a Gradle image and manually install JDK 23
FROM gradle:8.11-jdk AS build

# Install JDK 23 in the build container
RUN apt-get update && apt-get install -y openjdk-23-jdk && rm -rf /var/lib/apt/lists/*

LABEL maintainer="codaholic.com"
WORKDIR /app
COPY . /app/

# Set JAVA_HOME to JDK 23
ENV JAVA_HOME=/usr/lib/jvm/java-23-openjdk-amd64

# Run Gradle build
RUN gradle clean bootJar

# Package stage: Use Amazon Corretto 23 for runtime
FROM amazoncorretto:23
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar"]
