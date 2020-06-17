FROM node:14 as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY authcode-ui/package.json /app/package.json
RUN npm install

COPY authcode-ui/. /app
COPY env /app/.env
RUN npm run generate

FROM alpine:latest as generator

ARG SSL_PATH=/etc/ssl

RUN set -eux; \
    apk update --no-cache; \
    apk add openssl; \
    mkdir -p "$SSL_PATH"; \
    openssl genrsa -des3 -passout pass:00000000 -out "${SSL_PATH}"/key.pem 2048; \
    cp "${SSL_PATH}"/key.pem "${SSL_PATH}"/key.pem.orig; \
    openssl rsa -passin pass:00000000 -in "${SSL_PATH}"/key.pem.orig -out "${SSL_PATH}"/key.pem; \
    openssl req -new -key "${SSL_PATH}"/key.pem -out "${SSL_PATH}"/cert.csr -subj "/C=PT/ST=PT/L=Braga/O=INESC TEC/OU=Research/CN=COVID-19"; \
    openssl x509 -req -days 3650 -in "${SSL_PATH}"/cert.csr -signkey "${SSL_PATH}"/key.pem -out "${SSL_PATH}"/cert.pem


FROM nginx:stable-alpine

RUN apk upgrade --no-cache

ARG SSL_PATH=/etc/ssl

COPY nginx/ /etc/nginx/
COPY --from=generator "${SSL_PATH}"/key.pem "${SSL_PATH}"/key.pem
COPY --from=generator "${SSL_PATH}"/cert.pem "${SSL_PATH}"/cert.pem

WORKDIR /app

COPY --from=build /app/dist .
RUN rm /app/README.md
