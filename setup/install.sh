#!/bin/bash

IMAGE_NS=openshift-virtualization-os-images
MYPATH=$(cd "$(dirname "$0")" && pwd)
MYNS=kubevirt-gitops

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

for ns in ${IMAGE_NS} ${MYNS}
do
    kubectl get ns ${IMAGE_NS} >& /dev/null || kubectl create ns ${IMAGE_NS}
    ${MYPATH}/add-ns-to-argocd.sh $IMAGE_NS
done

${MYPATH}/add-repo.sh

kubectl apply -f <(${MYPATH}/build-resourcecustomizations.sh)
