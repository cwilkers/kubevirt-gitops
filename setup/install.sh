#!/bin/bash

IMAGE_NS=openshift-virtualization-os-images
MYPATH=$(cd "$(dirname "$0")" && pwd)
MYNS=kubevirt-gitops

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

for ns in ${IMAGE_NS} ${MYNS}
do
    kubectl get ns ${ns} || kubectl create ns ${ns}
    ${MYPATH}/add-ns-to-argocd.sh ${ns}
done

${MYPATH}/add-repo.sh

kubectl apply -f <(${MYPATH}/build-resourcecustomizations.sh)
