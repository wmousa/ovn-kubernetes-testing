#!/bin/sh

# Pod to Pod same host
source ../config

kubectl create -f ../sriov_workloads/pod-worker1.yaml
kubectl create -f ../sriov_workloads/iperf_service_endpoint.yaml

client_pod=$pod_worker1
server_ip=`kubectl get pods -o wide | grep $iperf3_service_pod | awk {'print $6'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

