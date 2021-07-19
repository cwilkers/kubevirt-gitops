#!/bin/bash
set -e

MYPATH=$(cd "$(dirname "$0")" && pwd)
MYNS=kubevirt-gitops

A=($(kubectl get argocd -A | tail -n 1) )
export ARGO_NS=${A[0]}
export ARGO_CR=${A[1]}

kubectl get ns openshift-virtualization-os-images >& /dev/null
RET=$?
if [ "$RET" == "0"]
then
    IMAGE_NS=openshift-virtualization-os-images
else
    IMAGE_NS=kubevirt-os-images
fi

${MYPATH}/add-ns-to-argocd.sh $IMAGE_NS
kubectl create ns $MYNS
${MYPATH}/add-ns-to-argocd.sh $MYNS

${MYPATH}/add-repo.sh

