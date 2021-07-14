#!/bin/bash

A=($(kubectl get argocd -A | tail -n 1) )
ARGO_NS=${A[0]}
ARGO_CR=${A[1]}


DV_YAML=$(sed 's/^/        /' datavolumes.health.lua)
VM_YAML=$(sed 's/^/        /' virtualmachines.health.lua)

read -r -d '' YAML <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: ${ARGO_CR}
  namespace: ${ARGO_NS}
spec:
  resourceCustomizations: |
    cdi.kubevirt.io/DataVolume:
      health.lua: |
${DV_YAML}
    kubevirt.io/VirtualMachine:
      health.lua: |
${VM_YAML}
EOF

echo "$YAML"
