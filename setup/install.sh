#!/bin/bash

oc create ns openshift-cnv
oc adm policy add-role-to-user cluster-admin \
  system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller \
  -n openshift-cnv

if [ ! -f repositories.yaml ]
then
    # Install repositories in to argocd config map
    GITREPO=$(git remote -v | awk -F '[: ]' '/origin.*push/ {print $2}')
    cat > repositories.yaml <<END
 - type: git
   url: https://github.com/${GITREPO}
END
fi

oc -n openshift-gitops create cm argocd-cm --from-file=repositories=repositories.yaml --dry-run=client -o yaml | oc apply -f -

