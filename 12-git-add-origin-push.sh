#!/bin/bash

# the authentication is only needed once to set config
TMP_GIT_USER_NAME=gitCraze2020
git config --global user.email "jurgenstoop@yahoo.com"
git config --global user.name  "$TMP_GIT_USER_NAME"

TMP_REPO_NAME=digital-ocean-kubernetes-deploy

# create new repository
TMP_CREATE_REPO='{"name":"'"$TMP_REPO_NAME"'"}'
TMP_CREATE_CMD="curl -u $TMP_GIT_USER_NAME https://api.github.com/user/repos -d $TMP_CREATE_REPO"
$TMP_CREATE_CMD

TMP_GIT_NAME="https://github.com/gitCraze2020/$TMP_REPO_NAME.git"

git remote add origin $TMP_GIT_USER_NAME/$TMP_GIT_NAME

git add --all

git commit -m "initial commit"

git push -u origin master


