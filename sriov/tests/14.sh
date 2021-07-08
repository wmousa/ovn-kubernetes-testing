#!/bin/sh

# Host Network Pod to external
source ../config

kubectl create -f ../sriov_workloads/host_network_pod_worker1.yaml

client_pod=$host_network_pod_worker1
server_ip=$external_ip

echo "execution command is:"
echo "kubectl  exec -it $client_pod -- iperf3 -c $server_ip -t 99"

