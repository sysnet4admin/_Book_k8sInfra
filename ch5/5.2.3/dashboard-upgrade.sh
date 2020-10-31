#!/usr/bin/env bash
helm upgrade dashboard \
--set service.type="LoadBalancer" \
--set dashboard.printName="${USERNAME}" \
--set dashboard.persistentVolume.existingClaim="dashboard" \
--set dashboard.color="green" \
edu/dashboard