#!/usr/bin/env bash

# avoid 'dpkg-reconfigure: unable to re-open stdin: No file or directory'
export DEBIAN_FRONTEND=noninteractive

# kubectl completion on bash-completion dir
echo -e "\n# kubectl alias" >> ~/.bashrc 
echo 'alias k=kubectl'               >> ~/.bashrc
echo "alias ka='kubectl apply -f'"   >> ~/.bashrc
echo "alias kg-po-ip-stat-no='kubectl get pods -o=custom-columns=\
NAME:.metadata.name,IP:.status.podIP,STATUS:.status.phase,NODE:.spec.nodeName'" \
                                     >> ~/.bashrc 
# echo 'complete -F __start_kubectl k' >> ~/.bashrc
# echo 'kubectl completion bash >/etc/bash_completion.d/kubectl' >> ~/.bashrc 

# git clone book source 
git clone https://github.com/sysnet4admin/_Book_k8sInfra.git 
mv /home/vagrant/_Book_k8sInfra $HOME
find $HOME/_Book_k8sInfra -regex ".*\.\(sh\)" -exec chmod 700 {} \;

# make rerepo-book-k8sinfra and input proper permission
cat <<EOF > /usr/local/bin/rerepo-book-k8sinfra
#!/usr/bin/env bash
rm -rf $HOME/_Book_k8sInfra
git clone https://github.com/sysnet4admin/_Book_k8sInfra.git $HOME/_Book_k8sInfra
find $HOME/_Book_k8sInfra -regex ".*\.\(sh\)" -exec chmod 700 {} \;
EOF
chmod 700 /usr/local/bin/rerepo-book-k8sinfra
