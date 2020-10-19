#!/usr/bin/env bash
cd deployment
echo "----- before deploy"
kustomize edit add label deploy:$1 -f
kustomize edit set namesuffix -- -$1
kustomize edit set image 192.168.1.10:8443/echo-buildtime:$1
kustomize build . | kubectl apply -f -
echo "----- after new deploy"
kubectl get deployment -o wide
while true;
do
export replicas=$(kubectl get deployment --selector=app=echo-buildtime,deploy=$1 -o jsonpath --template="{.items[0].status.replicas}")
export ready=$(kubectl get deployment --selector=app=echo-buildtime,deploy=$1 -o jsonpath --template="{.items[0].status.readyReplicas}")
echo "replicas: $replicas, readyReplicas: $ready"
if [ "$ready" == "$replicas" ]; then
  echo "switching new deployment"
  cd ../service
  kustomize edit add label deploy:$1 -f
  kustomize build . | kubectl apply -f -
  sleep 3
  kubectl delete deployment --selector=app=echo-buildtime,deploy!=$1
  echo "----- after old deploy remove"
  kubectl get deployment -o wide
  break
else
  sleep 1
fi
done
