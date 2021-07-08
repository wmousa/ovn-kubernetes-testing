#!/bin/sh

# External to Service via NodePort, service endpoint serves on Node IP (Host-Network) Node IP used to access is the node endpoint is not scheduled to
source ../config

kubectl create -f ../sriov_workloads/iperf_service_host_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf_service_host.yaml

server_ip=`kubectl get nodes -o wide | grep $worker2 | awk {'print $6'}`
server_port=`kubectl get svc  | grep $iperf3_host_network_svc | awk {'print $5'} | cut -d : -f2 | cut -d / -f1`

echo "execution command is, run it from external:"
echo "iperf3 -c $server_ip -p $server_port -t 99"

