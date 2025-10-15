FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=123456
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=123456
ENV MYSQL_DATABASE=db_for_commands

# Copy migration scripts to be executed automatically on container startup
# COPY ./*.sql /docker-entrypoint-initdb.d/

COPY 01.create_database_and_tables.sql /docker-entrypoint-initdb.d/01.create_database_and_tables.sql
COPY 02.insert-data.sql /docker-entrypoint-initdb.d/02.insert-data.sql

EXPOSE 3306