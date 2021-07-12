#!/bin/bash
NAMESPACE=${1:-default}

echo Adding argocd admin in $NAMESPACE
oc adm policy add-role-to-user cluster-admin \
  system:serviceaccount:openshift-gitops:argocd-cluster-argocd-application-controller \
  -n ${NAMESPACE}

