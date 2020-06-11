#!/bin/bash

# for this exercise we will need only one node/droplet
# for size choices, possible values run:
#   doctl kubernetes options sizes (default "s-1vcpu-2gb")
#doctl kubernetes cluster create --node-pool "name=kubernetes-deployment-tutorial;count=1"
doctl kubernetes cluster create kubernetes-deployment-tutorial --count 1

echo run this to check the cluster list:
echo doctl kubernetes cluster list
doctl kubernetes cluster list
