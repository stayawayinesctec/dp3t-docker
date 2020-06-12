FROM registry.access.redhat.com/ubi8-minimal AS build

RUN microdnf update -y && microdnf install -y git java-11-openjdk-headless && microdnf clean all
RUN git clone https://github.com/aerogear/keycloak-metrics-spi.git /build

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-11.0.7.10-1.el8_1.x86_64/
WORKDIR /build/

RUN ./gradlew jar

FROM jboss/keycloak

COPY --from=build /build/build/libs/keycloak-metrics-spi-2.0.2-SNAPSHOT.jar /opt/jboss/keycloak/providers/

COPY create.sh /opt/jboss/startup-scripts/
