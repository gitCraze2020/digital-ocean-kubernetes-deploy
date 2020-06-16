#~/bin/bash

#TMP_STR="abc\"def \$input hello"

read -r -d '' TMP_STR << EOM
mutation mutAddRepo (\$input: CreateRepositoryInput!) { 
  createRepository (input: \$input) {
      clientMutationId
  }   
}
{
  "input": {
    "clientMutationId": "cwex3",
    "name": "$TMP_REPO_NAME",
    "visibility": "PUBLIC"    
  }
}
EOM



echo ... 
echo $TMP_STR
echo ... 
# escape the double quotes for embedding in string
TMP_STR=$(echo $TMP_STR | sed "s/\"/\\\\\"/g")

#TMP_STR=$(echo $TMP_STR | sed "s/\\$/\\\\$/g")

echo ... 
echo $TMP_STR
echo ... 


