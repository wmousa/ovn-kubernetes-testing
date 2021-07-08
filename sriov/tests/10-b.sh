#!/bin/sh

# Host network pod to Service viacluster IP, service endpoint serves on Node IP (Host-Network) On different host
source ../config

kubectl create -f ../sriov_workloads/host_network_pod_worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_host_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf_service_host.yaml

client_pod=$host_network_pod_worker2
server_ip=`kubectl get svc | grep $iperf3_host_network_svc | awk {'print $3'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

