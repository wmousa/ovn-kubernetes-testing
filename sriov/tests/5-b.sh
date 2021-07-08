#!/bin/sh

# Pod to Service via Cluster IP, service endpoint serves on Node IP (Host-Network) Endpoint On the different host
source ../config

kubectl create -f ../sriov_workloads/pod-worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_host_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf_service_host.yaml

client_pod=$pod_worker2
server_ip=`kubectl get svc | grep $iperf3_host_network_svc | awk {'print $3'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

