#!/usr/bin/env bash
helm install dashboard edu/dashboard \
--set service.type="LoadBalancer" \
--set dashboard.printName="${USERNAME}"