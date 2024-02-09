resource "okta_app_saml" "amin-jp" {
  label                    = "saml-amin-jp"
  sso_url                  = "https://amin.jp.auth0.com/login/callback"
  recipient                = "https://amin.jp.auth0.com/login/callback"
  destination              = "https://amin.jp.auth0.com/login/callback"
  audience                 = "urn:auth0:amin:Amin-Okta-SAML"
  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = false
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  attribute_statements {
    type         = "GROUP"
    name         = "groups"
    filter_type  = "REGEX"
    filter_value = ".*"
  }
}

data "okta_group" "everyone" {
  name = "Everyone"
}

resource "okta_app_group_assignment" "everyone-to-saml-assignment" {
  app_id   = okta_app_saml.amin-jp.id
  group_id = data.okta_group.everyone.id
}
