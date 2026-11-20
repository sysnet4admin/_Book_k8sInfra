# Running kubespray 
1. login cp11-k8s
2. **sh auto_pass.sh**
3. **cd kubespray**
3. **ansible-playbook cluster.yml -i ansible_hosts.ini** </br>
   (if you need to add or remove for hosts, please modify ansible_hosts.ini manually.)
