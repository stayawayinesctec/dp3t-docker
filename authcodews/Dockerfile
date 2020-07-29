FROM openjdk:11.0.7 AS build

RUN apt-get update && apt-get install -y maven
WORKDIR /build/
COPY CovidCode-Service-build /build
RUN mvn package -Dmaven.test.skip=true

FROM openjdk:11.0.7-jre-slim

RUN useradd app
WORKDIR /app/

COPY --from=build /build/target/ha-authcode-generation-service.jar .
COPY ./logback.xml ./application.yml /app/
RUN chown -R app:app /app

COPY entrypoint.sh /app

USER app
EXPOSE 8113

ENTRYPOINT /app/entrypoint.sh
