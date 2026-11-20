#!/usr/bin/env bash

# avoid 'dpkg-reconfigure: unable to re-open stdin: No file or directory'
export DEBIAN_FRONTEND=noninteractive

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# local small dns & vagrant cannot parse and delivery shell code.
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1 localhost" >> /etc/hosts
for (( c=1; c<=$1; c++  )); do echo "192.168.1.1$c cp1$c-k8s" >> /etc/hosts; done
for (( w=1; w<=$2; w++  )); do echo "192.168.1.10$w w10$w-k8s" >> /etc/hosts; done

# authority between all masters and workers
sudo mv auto_pass.sh /root
sudo chmod 744 /root/auto_pass.sh

# when git clone from windows '$'\r': command not found' issue happened
sudo sed -i -e 's/\r$//' /root/auto_pass.sh 
