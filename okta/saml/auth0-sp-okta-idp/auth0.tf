resource "auth0_connection" "okta-saml" {
  name     = "Amin-Okta-SAML"
  strategy = "samlp"
  display_name   = "Amin-Okta SAML Connection"
  show_as_button = true

  options {
    debug               = false
    sign_in_endpoint    = "https://amin.okta.com/app/amin_aminjp_1/exk3ns1r6dQbe5SHr3l7/sso/saml"
    sign_out_endpoint   = "https://saml.provider/sign_out"
    disable_sign_out    = true
    tenant_domain       = "okta.com"
    domain_aliases      = ["okta.com"]
    protocol_binding    = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    user_id_attribute   = "https://saml.provider/imi/ns/identity-200810"
    signature_algorithm = "rsa-sha256"
    digest_algorithm    = "sha256"
    icon_url            = "https://saml.provider/assets/logo.png"
    metadata_url        = "https://amin.okta.com/app/exk3ns1r6dQbe5SHr3l7/sso/saml/metadata"

    idp_initiated {
      client_id              = data.auth0_client.JWT-io.client_id
      client_protocol        = "oidc"
      client_authorize_query = "type=id_token&timeout=30"
    }


  }

  lifecycle {
    ignore_changes = [
      set_user_root_attributes
    ]
  }
}

data "auth0_client" "JWT-io" {
  name = "JWT.io"
}

resource "auth0_connection_clients" "SAML-app-assignment" {
  connection_id   = auth0_connection.okta-saml.id
  enabled_clients = [data.auth0_client.JWT-io.client_id]
}
