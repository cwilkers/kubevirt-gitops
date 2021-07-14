#!/bin/bash
ARGO_NS=openshift-gitops
ARGO_CR=openshift-gitops

# Create repositories entry in ArgoCD configuration Custom Resource
if [ ! -f repositories.yaml ]
then
    # Install repositories in to argocd config map
    GITREPO=$(git remote -v | awk -F '[:/ ]' '/origin.*push/ {print $(NF-2) "/" $(NF-1)}')
    cat > repositories.yaml <<END
- type: git
  url: https://github.com/${GITREPO}
END
fi

oc -n openshift-gitops create cm argocd-cm --from-file=repositories=repositories.yaml --dry-run=client -o yaml | oc apply -f -

