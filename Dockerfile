# Build stage
FROM gradle:8.11-jdk AS build
LABEL maintainer="codaholic.com"
WORKDIR /
COPY . /
RUN gradle clean bootJar

# Package stage
FROM amazoncorretto:23
COPY --from=build /target/libs/*.jar app.jar
EXPOSE 80
ENTRYPOINT ["java","-jar","app.jar"]