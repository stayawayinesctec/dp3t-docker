FROM node:14 as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY authcode-ui/package.json /app/package.json
RUN npm install

COPY authcode-ui/. /app
COPY env /app/.env
RUN npm run generate

FROM golang:alpine as generator

ARG LEGO_VERSION=v3.7.0
ENV SSL_PATH=/etc/ssl/app

RUN set -eux; \
    apk update --no-cache; \
    apk add --no-cache openssl git; \
    mkdir -p "$SSL_PATH"; \
    openssl genrsa -des3 -passout pass:00000000 -out "${SSL_PATH}"/app.key 2048; \
    cp "${SSL_PATH}"/app.key "${SSL_PATH}"/app.key.orig; \
    openssl rsa -passin pass:00000000 -in "${SSL_PATH}"/app.key.orig -out "${SSL_PATH}"/app.key; \
    openssl req -new -key "${SSL_PATH}"/app.key -out "${SSL_PATH}"/app.csr -subj "/C=PT/ST=PT/L=Braga/O=INESC TEC/OU=Research/CN=COVID-19"; \
    openssl x509 -req -days 3650 -in "${SSL_PATH}"/app.csr -signkey "${SSL_PATH}"/app.key -out "${SSL_PATH}"/app.crt

RUN git clone https://github.com/go-acme/lego.git

WORKDIR /go/lego
RUN set -eux; \
    git checkout tags/"${LEGO_VERSION}" -b stable; \
    go build -ldflags="-w -s" -o lego.bin ./cmd/lego

FROM nginx:stable-alpine

RUN apk upgrade --no-cache

ENV SSL_PATH=/etc/ssl/app
ENV DOMAINS localhost
ENV EMAIL me@example.com

COPY nginx/ /etc/nginx/
COPY --from=generator "${SSL_PATH}"/app.key "${SSL_PATH}"/app.key
COPY --from=generator "${SSL_PATH}"/app.crt "${SSL_PATH}"/app.crt
COPY --from=generator /go/lego/lego.bin /usr/local/bin/lego
COPY run.sh /usr/local/bin/run.sh

WORKDIR /app

COPY --from=build /app/dist .

CMD ["/usr/local/bin/run.sh"]