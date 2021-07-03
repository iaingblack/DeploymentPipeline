docker-compose -f "Keycloak\docker-compose.yml" up -d --build

docker run -e KEYCLOAK_USER=<USERNAME> -e KEYCLOAK_PASSWORD=<PASSWORD> jboss/keycloak

docker run -e KEYCLOAK_USER=<USERNAME> -e KEYCLOAK_PASSWORD=<PASSWORD> \
 -e KEYCLOAK_IMPORT=/tmp/example-realm.json -v /tmp/example-realm.json:/tmp/example-realm.json jboss/

docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password!23' -d --name mssql --net keycloak-network mcr.microsoft.com/mssql/server

docker run -d --name mssql-scripts --net keycloak-network mcr.microsoft.com/mssql-tools /bin/bash -c 'until /opt/mssql-tools/bin/sqlcmd -S mssql -U sa -P "Password!23" -Q "create database Keycloak"; do sleep 5; done'

docker run --name keycloak --net keycloak-network -p 8080:8080 -e DB_VENDOR=mssql -e DB_USER=sa -e DB_PASSWORD=Password!23 -e DB_ADDR=mssql -e DB_DATABASE=Keycloak -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin jboss/keycloak

/opt/mssql/bin/sqlservr.sh & /usr/src/app/import-data.sh & npm start 