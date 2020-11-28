#/bin/env bash
helm install jenkins edu/jenkins \
--set persistence.existingClaim=jenkins \
--set master.adminPassword=admin \
--set master.nodeSelector."kubernetes\.io/hostname"=m-k8s \
--set master.tolerations[0].key=node-role.kubernetes.io/master \
--set master.tolerations[0].effect=NoSchedule \
--set master.tolerations[0].operator=Exists \
--set master.runAsUser=1000 \
--set master.fsGroup=1000 \
--set master.tag=2.249.3-lts-centos7 \
--set master.serviceType=LoadBalancer \
--set master.servicePort=80 \
--set master.jenkinsUrl="192.168.1.10"
--set master.javaOpts="-DsessionTimeout=1440 -Duser.timezone=Asia/Seoul"