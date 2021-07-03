Creates a Keycloak instance which uses the local sql server container image as the backend. Very useful for testing a 'real' DB backend and then move onto REST API automation and setups etc etc.. as the local DB will not be persisted on restarts. Still to do the API part but now it should be possible to use REST calls or something like Terraform to automate the creation of a complete system.

# Docker Build SQL Image

We have to create a SQL container which on startup creates a SQL DB called Keycloak or else Keycloak will not start. The custom image based off the Microsoft SQL Server image does this for us via a script.

https://github.com/twright-msft/mssql-node-docker-demo-app

Build the image like so. But, the compose file uses the plain Keycloak image as we dont really care for testing.

```
docker build -f dockerfile-keycloak-and-updates -t keycloak-updated:10.0.2 .
```

# Docker Build Keycloak Image

The keycloak 10.0.2 image, for example, does not include software updates, so we can create a base container and then update it ourselves. Build like so;

```
docker build -f dockerfile-mssql-keycloak -t mssql-keycloak:latest .
```

## Running

The docker compose needs a network setup so both services can see each other.

```
docker-compose -f "Keycloak\docker-compose.yml" up -d --build
```

WEB: http://localhost:8080
SQL: localhost:1433
