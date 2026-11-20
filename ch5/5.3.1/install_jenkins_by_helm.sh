#!/usr/bin/env bash

JK_CFG="https://raw.githubusercontent.com/k8s-edu/Bkv2_main/main/jenkins-cfg"
JK_OPT1="--sessionTimeout=1440"
JK_OPT2="--sessionEviction=86400"
JV_OPT1="-Duser.timezone=Asia/Seoul"
JV_OPT2="-Dcasc.jenkins.config=$JK_CFG/jcasc/jenkins-config.yaml"
JV_OPT3="-Dhudson.model.DownloadService.noSignatureCheck=true"

helm install jenkins edu/jenkins \
--namespace ci-cd \
--create-namespace \
--set controller.nodeSelector."kubernetes\.io/hostname"=cp-k8s \
--set controller.tolerations[0].key=node-role.kubernetes.io/control-plane \
--set controller.tolerations[0].effect=NoSchedule \
--set controller.tolerations[0].operator=Exists \
--set controller.admin.password=admin \
--set controller.initContainerEnv[0].name=JENKINS_UC \
--set controller.initContainerEnv[0].value=$JK_CFG/update-center/update-center.json \
--set controller.initContainerEnv[1].name=JENKINS_UC_DOWNLOAD \
--set controller.initContainerEnv[1].value=https://updates.jenkins.io/download \
--set controller.image.tag=2.440.3-jdk17 \
--set controller.serviceType=LoadBalancer \
--set controller.servicePort=80 \
--set controller.jenkinsOpts="$JK_OPT1 $JK_OPT2" \
--set controller.javaOpts="$JV_OPT1 $JV_OPT2 $JV_OPT3" \
--set persistence.storageClass=managed-nfs-storage
