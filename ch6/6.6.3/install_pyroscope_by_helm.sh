#!/usr/bin/env bash
helm upgrade --reuse-values grafana-stack edu/grafana-stack \
--namespace monitoring \
--create-namespace \
--set pyroscope.enabled=true \
--set pyroscope.pyroscope.persistence.enabled=true \
--set pyroscope.pyroscope.persistence.storageClassName="managed-nfs-storage"
