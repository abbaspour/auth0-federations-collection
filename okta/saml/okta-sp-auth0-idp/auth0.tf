locals {
  idp_id = "0oaea5zr2emRcbsqM1d7" # copy ${okta_idp_saml.auth0.id} here to avoid cyclic dependency
}
resource "auth0_client" "idp" {
  name = "Okta SAML IdP"

  callbacks = [
    # "https://${var.okta_org_name}.okta.com/sso/saml2/${okta_idp_saml.auth0.id}" cycle dependency
    "https://${var.okta_org_name}.${var.okta_base_url}/sso/saml2/${local.idp_id}"
  ]

  addons {
    samlp {
      signature_algorithm    = "rsa-sha256"
      name_identifier_probes = ["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]
      mappings               = {
        "given_name" : "firstName", "family_name" : "lastName", "email" : "email"
      }
    }
  }
}


data "auth0_connection" "db" {
  name = "Username-Password-Authentication"
}

/*
resource "auth0_connection_clients" "db_clients" {
  connection_id   = data.auth0_connection.db.id
  enabled_clients = [auth0_client.idp.id, var.auth0_tf_client_id]
  lifecycle {
    ignore_changes = [
      enabled_clients
    ]
  }
}
*/
