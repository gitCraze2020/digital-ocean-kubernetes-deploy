#!/bin/bash

#define namespace for this exercise and set as default namespace
kubectl create -f namespace-cwex3.yaml
kubectl config set-context --current --namespace=cwex3


