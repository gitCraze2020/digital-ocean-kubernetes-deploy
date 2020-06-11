#!/bin/bash

# create a new Git repository in this folder
git init .

TMP_FOLDER_NAME=./kube
if [ -d "$TMP_FOLDER_NAME" ]; then
  echo will not run kube folders create, already found subfolder "$TMP_FOLDER_NAME" in$
  pwd
  exit -1
fi

# for resources manifests specific to this sample application:
mkdir "$TMP_FOLDER_NAME"

# for manifests that are common to multiple applications:
mkdir ~/kube-general
