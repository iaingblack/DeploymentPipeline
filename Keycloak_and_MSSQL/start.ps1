# Build the containers
Write-Host "-----------------------------------------------------"
Write-Host "Building Containers"
Write-Host "-----------------------------------------------------"
docker build -f dockerfile-mssql-keycloak -t mssql-keycloak:latest .

# Start Keycloak and MSSQL
# https://github.com/docker/compose/issues/5222
Write-Host "-----------------------------------------------------"
Write-Host "Starting Docker Containers"
Write-Host "-----------------------------------------------------"
docker-compose -f "docker-compose.yml" up -d --build 2>&1 | %{ "$_" }
$attempts = 10
$repeat = $true
while ($true) {
    $attempts--
    $alive = invoke-webrequest http://localhost:8080 -DisableKeepAlive -UseBasicParsing -ErrorAction SilentlyContinue
    if ($alive.StatusCode -eq '200') { break }
    else {
        if ($attempts -gt 0) { Start-sleep 5; Write-Host "Waiting for Keycloak to start.. $attempts attempts remaining" }
        else { throw "Exiting. Took too long" }
    }
}
Write-Host "-----------------------------------------------------"
Write-Host "Keycloak Started"
Write-Host "-----------------------------------------------------"
Start-Sleep 2

# Terraform Config
Write-Host "-----------------------------------------------------"
Write-Host "Starting Terraform Configuration"
Write-Host "-----------------------------------------------------"
terraform init
terraform plan


