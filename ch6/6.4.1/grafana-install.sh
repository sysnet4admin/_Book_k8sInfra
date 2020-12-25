#!/usr/bin/env bash
helm install grafana edu/grafana \
--set persistence.enabled=true \
--set persistence.existingClaim=grafana \
--set service.type=LoadBalancer \
--set adminPassword="admin" \ 
--set securityContext.runAsUser=1012 \
--set securityContext.runAsGroup=1012