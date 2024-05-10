terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.6.3"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.1"
    }
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.1"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
  /*
  client_id   = var.okta_tf_client_id
  private_key = "../../converted-tf-private-key.pem"
  scopes      = [
    "okta.groups.manage",
    "okta.apps.manage",
    "okta.clients.manage",
    "okta.policies.manage",
    "okta.users.manage",
    "okta.idps.manage",
    "okta.profileMappings.manage"
  ]
  log_level = 1
  */
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_tf_client_id
  client_secret = var.auth0_tf_client_secret
  debug         = "true"
}

