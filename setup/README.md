# Setup scripts for KubeVirt - ArgoCD integration

Note, much of this is geared for OpenShift clusters, and the OpenShift
Virtualization and OpenShift GitOps products. Where possible, I have tried to
enable scripted discovery of namespaces and CR names to account for
upstream/downstream, but where assumptions must be made, they have been made in
favor of OpenShift.

This directory contains the following helpers:

**add-ns-to-argocd.sh**

In OpenShift, ArgoCD service accounts are not able to manage all resources in
all namespaces. This access must be granted per namespace by assigning a Role
called cluster-admin to the ServiceAccount in each namespace required. Call
this script with a namespace while logged in to an account with cluster-admin
privileges to make the appropriate changes.

**build-resourcecustomizations.sh**

Builds and prints on stdout updates to the ArgoCD custom resource to include
health scripts (in Lua) for KubeVirt custom resources. This allows ArgoCD to
better report the sync status of resources like DataVolumes and VMs that do
not immediately become available. Expects `*.lua` scripts in the current 
directory with filenames in the form:

     <apiVersion (only the vendor part before the /)>_<Resource Name>_health.lua

cdi.kubevirt.io_DataVolume_health.lua
kubevirt.io_VirtualMachine_health.lua

**install.sh**
