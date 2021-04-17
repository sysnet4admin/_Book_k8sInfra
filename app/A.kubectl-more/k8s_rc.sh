#!/usr/bin/env bash
# usage: 
# 1. Create 
# - bash <(curl -s  https://raw.githubusercontent.com/sysnet4admin/IaC/master/manifests/k8s_rc.sh) 
# 2. Remove 
# - sed -i '/source/d' .bashrc

if grep -q sysnet4admin ~/.bashrc; then
  echo "k8s_rc already installed"
  exit 0
fi

echo -e "\n#custome rc provide @sysnet4admin " >> ~/.bashrc
echo "source ~/.k8s_rc " >> ~/.bashrc

cat > ~/.k8s_rc <<'EOF'
#! /usr/bin/env bash
# HoonJo ver0.6.0
# https://github.com/sysnet4admin/IaC
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias ka='kubectl apply -f'
alias kc='kubectl create'
alias ks='kubectl scale'
alias ke='kubectl export'
alias kgw='kubectl get $1 -o wide'
kee(){
  if [ $# -eq 1 ]; then
    kubectl exec -it $(kubectl get pods | tail --lines=+2 | awk '{print $1}' | awk NR==$1) -- /bin/bash;
  else
    echo "usage: kee <pod number>"
  fi
}
keq(){
NAMESPACE=$1
exi_chk=($(kubectl get namespaces | tail --lines=+2 | awk '{print $1}'))
  #check to exist namespace but it is not perfect due to /^word$/ is not work
  if [[ ! "${exi_chk[@]}" =~ "$NAMESPACE" ]]; then
    echo -e "$NAMESPACE isn't a namespace. Try other as below again:\n"
    kubectl get namespaces
    echo -e "\nusage: keq or keq <namespace> [-c]\n"
    exit 1
  elif [ $# -eq 1 ]; then
    kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in $NAMESPACE: "
    read select
    kubectl exec -it -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print $1}' | awk NR==$select) -- /bin/sh;
  elif [ $# -eq 2 ]; then
    if [ ! $2 == "-c" ]; then
      echo -e "only -c option is available"
      exit 1
    fi
    echo -e ""
    kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in $NAMESPACE: "
    read select
    POD_SELECT=$select
    POD=$(kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print $1}' | awk NR==$select)
    echo -e ""
    kubectl describe pod -n $NAMESPACE $POD | grep -B 1 "Container ID" | egrep -v "Container|--" | awk -F":" '{print NR $1}'
    echo -en "\nPlease select container in: "
    read select
    CONTAINER=$(kubectl describe pod -n $NAMESPACE $POD | grep -B 1 "Container ID" | egrep -v "Container|--" | awk -F":" '{print $1}' | awk NR==$select)
    kubectl exec -it -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print $1}' | awk NR==$POD_SELECT) -c $CONTAINER -- /bin/sh;
  #default pod run
  elif [ -z $1 ]; then
    echo ""
    kubectl get pods | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in default: "
    read select
    kubectl exec -it $(kubectl get pods | tail --lines=+2 | awk '{print $1}' | awk NR==$select) -- /bin/sh;
  else
    echo ""
    kubectl get namespace
    echo -e "\nusage: keq or keq <namespace> [-c]\n"
  fi
}
kgpww(){
OPTION=$1
NAMESPACE=$2
exi_chk=($(kubectl get namespaces | tail --lines=+2 | awk '{print $1}'))
  if [[ ! "${exi_chk[@]}" =~ "$NAMESPACE" ]]; then
    echo -e "$NAMESPACE isn't a namespace. Try other as below again:\n"
    kubectl get namespaces
    echo -e "\nusage: kgpww -n <namespace>\n"
    exit 1
  elif [ -z $OPTION ]; then
    kubectl get pods -w -o wide
  else
    case $OPTION in
      -A ) kubectl get pods --all-namespaces -w -o wide;;
      -n ) kubectl get pods -n $NAMESPACE -w -o wide;;
       * ) echo -e "$OPTION is not avaialble. Only -A and -n support\n";;
    esac
  fi
}
kgpws(){
OPTION=$1
NAMESPACE=$2
exi_chk=($(kubectl get namespaces | tail --lines=+2 | awk '{print $1}'))
CstCol_lst="NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.spec.nodeName"
  if [[ ! "${exi_chk[@]}" =~ "$NAMESPACE" ]]; then
    echo -e "$NAMESPACE isn't a namespace. Try other as below again:\n"
    kubectl get namespaces
    echo -e "\nusage: kgpws -n <namespace>\n"
    exit 1
  elif [ -z $OPTION ]; then
    kubectl get pods --all-namespaces -o wide | head -n +1 | sort -k 8
    kubectl get pods --all-namespaces -o wide | tail -n +2 | sort -k 8
  else
    case $OPTION in
      -n )
           kubectl get pods -n $NAMESPACE -o custom-columns=$CstCol_lst | head -n +1
           kubectl get pods -n $NAMESPACE -o custom-columns=$CstCol_lst | tail -n +2 | sort -k 4;;
       * ) echo -e "$OPTION is not avaialble. Only -n support\n";;
    esac
  fi
}
kl(){
NAMESPACE=$1
exi_chk=($(kubectl get namespaces | tail --lines=+2 | awk '{print $1}'))
  #check to exist namespace but it is not perfect due to /^word$/ is not work
  if [[ ! "${exi_chk[@]}" =~ "$NAMESPACE" ]]; then
    echo -e "$NAMESPACE isn't a namespace. Try other as below again:\n"
    kubectl get namespaces
    echo -e "\nusage: kl or kl <namespace>\n"
    exit 1
  elif [ $# -eq 1 ]; then
    kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in $NAMESPACE: "
    read select
    kubectl logs -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print $1}' | awk NR==$select)
  #default pod run
  elif [ -z $1 ]; then
    echo ""
    kubectl get pods | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in default: "
    read select
    kubectl logs $(kubectl get pods | tail --lines=+2 | awk '{print $1}' | awk NR==$select)
  else
    echo ""
    kubectl get namespace
    echo -e "\nusage: kl or kl <namespace>\n"
  fi
}
kdp(){
NAMESPACE=$1
exi_chk=($(kubectl get namespaces | tail --lines=+2 | awk '{print $1}'))
  #check to exist namespace but it is not perfect due to /^word$/ is not work
  if [[ ! "${exi_chk[@]}" =~ "$NAMESPACE" ]]; then
    echo -e "$NAMESPACE isn't a namespace. Try other as below again:\n"
    kubectl get namespaces
    echo -e "\nusage: kdp or kdp <namespace>\n"
    exit 1
  elif [ $# -eq 1 ]; then
    kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in $NAMESPACE: "
    read select
    kubectl describe pods -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | tail --lines=+2 | awk '{print $1}' | awk NR==$select)
  #default pod run
  elif [ -z $1 ]; then
    echo ""
    kubectl get pods | tail --lines=+2 | awk '{print NR " " $1}'
    echo -en "\nPlease select pod in default: "
    read select
    kubectl describe pods $(kubectl get pods | tail --lines=+2 | awk '{print $1}' | awk NR==$select)
  else
    echo ""
    kubectl get namespace
    echo -e "\nusage: kdp or kdp <namespace>\n"
  fi
}
EOF

#Reload rc
su - 