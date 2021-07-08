#!/bin/sh

# Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on different host(Node IP used to access is the node pod is scheduled to'
source ../config

kubectl create -f ../sriov_workloads/pod-worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_host_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf_service_host.yaml

client_pod=$pod_worker2
server_ip=`kubectl get nodes -o wide | grep $worker2 | awk {'print $6'}`
server_port=`kubectl get svc  | grep $iperf3_host_network_svc | awk {'print $5'} | cut -d : -f2 | cut -d / -f1`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -p $server_port -t 99"

