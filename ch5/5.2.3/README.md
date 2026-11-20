# Helm

## How to add the helm chart?
```bash
helm repo add edu https://k8s-edu.github.io/Bkv2_main/helm-charts
```

## How to install the helm chart?
```bash
helm install <release-name> <repo-name>/<chart-name>
```
For instance 
```bash 
helm install csi-nfs-release edu/csi-driver-nfs
helm install jenkins edu/jenkins 
```

## What kind of charts to support for installation?
```bash 
helm search repo <rep-name> 
```

## Prerequisite
```bash 
bash nfs_exporter.sh dynamic-vol
```
