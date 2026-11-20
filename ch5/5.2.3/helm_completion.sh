#!/usr/bin/env bash

# helm completion on bash-completion dir & alias+
helm completion bash > /etc/bash_completion.d/helm
echo 'alias h=helm' >> ~/.bashrc
echo 'complete -F __start_helm h' >> ~/.bashrc

# reload bashrc (i.e. shell change) 
sudo -i 
 
