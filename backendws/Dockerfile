FROM openjdk:11.0.9 AS build

RUN apt-get update && apt-get install -y maven
WORKDIR /build/
COPY dp3t-sdk-backend /build
RUN sed -i '/.*injectAllReactorProjects.*/i <skip>true</skip>' /build/dpppt-backend-sdk/pom.xml
RUN mvn -f dpppt-backend-sdk package -Dmaven.test.skip=true

FROM openjdk:11.0.9-jre-slim

RUN useradd app
WORKDIR /app/

COPY --from=build /build/dpppt-backend-sdk/dpppt-backend-sdk-ws/target/dpppt-backend-sdk-ws.jar dpppt-backend-sdk-ws.jar
COPY logback.xml /app/logback.xml
COPY application.properties /app/application.properties

COPY entrypoint.sh /app

RUN chown -R app /app

USER app
EXPOSE 8080

ENTRYPOINT /app/entrypoint.sh
