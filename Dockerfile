# Build stage
FROM gradle:8.1-jdk AS build
RUN apt-get update && apt-get install -y openjdk-23-jdk
LABEL maintainer="codaholic.com"
WORKDIR /
COPY . /
RUN gradle clean bootJar

# Package stage
FROM amazoncorretto:23
COPY --from=build /target/libs/*.jar app.jar
EXPOSE 80
ENTRYPOINT ["java","-jar","app.jar"]