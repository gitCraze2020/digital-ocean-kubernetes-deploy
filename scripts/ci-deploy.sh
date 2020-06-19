#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

#this script will be run within the circleCI context, in which
# variable $CIRCLE_SHA1 was populated with the hash of the latest 
# image build. subsequently, the image was pushed to docker
# and tagged not just latest, but also with this variable
# so now we will propagate that value into the deployment yaml
#
# the deployment yaml has the image name as follows:
# dockerhub-username/do-kubernetes-sample-app:$COMMIT_SHA1
# we will rewrite this deployment yaml having the variable populated
# using tool envsubst
#
# We must export the variable so it's available for envsubst
COMMIT_SHA1=$CIRCLE_SHA1
export COMMIT_SHA1=$COMMIT_SHA1
#

# since the only way for envsubst to work on files is using input/output redirection,
# it's not possible to do in-place substitution, so we need to save the output to another file
# and overwrite the original with that one
# note: envsubst was installed by circleCI right before calling this script, see ./circleCI/config.yml
envsubst < ./kube/do-sample-deployment.yaml > ./kube/do-sample-deployment.yaml.out
mv ./kube/do-sample-deployment.yaml.out ./kube/do-sample-deployment.yaml

# this variable is set in the circleCI project's env variables:
# note, however, that I re-create my K8s cluster each day
# and so the certificate is updated manually each day, I need to fix that situation
# also, the namespace is not a fixed value in my current way of doing clusters...
echo "$KUBERNETES_CLUSTER_CERTIFICATE" | base64 -- decode > cert.crt

# note: kubectl was installed by circleCI right before calling this script, see ./circleCI/config.yml
./kubectl --kubeconfig=/dev/null --server=$KUBERNETES_SERVER --certificate-authority=cert.crt --token=$KUBERNETES_TOKEN --namespace=cwex3 apply -f ./kube/
