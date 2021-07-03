docker-compose -f "docker-compose.yml" up -d --build

# Wait to start

terraform init
terraform plan
