source ./config
mkdir -p sriov_workloads

# Render all the workloads files from sriov_workloads_templates dir to sriov_workloads dir
for file in `ls ./sriov_workloads_templates`
do
  j2 ./sriov_workloads_templates/$file > ./sriov_workloads/$file
done
