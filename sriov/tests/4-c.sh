#!/bin/sh

# Pod to Service via cluster IP, service endpoint serves on pod network Endpoint is the same pod (hairpin on the pod)'
source ../config

kubectl create -f ../sriov_workloads/iperf_service_endpoint.yaml
kubectl create -f ../sriov_workloads/iperf3_service_pod.yaml

client_pod=$iperf3_service_pod
server_ip=`kubectl get svc | grep $iperf3_pod_svc | awk {'print $3'}`

echo "execution command is:"
echo "kubectl exec -it $client_pod -- iperf3 -c $server_ip -t 99"

