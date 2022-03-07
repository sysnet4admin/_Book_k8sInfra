#!/usr/bin/env bash

# vim configuration 
echo 'alias vi=vim' >> /etc/profile

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# local small dns & vagrant cannot parse and delivery shell code.
for (( m=1; m<=$1; m++  )); do echo "192.168.1.1$m m1$m-k8s" >> /etc/hosts; done
for (( n=1; n<=$2; n++  )); do echo "192.168.1.10$n w10$n-k8s" >> /etc/hosts; done

# config DNS  
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF

# authority between all masters and workers
sudo mv auto_pass.sh /root
sudo chmod 744 /root/auto_pass.sh

# when git clone from windows '$'\r': command not found' issue happened
sudo sed -i -e 's/\r$//' /root/auto_pass.sh 
