# Build the containers
Write-Host "-----------------------------------------------------"
Write-Host "Building Containers"
Write-Host "-----------------------------------------------------"
docker build -q -f dockerfile-mssql-keycloak -t mssql-keycloak:latest .

# Start Keycloak and MSSQL
# https://github.com/docker/compose/issues/5222
Write-Host "-----------------------------------------------------"
Write-Host "Checking if Docker Containers Are Running"
Write-Host "-----------------------------------------------------"
$startContainers = $false
try {
    $alive =invoke-webrequest http://localhost:8080/auth/ -DisableKeepAlive -UseBasicParsing -ErrorAction SilentlyContinue
}
catch { 
    Write-Host "Containers not started"
    $startContainers = $true
}
if ($startContainers) {
    Write-Host "-----------------------------------------------------"
    Write-Host "Starting Docker Containers"
    Write-Host "-----------------------------------------------------"
    docker-compose -f "docker-compose.yml" up -d --build 2>&1 | %{ "$_" }
    
    $attempts = 10
    while ($true) {
        try {
            $alive = invoke-webrequest http://localhost:8080/auth/ -DisableKeepAlive -UseBasicParsing -ErrorAction SilentlyContinue
            break
        }
        catch { 
            $attempts--
            if ($attempts -gt 0) { 
                Write-Host "Waiting for Keycloak to start.. $attempts attempts remaining"
                Start-sleep 5
            }
            else { 
                throw "Exiting. Took too long"
            }
        }
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
terraform validate
terraform plan
terraform apply -auto-approve

# invoke-webrequest http://localhost:808 -DisableKeepAlive -UseBasicParsing -ErrorAction SilentlyContinue
