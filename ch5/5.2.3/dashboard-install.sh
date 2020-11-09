#!/usr/bin/env bash
helm install dashboard \
--set service.type="LoadBalancer" \
--set dashboard.printName="${USERNAME}" \
--set dashboard.persistentVolume.existingClaim="dashboard" \
edu/dashboard
