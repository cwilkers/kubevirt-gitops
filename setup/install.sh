#!/bin/bash
set -e

IMAGE_NS=openshift-virtualization-os-images
MYPATH=$(cd "$(dirname "$0")" && pwd)
MYNS=kubevirt-gitops

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

kubectl get ns ${IMAGE_NS} >& /dev/null
EXISTS=$?
if [ "$EXISTS" != "0"]
then
    kubectl create ns ${IMAGE_NS}
fi

${MYPATH}/add-ns-to-argocd.sh $IMAGE_NS

kubectl get ns ${MYNS} >& /dev/null
EXISTS=$?
if [ "$EXISTS" != "0"]
then
    kubectl create ns ${MYNS}
fi

${MYPATH}/add-ns-to-argocd.sh $MYNS

${MYPATH}/add-repo.sh

