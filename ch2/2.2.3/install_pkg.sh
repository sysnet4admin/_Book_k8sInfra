#!/usr/bin/env bash

# CentOS repo change from mirror to vault 
sed -i -e 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-*
sed -i -e 's/mirrorlist=/#mirrorlist=/g' /etc/yum.conf
sed -E -i -e 's/#baseurl=http:\/\/mirror.centos.org\/centos\/\$releasever\/([[:alnum:]_-]*)\/\$basearch\//baseurl=https:\/\/vault.centos.org\/7.9.2009\/\1\/\$basearch\//g' /etc/yum.repos.d/CentOS-*
sed -E -i -e 's/#baseurl=http:\/\/mirror.centos.org\/centos\/\$releasever\/([[:alnum:]_-]*)\/\$basearch\//baseurl=https:\/\/vault.centos.org\/7.9.2009\/\1\/\$basearch\//g' /etc/yum.conf

# install packages 
yum install epel-release -y
yum install vim-enhanced -y
