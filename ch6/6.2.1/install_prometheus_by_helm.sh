#!/usr/bin/env bash
helm install prometheus edu/prometheus \
--namespace monitoring \
--create-namespace \
--set prometheus-pushgateway.enabled=false \
--set alertmanager.enabled=false \
--set prometheus-node-exporter.tolerations[0].key=node-role.kubernetes.io/control-plane \
--set prometheus-node-exporter.tolerations[0].effect=NoSchedule \
--set prometheus-node-exporter.tolerations[0].operator=Exists \
--set server.securityContext.runAsGroup=1000 \
--set server.securityContext.runAsUser=1000 \
--set server.securityContext.runAsNonRoot=false \
--set server.statefulSet.enabled=true \
--set server.persistentVolume.storageClass="managed-nfs-storage" \
--set server.service.type="LoadBalancer" \
--set server.extraFlags[0]="web.enable-lifecycle" \
--set server.extraFlags[1]="storage.tsdb.no-lockfile" 
