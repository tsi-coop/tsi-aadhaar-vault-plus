#!/bin/bash

# Source the .env file to load variables into the current shell session
# Adjust path if .env is not in the same directory as the script
if [ -f ./.env ]; then
    source ./.env
else
    echo "Error: .env file not found. Please create it."
    exit 1
fi

export JAVA_HOME=$JAVA_HOME
export TSI_AADHAR_VAULT_PLUS_ENV=$TSI_AADHAR_VAULT_PLUS_ENV
export TSI_AADHAR_VAULT_PLUS_HOME=$TSI_AADHAR_VAULT_PLUS_HOME
export POSTGRES_HOST=$POSTGRES_HOST
export POSTGRES_DB=$POSTGRES_DB
export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWD=$POSTGRES_PASSWD
export JETTY_HOME=$JETTY_HOME
export JETTY_BASE=$JETTY_BASE
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_REGION=$AWS_REGION
export AWS_KMS_KEY_IDENTIFIER=$AWS_KMS_KEY_IDENTIFIER
export TSI_LOOKUP_SALT=$TSI_LOOKUP_SALT
cp %TSI_AADHAR_VAULT_PLUS_HOME%\target\tsi_aadhaar_vault_plus.war %JETTY_BASE%\webapps\ROOT.war
java -jar $JETTY_HOME/start.jar