#!/bin/bash

if [[ -z ${ARGO_NS:+isset} ]]
then
  A=($(kubectl get argocd -A | tail -n 1) )
  ARGO_NS=${A[0]}
fi

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

oc -n ${ARGO_NS} create cm argocd-cm --from-file=repositories=repositories.yaml --dry-run=client -o yaml | oc apply -f -

