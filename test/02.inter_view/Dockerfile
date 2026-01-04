FROM postgres:15.13

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=123456
ENV POSTGRES_DB=db_test

# Copy migration scripts to be executed automatically on container startup
# COPY migrations/2025-10-11/*.sql /docker-entrypoint-initdb.d/
COPY 01.create_database.sql /docker-entrypoint-initdb.d/
COPY 02.insert-data.sql /docker-entrypoint-initdb.d/

EXPOSE 5432