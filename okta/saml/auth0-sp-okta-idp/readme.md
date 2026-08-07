# Setup

This configuration sets up Okta as a SAML identity provider federating into Auth0 as the
SAML service provider (`okta.tf` + `auth0.tf`), and enables inbound SCIM so Okta can
provision/deprovision users into Auth0 (`auth0_connection_scim_configuration` +
`auth0_connection_scim_token` in `auth0.tf`).

## Apply

```
make init
make plan
make apply
```

## Enable SCIM provisioning in Okta (manual step)

The `okta/okta` Terraform provider does not expose SCIM provisioning connector settings
for custom SAML apps (`okta_app_saml` only reports `features` as read-only), so this part
has to be configured once in the Okta Admin Console after `terraform apply`.

1. Get the SCIM endpoint URL and bearer token from Terraform outputs:

   ```bash
   terraform output scim_endpoint_url
   terraform output scim_bearer_token
   ```

2. In the Okta Admin Console, open the `saml-amin-jp` app.
3. **General** tab > **App Settings** > **Edit** > under **Provisioning**, select **SCIM** > **Save**.
4. **Provisioning** tab > **Integration** > **Edit**:
   - **SCIM connector base URL**: paste `scim_endpoint_url` (no trailing slash)
   - **Unique identifier field for users**: `userName`
   - **Supported provisioning actions**: `Push New Users`, `Push Profile Updates` (optionally `Push Groups`)
   - **Authentication Mode**: `HTTP Header`
   - **Authorization**: paste `scim_bearer_token`
   - Optionally **Test Connection Configuration**, then **Save**.
5. **Provisioning** tab > **To App** > **Edit**: enable **Create Users**, **Update User Attributes**, **Deactivate Users** > **Save**.
6. Under **Attribute Mappings**, delete the `Primary email type`, `Primary phone type`, and
   `Address type` lines — they can cause errors on `PUT` operations.
7. Assign the same users/groups to this app as are assigned to the SSO app (**Assignments** tab).
