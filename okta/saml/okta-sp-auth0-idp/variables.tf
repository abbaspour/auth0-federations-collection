## okta
variable "okta_org_name" {
  type        = string
  description = "Okta org name"
}

variable "okta_base_url" {
  type        = string
  description = "okta.com | oktapreview.com"
  default = "okta.com"
}

variable "okta_api_token" {
  type = string
  sensitive = true
}

/*
variable "okta_tf_client_id" {
  type        = string
  description = "Terraform client_id"
}
*/

## auth0
variable "auth0_domain" {
  type = string
  description = "Auth0 Domain"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret"
  sensitive = true
}
