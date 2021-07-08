#!/bin/sh

# Pod to Service via cluster IP, service endpoint serves on pod network Endpoint on the different host
source ../config

kubectl create -f ../sriov_workloads/pod-worker2.yaml
kubectl create -f ../sriov_workloads/iperf_service_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf3_service_pod.yaml

client_pod=$pod_worker2
server_ip=`kubectl get svc | grep $iperf3_pod_svc | awk {'print $3'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

