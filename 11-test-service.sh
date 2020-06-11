#!/bin/bash

echo this is the pod
kubectl get pod --selector="app=do-kubernetes-sample-app" --output jsonpath='{.items[0].metadata.name}'
echo
echo it could have been picked up from a list retrieved by command 
echo kubectl get pods
kubectl get pods

# anyway, the sub-command picks up the Pod name and applies a port-forward:
kubectl port-forward $(kubectl get pod --selector="app=do-kubernetes-sample-app" --output jsonpath='{.items[0].metadata.name}') 8080:80

