terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = "3.1.1"
    }
  }
}


locals {
  users = csvdecode(file("./keycloak_users.csv"))
}

output "csv_users" {
  value = local.users
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

resource "keycloak_user" "users_from_csv" {
    #for_each = { for user in local.users : user.username => user }
    for_each = { for user in local.users : user.username => user }

    realm_id   = keycloak_realm.test-realm.id
    username   = each.value.username
    enabled    = true

    email      = each.value.email
    first_name = each.value.first_name
    last_name  = each.value.last_name

    attributes = {
        foo = "bar"
        multivalue = "value1##value2"
    }

    initial_password {
        value     = each.value.password
        temporary = false
    }
}