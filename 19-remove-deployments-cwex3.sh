#!/bin/bash

# assumption is that the namespace was used for this exercise
# and all objects associated with it can be dropped
kubectl get namespaces

kubectl delete namespaces cwex3
