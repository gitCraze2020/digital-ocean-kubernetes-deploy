#!/bin/bash -x

curl -H "Content-Type:application/json" -H "Authorization: bearer 01067562876e4a604eb80ce8dd24cd1a5d016aee" -X POST -d \
{ \
  \"query\" : \" \
mutation mutRepoAdd ( \$input: CreateRepositoryInput! ) { \
                 createRepository ( input: \$input ) { \
                   clientMutationId \
                 } \
   } \" \
  { \
  \"input\": { \
    \"clientMutationId\": \"cwex3\", \
    \"name": \"digital-ocean-kubernetes-deploy\", \
    \"visibility\": \"PUBLIC\" \
    } \
  } \
} https://api.github.com/graphql
