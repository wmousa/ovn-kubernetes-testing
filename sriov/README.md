# sriov traffic flows
This section helps you to create pods and services for all traffic flows in ovn-kubernetes cluster, and print the test execution command for related flow

## Prerequisite
- Running ovn-kubernetes with three nodes: one master and two workers nodes  
- Sriov-device-plugin and multus deployed  
- Vfs created and moved to switchdev in worker nodes 

# Run the tests
### Prepare config file
- Configure your config file `./config` according to your cluster, you can get the nodes name by running this command  
```
$ kubectl get nodes
```  

### Render sriov workloads yaml files
```
$ ./render_workload_files.sh
```

### Create the pods and services in `veth_workloads/`
```
$ for i in `ls veth_workloads/`; do kubectl create -f veth_workloads/$i; done
```

### Run the tests
- go to `tests` dir and run the specific script to create the related pods and service and print the test execution command  
```
$ cd ./tests

```

## Clean the cluster
- to clean pods and services, run:  
```
$ ./clean.sh
```
- to clean pods, service, ovnkube-nod and sriov-device-plugin run:  
```
$ ./clean.sh all
```
