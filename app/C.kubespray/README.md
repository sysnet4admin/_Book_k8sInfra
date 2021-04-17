# Running kubespray 
1. login m11-k8s
2. **sh auto_pass.sh**
3. **ansible-playbook kubespray/cluster.yml -i ansible_hosts.ini** </br>
   (if you need to add or remove for hosts, please modify ansible_hosts.ini manually.)