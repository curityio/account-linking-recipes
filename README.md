# Account Linking Recipes

Demonstrates techniques for handling user accounts and access token identities.\
Once each recipe is understood, it can also be adapted to other authentication providers.\
When required, the use of actions can scale to provide solutions to complex problems.

## Prerequisites

- Ensure that Docker is installed
- Copy a license file for the Curity Identity Server to the root folder
- Install the ngrok tool to enable the use of online OAuth Tools for testing

## Use Case 1: Default Passwords

Configure this use case with the following setup, to use default username and password based authentication:

```bash
export USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/1-configure-default-passwords.xml
```

The [Default Identity Behavior](doc/1-default-behavior.md) document explains this flow and its associated data.

## Use Case 2: Add an Extra Login Method

Next use Google as an extra login method, and link Google identities to accounts for existing and new users.\
To test this scenario, redeploy the system with extra configuration:

```bash
export USE_NGROK=true
export GOOGLE_CLIENT_ID='myclientid'
export GOOGLE_CLIENT_SECRET='myclientsecret'
./deploy.sh
./apply-use-case.sh ./config/2-configure-extra-login-method.xml
```

The [Extra Login Identity Behavior](doc/2-extra-login-behavior.md) document explains this flow and its associated data.

## Use Case 3: Use External Accounts

This scenario does not use the default password option and instead manages logins via Azure Active Directory.\
The Azure AD identity becomes the main account, and other accounts can link to it:

```bash
export USE_NGROK=true
export AZURE_AD_METADATA_URL='https://login.microsoftonline.com/mytenantid/v2.0/.well-known/openid-configuration'
export AZURE_AD_CLIENT_ID='myclientid'
export AZURE_AD_CLIENT_SECRET='myclientsecret'
./deploy.sh
./apply-use-case.sh ./config/3-configure-external-accounts.xml
```

The [External Account Identity Behavior](doc/3-external-account-behavior.md) document explains this flow and its associated data.

## Use Case 4: Migrating to Passwordless

This scenario demonstrates a phased migration from passwords to Webauthn keys.\
Some users can use passwords while others opt in to use of Webauthn keys when it suits them.\
This involves dynamic behavior to identify the user before choosing their authentication method.

```bash
export USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/4-configure-migrating-to-passwordless.xml
```

The [Migrating to Passwordless Behavior](doc/4-migrating-to-passwordless-behavior.md) document explains this flow and its associated data.

## Use Case 5: Mergers and Acquisitions

This scenario demonstrates a parent company acquiring a partner, where different IAM systems are used initially.\
The tutorial shows how user logins can be consolidated and how APIs can then call each other.

```bash
export USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/5-configure-mergers-and-acquisitions.xml
```

The [Mergers and Acquisitions Behavior](doc/5-mergers-and-acquisitions-behavior.md) document explains this flow and its associated data.

## Free Resources

Run the following script to free up all Docker resources once you have finished testing:

```bash
./teardown.sh
```

## Website Documentation

See the [Account Linking Recipes](https://curity.io/resources/learn/account-linking-recipes) website articles for the main documentation.

## More Information

Please visit [curity.io](https://curity.io/) for more information about the Curity Identity Server.


