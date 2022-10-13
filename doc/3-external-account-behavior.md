# External Accounts Identity Behavior

This describes how to use an external account as the main account, with no use of default passwords.\
The external system in this example is Azure Active Directory.

## Configure Azure Active Directory

Login to the Azure Portal and create an OAuth client that redirects to your Curity Identity Server:

```text
https://idsvr.example.com/authn/authentication/AzureAD/callback
```

Note the generated Client ID and also create a Client Secret.\
See the [Azure AD Setup Tutorial](https://curity.io/resources/learn/oicd-authenticator-azure/) for further details.

## Create an OpenID Connect Authenticator

In the Curity Identity Server, create an OIDC authenticator and enter the corresponding details.\
These will include the Azure AD metadata endpointm, which will be a value of this form:

```text
https://login.microsoftonline.com/mytenantid/v2.0/.well-known/openid-configuration
```

![Azure AD Authenticator](../images/3-external-account-behavior/azuread-authenticator.png)

This authenticator will be responsible for creating the main account record.\
It therefore uses an `Auto Create Account` option and is assigned a `local account` domain.

## Perform an Azure AD Login

Use OAuth Tools to run a code flow and you will now perform a federated login.\
The Curity Identity Server uses the Authorization Server role.\
Azure Active Directory uses the Identity Provider role.

![Azure AD Login](../images/3-external-account-behavior/azuread-login.png)

## Query Account Data

If you query data you will see that there is a single account record and no linked identities.\
The data shape is the same as the default password behavior.

| account_id | username | email |
| ---------- | -------- | ----- |
| 0cee591a-461b-11ed-8779-0242c0a89002 | johndoe | john.doe@company.com |

## Future Account Linking

You can then add further login methods in future, that can be linked to the main account.\
This will work in an equivalent way to that described in [Extra Login Behavior](./2-extra-login-behavior.md).