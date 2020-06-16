#!/bin/bash 

TMP_GIT_USER_NAME=gitCraze2020

# get token from file, this was manually saved after copy-paste from gitHub
TMP_TOKEN_FILE=gitCraze2020-oauth-token-cwex3.txt
TMP_OAUTH_TOKEN=($(cat $TMP_TOKEN_FILE))
echo $TMP_OAUTH_TOKEN

TMP_CURL_HEADERS="Authorization: bearer "$TMP_OAUTH_TOKEN

# create new repository

TMP_REPO_NAME="digital-ocean-kubernetes-deploy"
TMP_GIT_URL="https://github.com/$TMP_GIT_USER_NAME/$TMP_REPO_NAME.git"

# install graphqurl from github !
# get at github.com/hasura/graphqurl
# sudo npm install graphqurl
# then: add this token to package.json file: "files":"["*"] 
# then: add this token to package.json file, after 'description':
#         "files":"["*"],
#  /usr/local/lib/node_modules/graphqurl/package.json
#gq  https://api.github.com/graphql -H 'Authorization: bearer 01067562876e4a604eb80ce8dd24cd1a5d016aee' --variablesFile='./queryVariables.json' --queryFile=./query.gql
#

#write this to a file ./query.gql, remove the ## prefix:
##mutation(\$input: CreateRepositoryInput!) {
##  createRepository (input: \$input) {
##      clientMutationId
##  }
##}

#write this to a file ./queryVariables.json, remove the ## prefix:
##{
##  "input": {
##    "clientMutationId": "cwex3",
##    "name": "digital-ocean-kubernetes-deploy",
##    "visibility": "PUBLIC"
##  }
##}

if EXEC=$(gq  https://api.github.com/graphql -H "$TMP_CURL_HEADERS" --variablesFile='./queryVariables.json' --queryFile=./query.gql) ; then
  echo success: 
  echo $EXEC
else
  echo failed:
  echo $EXEC
fi

