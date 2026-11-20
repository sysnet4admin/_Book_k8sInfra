#!/usr/bin/env bash

# create .kube directory
mkdir ~/.kube

# copy kubeconfig by sshpass
sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no root@192.168.1.10:/etc/kubernetes/admin.conf ~/.kube/config

# git clone _Book_k8sInfra code
git clone https://github.com/sysnet4admin/_Book_k8sInfra.git $HOME/_Book_k8sInfra
find $HOME/_Book_k8sInfra -regex ".*\.\(sh\)" -exec chmod 700 {} \;

# make rerepo-book-k8sinfra and input proper permission
cat <<EOF > /usr/local/bin/rerepo-book-k8sinfra
#!/usr/bin/env bash
rm -rf $HOME/_Book_k8sInfra
git clone https://github.com/sysnet4admin/_Book_k8sInfra.git $HOME/_Book_k8sInfra
find $HOME/_Book_k8sInfra -regex ".*\.\(sh\)" -exec chmod 700 {} \;
EOF
chmod 700 /usr/local/bin/rerepo-book-k8sinfra
