#!/bin/bash

##########################################
# A script to free resources after testing
##########################################

cd "$(dirname "${BASH_SOURCE[0]}")"
docker compose --project-name accountlinking down
