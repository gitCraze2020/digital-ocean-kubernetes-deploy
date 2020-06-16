#!/bin/bash 

# the authentication is only needed once to set config
TMP_GIT_USER_NAME=gitCraze2020
git config --global user.email "jurgenstoop@yahoo.com"
git config --global user.name  "$TMP_GIT_USER_NAME"

TMP_REPO_NAME=digital-ocean-kubernetes-deploy

# get token from file, this was manually saved after copy-paste from gitHub
TMP_TOKEN_FILE=gitCraze2020-oauth-token-cwex3.txt
TMP_OAUTH_TOKEN=($(cat $TMP_TOKEN_FILE))
echo $TMP_OAUTH_TOKEN

TMP_CURL_HEADERS="Authorization: bearer "$TMP_OAUTH_TOKEN
# sample query
read -r -d '' TMP_GRAPHQL_SAMPLE << EOM
query {
  viewer {
    login
  }
}
EOM

# strip newlines for use in curl
TMP_GRAPHQL_SAMPLE=$(echo $TMP_GRAPHQL_SAMPLE)

clear
# install graphqurl from github !
# get at github.com/hasura/graphqurl
# sudo npm install graphqurl
# then: add this token to package.json file, after 'description':
#         "files":"["*"],
#  /usr/local/lib/node_modules/graphqurl/package.json
#

echo "$TMP_CURL_HEADERS"
echo "$TMP_GRAPHQL_SAMPLE"

if EXEC=$(gq https://api.github.com/graphql -H "$TMP_CURL_HEADERS" -q "$TMP_GRAPHQL_SAMPLE") ; then
  echo success: 
  echo $EXEC
else
  echo failed:
  echo $EXEC
fi

