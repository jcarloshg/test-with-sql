FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=123456
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=123456
ENV MYSQL_DATABASE=db_for_commands

# Copy migration scripts to be executed automatically on container startup
COPY ./*.sql /docker-entrypoint-initdb.d/

EXPOSE 3306