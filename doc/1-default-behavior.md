# Default Identity Behavior

This describes how the main account is created when username and password authentication is used.\
It also shows how access tokens convey this identity to APIs.

## Configure OAuth Tools

Configure OAuth Tools to point to your instance of the Curity Identity Server.\
Provide a URL of the following form to create an environment:

```text
https://c81d-2-26-218-24.eu.ngrok.io/oauth/v2/oauth-anonymous/.well-known/openid-configuration
```

![OAuth Tools Environment](../images/1-default-behavior/oauth-tools-environment.png)

Run a code flow with these details:

- Client ID: demo-web-client
- Client Secret: Password1
- Scope: openid

![OAuth Tools Code Flow](../images/1-default-behavior/oauth-tools-code-flow.png)

## Register and Login

Create an account when prompted, to save your user to the database:

![Create Account](../images/1-default-behavior/create-account.png)

Then perform your initial password login:

![Initial Login](../images/1-default-behavior/initial-login.png)

## Database Behavior

A PostgreSQL database is deployed with the Curity Identity Server, to store user accounts.\
This data is reset on every deployment, so that you must re-register users.\
This enables the initial account linking and subsequent logins to be run many times.

## Query Identity Data

Connect to the SQL docker container included with the deployment:

```bash
CONTAINER_ID=$(docker ps | grep postgres | awk '{print $1}')
docker exec -it $CONTAINER_ID bash
```

Then connect to the SQL database:

```bash
export PGPASSWORD=Password1 && psql -p 5432 -d idsvr -U postgres
```

Then run these queries to view the initial data:

```bash
select * from accounts;
select * from linked_accounts;
```

As you would expect, this contains a single account line, with no linked accounts yet:

| account_id | username | email |
| ---------- | -------- | ----- |
| 0cee591a-461b-11ed-8779-0242c0a89002 | johndoe | john.doe@gmail.com |

## View Access Tokens

Upon return to OAuth Tools, redeem the code for tokens and introspect the access token.\
This shows the JWT that will be presented to your APIs by default:

![OAuth Tools Introspection](../images/1-default-behavior/oauth-tools-introspection.png)

The initial access token, once introspected, will contain fields such as these.\
The access token uses a Pairwise Pseudonymous Identifier (PPID) for the subject claim.\
This ID is a stable yet private identity that will be presented to your APIs:

```json
{
  "jti": "678605ec-5979-4dea-ac32-673fe5e65b2b",
  "delegationId": "c02167cd-2cdd-4a1b-b806-3c7476568c6e",
  "exp": 1665134652,
  "nbf": 1665134352,
  "scope": "openid",
  "iss": "https://idsvr.example.com/oauth/v2/oauth-anonymous",
  "sub": "642a797c311f0b7aef3db4e0a292bc69b924e6496d1e87aa3b28672c01611da7",
  "aud": "demo-client",
  "iat": 1665134352,
  "purpose": "access_token"
}
```
