#!/usr/bin/env bash
helm install grafana edu/grafana \
--set persistence.enabled=true \
--set persistence.existingClaim=grafana \
--set service.type=LoadBalancer 