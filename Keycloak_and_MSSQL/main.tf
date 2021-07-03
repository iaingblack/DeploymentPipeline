terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = "3.1.1"
    }
  }
}

provider "keycloak" {
    client_id     = "admin-cli"
    username      = "admin"
    password      = "admin123"
    url           = "http://localhost:8080"
}