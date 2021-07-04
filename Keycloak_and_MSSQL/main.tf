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

resource "keycloak_realm" "test-realm" {
  realm   = "test-realm"
  enabled = true
}

resource "keycloak_user" "user_with_initial_password" {
  realm_id   = keycloak_realm.test-realm.id
  username   = "alice"
  enabled    = true

  email      = "alice@domain.com"
  first_name = "Alice"
  last_name  = "Aliceberg"

  attributes = {
    foo = "bar"
    multivalue = "value1##value2"
  }

  initial_password {
    value     = "Password1"
    temporary = false
  }
}