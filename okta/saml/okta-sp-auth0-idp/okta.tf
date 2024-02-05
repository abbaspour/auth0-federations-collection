data "http" "auth0-jwks" {
  url = "https://${var.auth0_domain}/.well-known/jwks.json"
}

data "jq_query" "extract-first-x5c-from-jwks" {
  data  = data.http.auth0-jwks.response_body
  query = ".keys[0].x5c[0]"
}


resource "okta_idp_saml_key" "auth0-signing-key" {
  x5c = [data.jq_query.extract-first-x5c-from-jwks.result]
}

resource "okta_idp_saml" "auth0" {
  name                     = var.auth0_domain
  acs_type                 = "INSTANCE"
  sso_url                  = "https://${var.auth0_domain}/samlp/${auth0_client.idp.client_id}"
  sso_destination          = "https://${var.auth0_domain}"
  sso_binding              = "HTTP-POST"
  username_template        = "idpuser.subjectNameId"
  kid                      = okta_idp_saml_key.auth0-signing-key.kid
  issuer                   = "urn:${var.auth0_domain}"
  request_signature_scope  = "REQUEST"
  response_signature_scope = "ANY"
}
