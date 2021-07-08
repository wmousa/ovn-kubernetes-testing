#!/bin/sh

# Pod to Pod different  host
source ../config

kubectl create -f ../sriov_workloads/pod-worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_endpoint.yaml

client_pod=$pod_worker2
server_ip=`kubectl get pods -o wide | grep $iperf3_service_pod | awk {'print $6'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

