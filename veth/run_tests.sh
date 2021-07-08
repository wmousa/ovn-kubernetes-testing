#!/bin/sh

# This script run all the use cases in README file,
# we assume that you aready created the pods and service in veth_workloads

source ./config
source ./test_fun.sh

master_ip=`kubectl get nodes -o wide | grep $master | awk {'print $6'}`
worker1_ip=`kubectl get nodes -o wide | grep $worker1 | awk {'print $6'}`
worker2_ip=`kubectl get nodes -o wide | grep $worker2 | awk {'print $6'}`
iperf3_service_pod_ip=`kubectl get pods -o wide | grep $iperf3_service_pod | awk {'print $6'}`
iperf3_pod_svc_cluster_ip=`kubectl get svc | grep $iperf3_pod_svc | awk {'print $3'}`
iperf3_host_network_svc_cluster_ip=`kubectl get svc | grep $iperf3_host_network_svc | awk {'print $3'}`
iperf3_pod_svc_port=`kubectl get svc  | grep $iperf3_pod_svc | awk {'print $5'} | cut -d : -f2 | cut -d / -f1`
iperf3_host_network_svc_port=`kubectl get svc  | grep $iperf3_host_network_svc | awk {'print $5'} | cut -d : -f2 | cut -d / -f1`

screen -S external -d -m bash -x -c "ip netns exec $gw_netns iperf3 -s"

###1
echo '1.a) Pod(veth) to Pod(veth) same host'
iperf_client_exec $pod_worker1 $iperf3_service_pod_ip

echo '1.b) Pod(veth) to Pod(veth) different host'
iperf_client_exec $pod_worker2 $iperf3_service_pod_ip

###2
echo '2) Pod(veth) to Node local' 
iperf_client_exec $pod_worker1 $worker1_ip

###3
echo '3) Pod(veth) to External'

iperf_client_exec $pod_worker1 $external_ip

###4
echo '4.a) Pod(veth) to Service via cluster IP, service endpoint serves on pod(veth) network Endpoint on the same host'
iperf_client_exec $pod_worker1 $iperf3_pod_svc_cluster_ip

echo '4.b) Pod(veth) to Service via cluster IP, service endpoint serves on pod(veth) network Endpoint on different host'
iperf_client_exec $pod_worker2 $iperf3_pod_svc_cluster_ip

echo '4.c) Pod(veth) to Service via cluster IP, service endpoint serves on pod(veth) network Endpoint is the same pod (hairpin on the pod)'
iperf_client_exec $iperf3_service_pod $iperf3_pod_svc_cluster_ip

###5
echo '5.a) Pod(veth) to Service via Cluster IP, service endpoint serves on Node IP (Host-Network) Endpoint On the same host'
iperf_client_exec $pod_worker1 $iperf3_host_network_svc_cluster_ip

echo '5.b) Pod(veth) to Service via Cluster IP, service endpoint serves on Node IP (Host-Network) Endpoint On different host'
iperf_client_exec $pod_worker2 $iperf3_host_network_svc_cluster_ip

###6
echo '6.a.1) Pod(veth) to Service via NodePort, service endpoint serves on pod network Endpoint on same host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $pod_worker1 $worker1_ip $iperf3_pod_svc_port

echo '6.a.2) Pod(veth) to Service via NodePort, service endpoint serves on pod network Endpoint on same host(Node IP used to access is a different Node IP'
iperf_client_exec $pod_worker1 $worker2_ip $iperf3_pod_svc_port

echo '6.b.1) Pod(veth) to Service via NodePort, service endpoint serves on pod network Endpoint on different host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $pod_worker2 $worker2_ip $iperf3_pod_svc_port

echo '6.b.2) Pod(veth) to Service via NodePort, service endpoint serves on pod network Endpoint on different host(Node IP used to access is a different Node IP'
echo 'using  service node ip'
iperf_client_exec $pod_worker2 $worker1_ip $iperf3_pod_svc_port
echo 'using  master node ip'
iperf_client_exec $pod_worker2 $master_ip $iperf3_pod_svc_port

###7
echo '7.a.1) Pod(veth) to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on same host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $pod_worker1 $worker1_ip $iperf3_host_network_svc_port

echo '7.a.2) Pod(veth) to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on same host(Node IP used to access is a different Node IP'
iperf_client_exec $pod_worker1 $worker2_ip $iperf3_host_network_svc_port

echo '7.b.1) Pod(veth) to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on different host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $pod_worker2 $worker2_ip $iperf3_host_network_svc_port

echo '7.b.2) Pod(veth) to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on different host(Node IP used to access is a different Node IP'
echo 'using  service node ip'
iperf_client_exec $pod_worker2 $worker1_ip $iperf3_host_network_svc_port
echo 'using  master node ip'
iperf_client_exec $pod_worker2 $master_ip $iperf3_host_network_svc_port

###8
echo '8.a) Host network Pod to Pod(veth) On same host'
iperf_client_exec $host_network_pod_worker1 $iperf3_service_pod_ip

echo '8.b) Host network Pod to Pod(veth) On different host'
iperf_client_exec $host_network_pod_worker2 $iperf3_service_pod_ip

###9
echo '9.a) Host network Pod to Service via cluster IP, service endpoint serves on pod network(veth) On same host'
iperf_client_exec $host_network_pod_worker1 $iperf3_pod_svc_cluster_ip
echo '9.b) Host network Pod to Service via cluster IP, service endpoint serves on pod network(veth) On different host'
iperf_client_exec $host_network_pod_worker2 $iperf3_pod_svc_cluster_ip
###10
echo '10.a) Host network pod to Service via cluster IP, service endpoint serves on Node IP (Host-Network) On same host'
iperf_client_exec $host_network_pod_worker1 $iperf3_host_network_svc_cluster_ip

echo '10.b) Host network pod to Service viacluster IP, service endpoint serves on Node IP (Host-Network) On different host'
iperf_client_exec $host_network_pod_worker2 $iperf3_host_network_svc_cluster_ip

###11
echo '11) Host Network pod to Kubernetes API via cluster IP'

###12
echo '12.a.1) Host network Pod to Service via NodePort, service endpoint serves on pod(veth) network Endpoint on same host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $host_network_pod_worker1 $worker1_ip $iperf3_pod_svc_port

echo '12.a.2) Host network Pod to Service via NodePort, service endpoint serves on pod(veth) network Endpoint on same host(Node IP used to access is a different Node IP'
iperf_client_exec $host_network_pod_worker1 $worker2_ip $iperf3_pod_svc_port

echo '12.b.1) Host network Pod to Service via NodePort, service endpoint serves on pod(veth) network Endpoint on different host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $host_network_pod_worker2 $worker2_ip $iperf3_pod_svc_port
echo '12.b.2) Host network Pod to Service via NodePort, service endpoint serves on pod(veth) network Endpoint on different host(Node IP used to access is a different Node IP'
echo 'using  service node ip'
iperf_client_exec $host_network_pod_worker2 $worker1_ip $iperf3_pod_svc_port
echo 'using  master node ip'
iperf_client_exec $host_network_pod_worker2 $master_ip $iperf3_pod_svc_port
###13
echo '13.a.1) Host network Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on same host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $host_network_pod_worker1 $worker1_ip $iperf3_host_network_svc_port
echo '13.a.2) Host network Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on same host(Node IP used to access is a different Node IP'
iperf_client_exec $host_network_pod_worker1 $worker2_ip $iperf3_host_network_svc_port

echo '13.b.1) Host network Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on different host(Node IP used to access is the node pod is scheduled to'
iperf_client_exec $host_network_pod_worker2 $worker2_ip $iperf3_host_network_svc_port

echo '13.b.2) Host network Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network) Endpoint on different host(Node IP used to access is a different Node IP'
echo 'using  service node ip'
iperf_client_exec $host_network_pod_worker2 $worker1_ip $iperf3_host_network_svc_port
echo 'using  master node ip'
iperf_client_exec $host_network_pod_worker2 $master_ip $iperf3_host_network_svc_port

###14
echo '14) Host Network Pod to external'
iperf_client_exec $host_network_pod_worker1 $external_ip

###15
echo '15.a) External to Service via NodePort, service endpoint serves on pod network(veth) Node IP used to access is the node endpoint is scheduled to'
netns_client_exec $worker1_ip $iperf3_pod_svc_port

echo '15.b) External to Service via NodePort, service endpoint serves on pod network(veth) Node IP used to access is the node endpoint is not scheduled to'
netns_client_exec $worker2_ip $iperf3_pod_svc_port

###16
echo '16.a) External to Service via NodePort, service endpoint serves on Node IP (Host-Network) Node IP used to access is the node endpoint is scheduled to'
netns_client_exec $worker1_ip $iperf3_host_network_svc_port

echo '16.b) External to Service via NodePort, service endpoint serves on Node IP (Host-Network) Node IP used to access is the node endpoint is not scheduled to'
netns_client_exec $worker2_ip $iperf3_host_network_svc_port

###17
echo '17) External to Service via Ingress'

sudo screen -XS external quit
