source ./config
mkdir -p veth_workloads

# Render all the workloads files from veth_workloads_templates  dir to veth_workloads dir
for file in `ls ./veth_workloads_templates`
do
  j2 ./veth_workloads_templates/$file > ./veth_workloads/$file
done
