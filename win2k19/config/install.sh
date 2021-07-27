#!/bin/sh

cd /scripts

echo "Starting install script"

oc apply -f windows-install-vm.yaml
echo "Applied VM, waiting for VM to start"

sleep 5

vm_ready=$(oc get vm windows-install -o jsonpath='{.status.ready}')
while [ "$vm_ready" != "true" ]
do
    sleep 10
    vm_ready=$(oc get vm windows-install -o jsonpath='{.status.ready}')
done

echo "VM is started"

vmi_phase=$(oc get vmi windows-install -o jsonpath='{.status.phase}')

while [ "$vmi_phase" != "Succeeded" ]
do
    sleep 30
    vmi_phase=$(oc get vmi windows-install -o jsonpath='{.status.phase}')
done

echo "VM has finished installing"

oc apply -f clone-boot-source.yaml

echo "Applied DataVolume to clone boot source image"

sleep 5

dv_phase=$(oc -n openshift-virtualization-os-images get dv win2k19 -o jsonpath='{.status.phase}')

while [ "$dv_phase" != "Succeeded" ]
do
    sleep 10
    dv_phase=$(oc -n openshift-virtualization-os-images get dv win2k19 -o jsonpath='{.status.phase}')
    echo $dv_phase
done

echo "Cleaning up"

oc delete -f windows-install-vm.yaml
