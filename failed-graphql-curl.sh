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
# set up wrapper syntax for any subsequent queries/mutations
read -r -d '' TMP_GRAPHQL_QUERY_BASE_OPEN << EOM
{
  "query": 
EOM
#
read -r -d '' TMP_GRAPHQL_QUERY_BASE_CLOSE << EOM
}
EOM
#
# sample query
read -r -d '' TMP_GRAPHQL_QUERY_SAMPLE << EOM
"query {
  viewer {
    login
  }
}"
EOM

TMP_GRAPHQL_SAMPLE="$TMP_GRAPHQL_QUERY_BASE_OPEN $TMP_GRAPHQL_QUERY_SAMPLE $TMP_GRAPHQL_QUERY_BASE_CLOSE"
# strip newlines for use in curl
TMP_GRAPHQL_SAMPLE=$(echo $TMP_GRAPHQL_SAMPLE)

clear

if EXEC=$(curl -H "Content-Type:application/json" -H "$TMP_CURL_HEADERS" -X POST -d "$TMP_GRAPHQL_SAMPLE" https://api.github.com/graphql) ; then
  echo success: 
  echo $EXEC
else
  echo failed:
  echo $EXEC
fi

# create new repository

TMP_REPO_NAME="digital-ocean-kubernetes-deploy"
TMP_GIT_URL="https://github.com/$TMP_GIT_USER_NAME/$TMP_REPO_NAME.git"

read -r -d '' TMP_GRAPHQL_MUTATION_ADD_REPO << EOM
"mutation(\$input: CreateRepositoryInput!) {
  createRepository (input: \$input) {
      clientMutationId
  }
}"
{
  "input": {
    "clientMutationId": "cwex3",
    "name": "$TMP_REPO_NAME",
    "visibility": "PUBLIC"
  }
}
EOM


rm ttt.txt

echo ... >> ttt.txt
echo $TMP_GRAPHQL_MUTATION_ADD_REPO >> ttt.txt
echo ... >> ttt.txt

# escape the double quotes for embedding in string
#TMP_GRAPHQL_MUTATION_ADD_REPO=$(echo $TMP_GRAPHQL_MUTATION_ADD_REPO | sed "s/\"/\\\\\"/g")
echo ... >> ttt.txt
echo $TMP_GRAPHQL_MUTATION_ADD_REPO >> ttt.txt
echo ... >> ttt.txt


TMP_GRAPHQL_MUTATION_ADD_REPO="$TMP_GRAPHQL_QUERY_BASE_OPEN $TMP_GRAPHQL_MUTATION_ADD_REPO $TMP_GRAPHQL_QUERY_BASE_CLOSE"

echo ... >> ttt.txt
echo $TMP_GRAPHQL_MUTATION_ADD_REPO >> ttt.txt
echo ... >> ttt.txt


# strip newlines for use in curl
TMP_GRAPHQL_MUTATION_ADD_REPO=$(echo $TMP_GRAPHQL_MUTATION_ADD_REPO)

echo ... >> ttt.txt
echo $TMP_GRAPHQL_MUTATION_ADD_REPO >> ttt.txt
echo ... >> ttt.txt


# make '"query" : " mutation' into '"query" : "mutation'
TMP_GRAPHQL_MUTATION_ADD_REPO=$(echo $TMP_GRAPHQL_MUTATION_ADD_REPO | sed "s/ mutation/mutation/")
echo ... >> ttt.txt
echo $TMP_GRAPHQL_MUTATION_ADD_REPO >> ttt.txt
echo ... >> ttt.txt

#exit 1
echo ... >> ttt.txt
echo curl -H "Content-Type:application/json" -H "$TMP_CURL_HEADERS" -X POST -d "$TMP_GRAPHQL_MUTATION_ADD_REPO" https://api.github.com/graphql >> ttt.txt
echo ... >> ttt.txt

if EXEC=$(curl -H "Content-Type:application/json" -H "$TMP_CURL_HEADERS" -X POST -d "$TMP_GRAPHQL_MUTATION_ADD_REPO" https://api.github.com/graphql) ; then
  echo success: 
  echo $EXEC
else
  echo failed:
  echo $EXEC
fi

