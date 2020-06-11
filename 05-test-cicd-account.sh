#!/bin/bash

kubectl get secret

#Some explanation on what the below command is doing:
#$(kubectl get secret | grep cicd-token | awk '{print $1}')
#This is used to retrieve the name of the secret related to our cicd Service Account. kubectl get secret returns the list of secrets on the default namespace, then you use grep to search for the lines related to
# 
#your cicd Service Account. Then you return the name, since it is the first thing on the single line returned from the grep.
#kubectl get secret preceding-command -o jsonpath='{.data.token}' | base64 --decode
#This will retrieve only the secret for your Service Account token. You then access the token field using jsonpath, and pass the result to base64 --decode. This is necessary because the token is stored as a Base64 string. The token itself is a JSON Web Token.


TOKEN=$(kubectl get secret $(kubectl get secret | grep cicd-token | awk '{print $1}') -o jsonpath='{.data.token}' | base64 --decode)

#warnings:
#this assumes current config context has the intended cluster (and server)
#and assumes the first cluster in the list is the intended server
TMP_SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')

kubectl --insecure-skip-tls-verify --kubeconfig=/dev/null --namespace=cwex3 --server="$TMP_SERVER" --token="$TOKEN" get pods

echo .
echo .
echo The error 
echo cannot list resource "pods" in API group ""
echo means the token works to connect to the server, which is good
echo .
echo if the token had not worked, the error would have been 
echo 'error: You must be logged in to the server (Unauthorized)'


