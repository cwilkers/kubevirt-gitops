#!/bin/bash
NAMESPACE=${1:-default}

A=($(kubectl get argocd -A | tail -n 1) )
ARGO_NS=${A[0]}
ARGO_CR=${A[1]}

echo Adding argocd admin in $NAMESPACE
oc adm policy add-role-to-user cluster-admin \
  system:serviceaccount:${ARGO_NS}:${ARGO_CR}-argocd-application-controller \
  -n ${NAMESPACE}

