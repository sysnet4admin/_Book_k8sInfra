#!/usr/bin/env bash
#Auto_Pass 
#if you want to filter only ip then [grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}']

#make a directory 
mkdir ~/.ssh

#Read hosts from file 
readarray hosts < /etc/hosts

##1.known_hosts##
if [ ! -f ~/.ssh/known_hosts ]; then
  for host in ${hosts[@]}; do
    ssh-keyscan -t ecdsa ${host} >> ~/.ssh/known_hosts
  done
fi

##2.authorized_keys
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''
    for host in ${hosts[@]}; do 
       sshpass -p vagrant ssh-copy-id -f ${host}
    done
fi