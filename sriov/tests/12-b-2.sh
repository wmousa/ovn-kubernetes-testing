#!/bin/sh

# Host network Pod to Service via NodePort, service endpoint serves on pod network Endpoint on different host(Node IP used to access is a different Node IP
source ../config

kubectl create -f ../sriov_workloads/host_network_pod_worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf3_service_pod.yaml

client_pod=$host_network_pod_worker2
server_ip=`kubectl get nodes -o wide | grep $worker1 | awk {'print $6'}`
master_ip=`kubectl get nodes -o wide | grep $master | awk {'print $6'}`
server_port=`kubectl get svc  | grep $iperf3_pod_svc | awk {'print $5'} | cut -d : -f2 | cut -d / -f1`

echo "execution command using master IP is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $master_ip -p $server_port -t 99"

echo "execution command using service node IP is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -p $server_port -t 99"

