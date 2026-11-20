#!/usr/bin/env bash
helm upgrade --install colosseum edu/colosseum \
--namespace colosseum \
--create-namespace \
--set monitoring.mode=trace
