# Account Linking Recipes

Demonstrates some techniques for handling user accounts and access token identities for complex use cases.\
Once each recipe is understood, it can also be adapted to other authentication providers.

## Prerequisites

- Ensure that Docker is installed 
- Copy a license file for the Curity Identity Server is copied to the root folder
- Install the ngrok tool to enable the use of online OAuth Tools for testing

## Use Case 1: Default Passwords

Configure this use case with the following setup, to use default username and password based authentication:

```bash
USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/1-configure-default-passwords.xml
```

The [Default Identity Behavior](doc/1-default-behavior.md) document explains how identity data is used.

## Use Case 2: Add an Extra Login Method

Next use Google as an extra login method, and link Google identities to accounts for existing and new users.\
To test this scenario, redeploy the system with extra configuration:

```bash
USE_NGROK=true
./deploy.sh
export GOOGLE_CLIENT_ID='myclientid'
export GOOGLE_CLIENT_SECRET='myclientsecret'
./apply-use-case.sh ./config/2-configure-extra-login-method.xml
```

The [Extra Login Identity Behavior](doc/2-extra-login-behavior.md) document explains how identity data is used.

## Use Case 3: Use External Accounts

This scenario does not use the default password option and instead manages logins via Azure Active Directory.\
The Azure AD identity becomes the main account, and other accounts can link to it:

```bash
USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/3-configure-external-accounts.xml
```

The [External Account Identity Behavior](doc/3-external-account-behavior.md) document explains how identity data is used.

## Use Case 4: Migrating to Passwordless

This scenario demonstrates a phased migration from passwords to Webauthn keys.\
Some users can use passwords while others opt in to use of Webauthn keys when it suits them.\
This involves dynamic behavior to identify the user before choosing their authentication method.

```bash
USE_NGROK=true
./deploy.sh
./apply-use-case.sh ./config/4-configure-migrating-to-passwordless.xml
```

The [Migrating to Passwordless Behavior](doc/4-migrating-to-passwordless-behavior.md) document explains how identity data is used.

## Use Case 5: Mergers and Acquisitions

This scenario demonstrates a parent company acquiring a partner, where different IAM systems are used initially.\
The tutorial shows how user logins can be consolidated and how APIs can then call each other.

```bash
./deploy.sh
./apply-use-case.sh ./config/5-configure-mergers-and-acquisitions.xml
```

The [Mergers and Acquisitions Behavior](doc/5-mergers-and-acquisitions-behavior.md) document explains how identity data is used.

## Free Resources

Run the following script to free up all Docker resources once you have finished testing:

```bash
./teardown.sh
```

## Website Documentation

See the [Account Linking Recipes](https://curity.io/resources/learn/account-linking-recipes) website articles for the main documentation.

## More Information

Please visit [curity.io](https://curity.io/) for more information about the Curity Identity Server.


