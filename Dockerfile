# Build stage: Use a Gradle image and manually install JDK 23
FROM gradle:8.11-jdk AS build

# Install dependencies and download OpenJDK 23
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://download.java.net/java/GA/jdk23.0.1/c28985cbf10d4e648e4004050f8781aa/11/GPL/openjdk-23.0.1_linux-x64_bin.tar.gz \
    && tar -xzf openjdk-23.0.1_linux-x64_bin.tar.gz -C /usr/local/ \
    && rm openjdk-23.0.1_linux-x64_bin.tar.gz

# Set JAVA_HOME to JDK 23
ENV JAVA_HOME=/usr/local/jdk-23
ENV PATH="${JAVA_HOME}/bin:${PATH}"

LABEL maintainer="codaholic.com"
WORKDIR /app
COPY . /app/

# Run Gradle build
RUN gradle clean bootJar

# Package stage: Use Amazon Corretto 23 for runtime
FROM amazoncorretto:23
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar"]
