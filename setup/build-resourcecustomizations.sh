#!/bin/bash

A=($(kubectl get argocd -A | tail -n 1) )
ARGO_NS=${A[0]}
ARGO_CR=${A[1]}

cat <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: ${ARGO_CR}
  namespace: ${ARGO_NS}
spec:
  resourceCustomizations: |
EOF

for lua in *.lua
do
  echo $lua | awk -F_ '{print "    " $1 "/" $2 ": |\n      " $3 ": |" }'
  sed 's/^/        /' $lua
done
