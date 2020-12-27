#!/usr/bin/env bash
helm upgrade dashboard edu/dashboard \
--set service.type="LoadBalancer" \
--set dashboard.printName="${USERNAME}" \
--set dashboard.color="green"
