#!/bin/sh

# Delete pods and services
source ./config

echo "delete pods and services"
kubectl delete pod --all && kubectl delete svc $iperf3_pod_svc $iperf3_host_network_svc

if [[ $1 ]]
then
    # Delete ovnkube-node
    echo "delete ovnkube-node"
    kubectl get pods -n ovn-kubernetes -o wide | grep ovnkube-node | grep -E "$worker1|$worker2" | awk '{print $1}' | xargs kubectl delete pod -n ovn-kubernetes
    echo "wait for recreation"
    kubectl -n ovn-kubernetes wait --for=condition=ready -l name=ovnkube-node pod --timeout=80s
fi
