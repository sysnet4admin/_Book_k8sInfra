#!/usr/bin/env bash
helm install grafana-stack edu/grafana-stack \
--namespace monitoring \
--create-namespace \
--set loki.enabled=true \
--set loki.deploymentMode=SingleBinary \
--set loki.singleBinary.persistence.enableStatefulSetAutoDeletePVC=false \
--set loki.singleBinary.persistence.storageClass="managed-nfs-storage" \
--set fluent-bit.enabled=true \
--set fluent-bit.loki.host=grafana-stack-loki-gateway.monitoring.svc.cluster.local \
--set fluent-bit.tolerations[0].key=node-role.kubernetes.io/control-plane \
--set fluent-bit.tolerations[0].effect=NoSchedule \
--set fluent-bit.tolerations[0].operator=Exists
