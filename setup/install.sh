#!/bin/bash

MYPATH=$(cd "$(dirname "$0")" && pwd)

${MYPATH}/change-repo.sh

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

kubectl apply -f <(${MYPATH}/build-resourcecustomizations.sh)
