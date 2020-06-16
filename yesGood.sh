#!/bin/bash +x

# get token from file, this was manually saved after copy-paste from gitHub
TMP_TOKEN_FILE=gitCraze2020-oauth-token-cwex3.txt
TMP_OAUTH_TOKEN=($(cat $TMP_TOKEN_FILE))
echo $TMP_OAUTH_TOKEN

TMP_CURL_HEADERS="Authorization: bearer "$TMP_OAUTH_TOKEN
#TMP_CURL_HEADERS=\'$TMP_CURL_HEADERS\'
# set up wrapper syntax for any subsequent queries/mutations
read -r -d '' TMP_GRAPHQL_QUERY_BASE_OPEN << EOM
{
  "query": "
EOM
#
read -r -d '' TMP_GRAPHQL_QUERY_BASE_CLOSE << EOM
  "
}
EOM
#
# sample query
read -r -d '' TMP_GRAPHQL_QUERY_SAMPLE << EOM
query {
  viewer {
    login
  }
}
EOM
#echo $TMP_GRAPHQL_QUERY_SAMPLE

TMP_GRAPHQL_SAMPLE="$TMP_GRAPHQL_QUERY_BASE_OPEN $TMP_GRAPHQL_QUERY_SAMPLE $TMP_GRAPHQL_QUERY_BASE_CLOSE"
# strip newlines for use in curl
TMP_GRAPHQL_SAMPLE=$(echo $TMP_GRAPHQL_SAMPLE | sed "s/\n\r/ /g")
#TMP_GRAPHQL_SAMPLE=\'$TMP_GRAPHQL_SAMPLE\'

clear
echo "$TMP_GRAPHQL_SAMPLE" > ec.log
#curl -H "$TMP_CURL_HEADERS" -X POST -d "$TMP_GRAPHQL_SAMPLE" https://api.github.com/graphql 

if EXEC=$(curl -H "$TMP_CURL_HEADERS" -X POST -d "$TMP_GRAPHQL_SAMPLE" https://api.github.com/graphql) ; then
  echo success: 
  echo $EXEC
else
  echo failed:
  cat ec.log
fi

