FROM caddy:2.0.0-builder AS cbuild

#RUN caddy-builder github.com/hairyhenderson/caddyprom
RUN caddy-builder github.com/jopereira/caddyprom

FROM node:14 as nbuild

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY authcode-ui/package.json /app/package.json
RUN npm install

COPY authcode-ui/. /app
COPY env /app/.env
RUN npm run generate

FROM library/caddy:alpine

COPY --from=cbuild /usr/bin/caddy /usr/bin/caddy

WORKDIR /app

COPY --from=nbuild /app/dist .
RUN rm /app/README.md
COPY Caddyfile /etc/caddy/Caddyfile
