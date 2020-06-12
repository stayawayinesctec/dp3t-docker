#!/usr/bin/env bash

sleep 5 && DATA_SOURCE_NAME="postgresql://${POSTGRES_USER}@localhost:5432/${POSTGRES_DB}?sslmode=disable" prometheus-postgres-exporter &

exec /docker-entrypoint.sh $*
