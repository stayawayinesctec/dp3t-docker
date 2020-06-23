#!/usr/bin/env bash

# file_env function from: https://github.com/docker-library/postgres
#-----
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}
#-----

file_env JWTTOKEN_PRIVATE
file_env DB_USER
file_env DB_PASSWORD

exec java -jar $JAVA_OPTS -Dlogging.config=/app/logback.xml -Dspring.config.location=/app/application.yml /app/ha-authcode-generation-service.jar
