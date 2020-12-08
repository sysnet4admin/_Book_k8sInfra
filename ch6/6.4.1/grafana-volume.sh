apiVersion: v1
kind: PersistentVolume
metadata:
  name: grafana
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: 192.168.1.10
    path: /nfs_shared/grafana
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi