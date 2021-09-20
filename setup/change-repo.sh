#!/bin/bash

MYPATH=$(cd "$(dirname "$0")" && pwd)
REPOPATH=$(dirname $MYPATH)

GITREPO=$(git remote -v | awk -F '[:/ ]' '/origin.*push/ {print $(NF-2) "/" $(NF-1)}')

# changing     repoURL: https://github.com/cwilkers/kubevirt-gitops

sed -i "s@repoURL: https://github.com/.*@repoURL: https://github.com/${GITREPO}@" ${REPOPATH}/*/application.yaml
