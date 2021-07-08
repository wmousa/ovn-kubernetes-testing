# veth traffic flows
This section helps you to get traffic flows test results in ovn-kubernetes cluster as a primary network with veth ports

## Prerequisite
- Running ovn-kubernetes with three nodes: one master and two workers nodes  
- GW on a name space on the same subnet of the ovn-kubernetes network  

## Run the tests
### Prepare config file
- Configure your config file `./config` according to your cluster, you can get the nodes name by running this command  
```
$ kubectl get nodes
```  

### Render veth workloads yaml files
```
$ ./render_workload_files.sh
```

### Create the pods and services in `veth_workloads/`  
```
$ for i in `ls veth_workloads/`; do kubectl create -f veth_workloads/$i; done
``` 

### Run the tests
```
$ ./run_tests.sh
```

## Clean the cluster
- to clean pods and services, run:  
```
$ ./clean.sh
```
- to clean pods, service and ovnkube-nod run:  
```
$ ./clean.sh all
```

