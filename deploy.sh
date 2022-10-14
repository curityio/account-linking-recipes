#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Check there is a license file for the Curity Identity Server
#
if [ ! -f './license.json' ]; then
  echo 'Please provide a license file in the root folder before deploying the system'
  exit 1
fi

#
# If required, get an ngrok URL for testing with OAuth tools
#
RUNTIME_BASE_URL='http://localhost:8443'
if [ "$USE_NGROK" == 'true' ]; then
  
  if [ "$(pgrep ngrok)" == '' ]; then
    ngrok http 8443 --log=stdout &
    sleep 5
  fi

  RUNTIME_BASE_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')
  if [ "$RUNTIME_BASE_URL" == "" ]; then
    echo 'Problem encountered getting an NGROK URL'
    exit 1
  fi
fi
export RUNTIME_BASE_URL
echo "The OpenID Connect Metadata URL is at: $RUNTIME_BASE_URL/oauth/v2/oauth-anonymous/.well-known/openid-configuration"

#
# This is used by Curity developers to prevent checkins of license files
#
cp ./hooks/pre-commit ./.git/hooks

#
# Force a teardown of postgres data so that on each install users must be created
# This enables onboarding of new authentication methods to be tested repeatedly
#
rm -rf data
mkdir data

#
# Deploy the system
#
docker compose --project-name accountlinking up --force-recreate --detach
if [ $? -ne 0 ]; then
  echo 'Problem encountered starting deployment'
  exit 1
fi

#
# View logs in a child terminal window
#
open -a Terminal ./logs.sh
