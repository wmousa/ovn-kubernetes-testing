# ovn-kubernetes-testing

This repo helps you to test several traffic flows in ovn-kubernetes cluster

## Prerequisite
- Running ovn-kubernetes with three nodes: one master and two workers nodes  

## K8s Traffic flows
1. Pod to Pod traffic
   * Pod to Pod same host
   * Pod to Pod different host
2. Pod to Node local
3. Pod to External
4. Pod to Service via cluster IP service endpoint serves on pod network
   * Endpoint on the same host
   * Endpoint on different host 
   * Endpoint is the same pod (hairpin on the pod)
5. Pod to Service via Cluster IP, service endpoint serves on Node IP (Host-Network)
   * Endpoint on the same host
   * Endpoint on different host
6. Pod to Service via NodePort, service endpoint serves on pod network
   * Endpoint on same host
     1. Node IP used to access is the node pod is scheduled to
     2. Node IP used to access is a different Node IP
   * Endpoint on different host
     1. Node IP used to access is the node pod is scheduled to
     2. Node IP used to access is a different Node IP
7. Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network)
   * Endpoint on same host
     1. Node IP used to access is the node pod is scheduled to
     2. Node IP used to access is a different Node IP
   * Endpoint on different host
     1. Node IP used to access is the node pod is scheduled to
     2. Node IP used to access is a different Node IP
8. Host network Pod to Pod
   * On same host
   * On different host
9. Host network Pod to Service via cluster IP, service endpoint serves on pod network
   * On same host
   * On different host
10. Host network pod to Service via cluster IP, service endpoint serves on Node IP (Host-Network)
    * On same host
    * On different host
11. Host Network pod to Kubernetes API via cluster IP
12. Host network Pod to Service via NodePort, service endpoint serves on pod network
    * Endpoint on same host
      1. Node IP used to access is the node pod is scheduled to
      2. Node IP used to access is a different Node IP
    * Endpoint on different host
      1. Node IP used to access is the node pod is scheduled to
      2. Node IP used to access is a different Node IP
13. Host network Pod to Service via NodePort, service endpoint serves on Node IP (Host-Network)
    * Endpoint on same host
      1. Node IP used to access is the node pod is scheduled to
      2. Node IP used to access is a different Node IP
    * Endpoint on different host
      1. Node IP used to access is the node pod is scheduled to
      2. Node IP used to access is a different Node IP
14. Host Network Pod to external
15. External to Service via NodePort, service endpoint serves on pod network
    * Node IP used to access is the node endpoint is scheduled to
    * Node IP used to access is the node endpoint is not scheduled to
16. External to Service via NodePort, service endpoint serves on Node IP (Host-Network)
    * Node IP used to access is the node endpoint is scheduled to
    * Node IP used to access is the node endpoint is not scheduled to
17. External to Service via Ingress

## For veth traffic flows go to [veth traffic flows](./veth/README.md)
## For sriov traffic flows go [sriov traffic flows](./sriov/README.md)

