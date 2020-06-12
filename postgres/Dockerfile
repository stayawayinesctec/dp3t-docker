FROM library/postgres:12

RUN apt-get update && apt-get -y install prometheus-postgres-exporter && apt-get clean
ADD pre-entry.sh /

ENTRYPOINT [ "/pre-entry.sh" ]
CMD [ "postgres" ]
