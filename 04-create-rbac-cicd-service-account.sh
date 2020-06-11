#!/bin/bash

TMP_FILE_NAME=~/kube-general/cicd-service-account.yaml
if [ ! -f "$TMP_FILE_NAME" ]; then
  echo will not run rbac cicd account creation, missing file "$TMP_FILE_NAME"
  exit -1
fi

#note: you can also do the entire folder: kubectl apply -f ~/kube-general/
kubectl apply -f "$TMP_FILE_NAME"
cat "$TMP_FILE_NAME"
# see
# https://kubernetes.io/docs/reference/access-authn-authz/rbac
#consider :
#running kubectl auth reconcile



