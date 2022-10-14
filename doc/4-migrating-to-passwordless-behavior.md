# Migrating to Passwordless Identity Behavior

This page describes shows to dynamically change the primary authentication factor.\
By default users login with passwords, but each user opt into use of Webauthn keys when it suits them.\
This enables a phased migration, to improve both security and usability.

## Example Scenario

There are many security solutions that can be designed with Webauthn.\
In this scenario, internet users can either login with a password, or can bring their own Webauthn platform device.\
Once the Webauthn device is registered they no longer use password based logins.

## Authentication Selection

On every login a username authenticator is shown and the user provides their email.\
This will only be typed on the initial login and then will be autofilled from a cookie:

![Webauthn Username](../images/4-migrating-to-passwordless-behavior/webauthn-username.png)

A script action then runs to determine whether the user has a WebAuthn key registered.\
If not then the user may choose how to sign in via a selector action.\
Users who don't want to use Webauthn can continue to use the password option:

![Authentication Selector](../images/4-migrating-to-passwordless-behavior/authentication-selector.png)

## Webauthn Onboarding

When the Webauthn option is selected, the user is prompted to register a device:

![Register Device](../images/4-migrating-to-passwordless-behavior/register-device.png)

To onboard to Webauthn, the user must first authenticate with an existing credential.\
In the example scenario this involves logging in with the password:

![Webauthn Create Account](../images/4-migrating-to-passwordless-behavior/webauthn-create-account.png)

Next the user selects the security key option, inserts a YubiKey into a USB port and taps it:

![Register Security Key](../images/4-migrating-to-passwordless-behavior/register-security-key.png)

The user then sees the following screen and is considered authenticated when the proceed button is clicked:

![Registered Device](../images/4-migrating-to-passwordless-behavior/registered-device.png)

## Onboarding Future Users

New users cannot onboard solely with only a Webauthn key, since applications need details such as username and email.\
If the username authenticator is for a user that does not exist, the user is again prompted to authenticate.\
At this point the user will create an account and complete the registration flow:

![Webauthn Create Account](../images/1-default-behavior/create-account.png)

## Subsequent Logins

On all future logins the username authenticator is used first, with the autofilled username.\
When prompted, the user against inserts the YubiKey and taps it.\
The user now has a passwordless user experience, which is more secure and also more user friendly.

## Account Data

The PostgreSQL data will contain a single account record for either existing or future users:

| account_id | username | email |
| ---------- | -------- | ----- |
| 65c4928a-4bab-11ed-bd06-0242ac120002 | john.doe@company.com | john.doe@company.com |

Webauthn keys are stored in a `devices` table, and a simplified form of the data looks like this.\
Multiple Webauthn keys can be linked to the account, with no duplication.

| account_id | device_id | type | publicKey |
| ---------- | --------- | ---- | --------- |
| 65c4928a-4bab-11ed-bd06-0242ac120002 | 6f2761a2-6931-413d-8caa-00e4b4f015d3 | cross-platform | pQECAyYgASF ... |

## Access Tokens

Access tokens issued to applications will contain the same details and subject claim as previously.\
So migrating to Webauthn will have no impact on your APIs:

```json
{
  "jti": "adf9f0fc-3d38-402e-af52-187506190886",
  "delegationId": "cd231bba-ffa7-4c0e-ab5c-69b350fab979",
  "exp": 1665744658,
  "nbf": 1665744358,
  "scope": "openid",
  "iss": "https://14ff-2-26-218-28.eu.ngrok.io/oauth/v2/oauth-anonymous",
  "sub": "55ace8f2473cc2848c17d460326122db46dda6cff80d6754d10a0ff5ac13b940",
  "aud": "demo-web-client",
  "iat": 1665744358,
  "purpose": "access_token"
}
```
