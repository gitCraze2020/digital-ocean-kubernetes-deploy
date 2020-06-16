#!/bin/bash 

# create new repository
TMP_GIT_USER_NAME=gitCraze2020
TMP_REPO_NAME="digital-ocean-kubernetes-deploy"
TMP_GIT_URL="https://github.com/$TMP_GIT_USER_NAME/$TMP_REPO_NAME.git"
echo $TMP_GIT_URL

git remote add origin $TMP_GIT_URL

git add --all

git commit -m "initial commit"

git push -u origin master
