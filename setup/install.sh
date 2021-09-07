#!/bin/bash

MYPATH=$(cd "$(dirname "$0")" && pwd)

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

kubectl apply -f <(${MYPATH}/build-resourcecustomizations.sh)
