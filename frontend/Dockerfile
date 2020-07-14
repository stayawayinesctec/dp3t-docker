FROM node:14 as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY authcode-ui/package.json authcode-ui/package-lock.json /app/
RUN npm install

COPY authcode-ui/. /app
COPY env /app/.env
RUN npm run generate

FROM library/caddy:alpine

WORKDIR /app

COPY --from=build /app/dist .
RUN rm /app/README.md
COPY Caddyfile /etc/caddy/Caddyfile
