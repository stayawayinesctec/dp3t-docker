FROM node:14 as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY CovidCode-UI/package.json /app/package.json
RUN npm install
RUN npm install -g @angular/cli@7.3.9
COPY CovidCode-UI/. /app
COPY environment.prod.ts src/environments/
RUN ng build --output-path=dist --configuration=production

FROM library/caddy:alpine

WORKDIR /app

COPY --from=build /app/dist .
COPY Caddyfile /etc/caddy/Caddyfile
