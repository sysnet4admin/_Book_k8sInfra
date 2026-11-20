#!/usr/bin/env bash
helm upgrade --reuse-values grafana-stack edu/grafana-stack \
--namespace monitoring \
--create-namespace \
--set tempo.enabled=true \
--set tempo.persistence.enabled=true \
--set tempo.persistence.storageClassName="managed-nfs-storage"
