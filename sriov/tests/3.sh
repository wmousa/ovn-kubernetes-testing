#!/bin/sh

# Pod to External
source ../config

kubectl create -f ../sriov_workloads/pod-worker1.yaml

client_pod=$pod_worker1
server_ip=$external_ip

echo "execution command is:"
echo "kubectl  exec -it $client_pod -- iperf3 -c $server_ip -t 99"

