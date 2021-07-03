# https://github.com/docker/compose/issues/5222
docker-compose -f "docker-compose.yml" up -d --build 2>&1 | %{ "$_" }

$attempts = 10
$repeat = $true
while ($true) {
    $attempts--
    $alive = invoke-webrequest http://localhost:8080 -DisableKeepAlive -UseBasicParsing -ErrorAction SilentlyContinue
    if ($alive.StatusCode -eq '200') { break }
    else {
        if ($attempts -gt 0) { Start-sleep 3; Write-Host "Waiting for Keycloak to start.. $attempts attempts remaining" }
        else { throw "Exiting. Took too long" }
    }
}
Write-Host "Keycloak Started"

# Terraform Part
terraform init
terraform plan


