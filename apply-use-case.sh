#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
RESTCONF_BASE_URL='https://localhost:6749/admin/api/restconf/data'
ADMIN_USER='admin'
ADMIN_PASSWORD='Password1'

#
# Check input
#
USE_CASE_CONFIG_FILE_PATH="$1"
echo "$USE_CASE_CONFIG_FILE_PATH"
if [ ! -f "$USE_CASE_CONFIG_FILE_PATH" ]; then
  echo 'Please supply the path to a configuration file to apply-use-case.sh as a command line parameter'
  exit 1
fi

#
# Set environment variables
#
envsubst < "$USE_CASE_CONFIG_FILE_PATH" > ./config/extra-config.xml
if [ $? -ne 0 ]; then
  echo 'Problem encountered updating configuration XML'
  exit 1
fi

#
# Ensure that the Identity Server is ready
#
echo 'Waiting for the Curity Identity Server ...'
while [ "$(curl -k -s -o /dev/null -w ''%{http_code}'' -u "$ADMIN_USER:$ADMIN_PASSWORD" "$RESTCONF_BASE_URL?content=config")" != "200" ]; do
  sleep 2
done

#
# Apply the use case's configuration via a RESTCONF PATCH
#
echo 'Applying use case configuration ...'
HTTP_STATUS=$(curl -k -s \
-X PATCH "$RESTCONF_BASE_URL" \
-u "$ADMIN_USER:$ADMIN_PASSWORD" \
-H 'Content-Type: application/yang-data+xml' \
-d @./config/extra-config.xml \
-o restconf_response.txt -w '%{http_code}')
if [ "$HTTP_STATUS" != '204' ]; then
  echo "Problem encountered updating the configuration: $HTTP_STATUS"
  exit 1
fi
echo 'Use case configuration was successfully applied'
